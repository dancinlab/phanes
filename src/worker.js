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

export class PhanesWeb extends Container {
  defaultPort = 8787;            // phanes-http binds 0.0.0.0:8787
  sleepAfter = "10m";            // HTTP tier may idle between requests
  constructor(ctx, env) {
    super(ctx, env);
    this.envVars = _phanesEnv("web", env);
  }
}

export class PhanesWorker extends Container {
  // The kick tier polls the queue forever; keep it alive well past the
  // max job wall (F-D22 measured 75 s/5-rounds; cushion + the
  // containers#162 sleep-kill guard → queue_worker also sets a long
  // visibility timeout).
  sleepAfter = "30m";
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

  // Hourly tick: ensure the worker-tier container is running so it keeps
  // draining `phanes-jobs`. (The pull loop itself is REST, Decision 24;
  // this only guarantees the consumer process exists.)
  async scheduled(_event, env) {
    await getContainer(env.PHANES_WORKER).fetch(
      new Request("http://worker/healthz")
    );
  },
};
