// phanes — Cloudflare Worker front for the Containers deploy.
//
// Decision 22 (2-tier) + 24 (queue = REST, no Worker↔Queue binding):
//  - PhanesWeb   : the HTTP tier. The Worker forwards every inbound
//                  request to a web container instance (sessions live
//                  on R2 → instances are interchangeable, B2 step-3).
//  - PhanesWorker: the kick tier. A persistent container running
//                  service/queue_worker.sh, which itself HTTP-pulls the
//                  `phanes-jobs` CF Queue over the REST API (Decision
//                  24) — so no CF-Queue Worker binding is needed here.
//
// The exact CF Containers lifecycle semantics (sleepAfter, instance
// wake) are validated at `wrangler deploy`; this encodes the intent.
import { Container, getContainer } from "@cloudflare/containers";

// The container needs PHANES_ROLE + the R2 / CF-Queue credentials as
// env vars. The 7 secrets are bound to the *Worker* (wrangler secret
// put); they are NOT automatically visible inside the container — so
// each Container subclass copies them from the Worker env into its
// envVars in the constructor.
function _phanesEnv(role, env) {
  return {
    PHANES_ROLE:          role,
    R2_ACCESS_KEY_ID:     env.R2_ACCESS_KEY_ID     || "",
    R2_SECRET_ACCESS_KEY: env.R2_SECRET_ACCESS_KEY || "",
    R2_ACCOUNT_ID:        env.R2_ACCOUNT_ID        || "",
    R2_BUCKET:            env.R2_BUCKET            || "phanes",
    PHANES_Q_ACCOUNT_ID:  env.PHANES_Q_ACCOUNT_ID  || "",
    PHANES_Q_ID:          env.PHANES_Q_ID          || "",
    PHANES_Q_TOKEN:       env.PHANES_Q_TOKEN       || "",
  };
}

// Shared canonical lifecycle for both tiers (@cloudflare/containers 0.3.x).
// Root cause of the 2026-05-24 outage: the SDK defaults have NO self-heal.
// A web instance stopped listening on :8787 (wedge / crash) and, because
// the default onError() only logs+rethrows and onActivityExpired() only
// SIGTERMs, the dead instance was never evicted — so every request 500'd
// ("container is not listening in the TCP address 10.0.0.1:8787") for days.
// These two overrides are the SDK-native fix: hard-evict (SIGKILL) a failed
// or sleep-expired instance so the next fetch wakes a clean one.
class PhanesContainer extends Container {
  defaultPort = 8787;            // phanes-http binds 0.0.0.0:8787

  // sleepAfter = "24h" + a 5-min keep-warm cron (wrangler.jsonc triggers
  // .crons) → pinged every 5 min, so under normal operation it never
  // reaches the sleep threshold. The 24h cap is the cron-failure safety
  // net — bounds cost to ≤1 idle day per outage.
  sleepAfter = "24h";

  // Default onActivityExpired() calls stop() (SIGTERM); a wedged hexa
  // process can ignore SIGTERM and hang — exactly the wake-from-sleep
  // wedge of containers#162. destroy() SIGKILLs, guaranteeing the
  // instance is gone so the next request wakes a clean one.
  async onActivityExpired() {
    await this.destroy();
  }

  // Default onError() only logs + rethrows, leaving the instance wedged
  // and every subsequent request 500ing. Hard-evict first so the next
  // request re-rolls a fresh instance, then rethrow so CF records it.
  async onError(error) {
    try { await this.destroy(); } catch { /* already gone */ }
    throw error;
  }
}

export class PhanesWeb extends PhanesContainer {
  constructor(ctx, env) {
    super(ctx, env);
    this.envVars = _phanesEnv("web", env);
  }
}

export class PhanesWorker extends PhanesContainer {
  // The kick tier polls the queue forever; the shared 24h sleepAfter +
  // keep-warm cron keeps it past the max job wall (F-D22 measured
  // 75 s/5-rounds).
  constructor(ctx, env) {
    super(ctx, env);
    this.envVars = _phanesEnv("worker", env);
  }
}

export default {
  async fetch(request, env) {
    // single web container instance (scale via max_instances); sessions
    // on R2 make any instance able to serve any request.
    return getContainer(env.PHANES_WEB).fetch(request);
  },

  // 5-min keep-warm tick (wrangler.jsonc triggers.crons "*/5 * * * *"):
  // ping BOTH containers so neither reaches the sleepAfter threshold
  // → containers#162 wake-wedge never fires. The web ping doubles as a
  // /v1/healthz probe; the worker ping just guarantees the consumer
  // process exists (it pulls phanes-jobs via REST, Decision 24).
  async scheduled(_event, env) {
    await Promise.all([
      getContainer(env.PHANES_WEB).fetch(
        new Request("http://web/v1/healthz")
      ),
      getContainer(env.PHANES_WORKER).fetch(
        new Request("http://worker/healthz")
      ),
    ]);
  },
};
