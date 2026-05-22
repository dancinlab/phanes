# Changelog

Chronological log of notable changes. One section per ship batch, date-keyed.

For the full audit trail, see `git log`.

---

## 2026-05-22

- **project.tape SSOT** — project identity + governance consolidated into `project.tape`; interim Spec Kit scaffolding removed. `@D t_downstream_discipline` added (consume `hexa kick`, patch upstream).
- **domain doc split** — UPPERCASE domain docs + `PLAN.md` absorbed: `design.md` → `DESIGN.log.md` + `DESIGN.md` pointer; `GOAL.md` / `ROADMAP.md` `## Log` sections extracted to `.log.md` siblings; `PLAN.md` follow-ons absorbed into `ROADMAP.md` P6.

## 2026-05-21

- **web hero rework** — 5 hero images, text-above-image layout, Cloudflare Static Assets.
- **constitution v1.0.0** — hexa-lang pointer · tenant-verifier authority.

## 2026-05-20

- **deploy hardening** — 5-min keep-warm cron + `sleepAfter` widened (`10m` → `1h`, then `24h` on both tiers) to dodge the Cloudflare Containers wake-from-sleep wedge.
- **i18n** — hero blocks, demo scenarios, login & dashboard, and the remaining pages' body prose translated to 5 languages.

## 2026-05-19

- **LIVE** — phanes deployed at `https://dancinlab.org` (Cloudflare Containers 2-tier · R2 data plane · `phanes-jobs` CF Queue). Linux self-host build solved, container images built, Workers Paid activated. `hello@dancinlab.org` wired into the Contact page for early-access & enterprise.
