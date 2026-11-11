# NEW-jobwright · part 1 · aidlc-onboard (confirm)

Run 2026-11-11 on `main` at d612731 (slice 0 merged), branch `feat/NEW-jobwright-onboard-confirm`. Drafts for
Prashant Sharma to review in the pull request: the `AGENTS.md` diff and `docs/codebase-map.md`. Nothing here is an
approval.

## Commands run
k3d cluster stopped first (no k3d container; only the owner's `ai-lab-*` containers running).

| Command (AGENTS.md) | Result | Note |
|---|---|---|
| `scripts/check.sh lint && scripts/check.sh test` | exit 0; web 2, .NET 2 (0 skipped), dev.sh 3 | first try: `pnpm: command not found`; works with the pinned toolchain on PATH, now the first line of Commands |
| `scripts/check.sh build` | exit 0, 0 warnings, three images built | |
| `scripts/check.sh browser` | host: 8 failed (no Chromium 1254 on the host); in the pinned Playwright image: 8 passed | the image command is now in Commands |
| `scripts/check.sh budget` | in the image: 1 passed, 135,165 B in 5 responses (budget 163,840) | measured value recorded in the Quality bar |
| `scripts/dev.sh` | API `/health/live` 200 and web 200 within 10 s; PostgreSQL accepting on 15432; Keycloak listening on 18080; all four on 127.0.0.1 only; SIGTERM: stopped in 5 s, 0 containers, 0 listeners, 0 processes | SIGINT from a background non-interactive shell is ignored by bash, so the probe used SIGTERM (dev.sh traps both) |
| `pnpm -C web exec vitest run src/lib/utils.test.ts` | 2 passed | path is relative to `web/` |
| `dotnet test --project api/tests/Jobwright.Api.Tests` | total 1, failed 0, skipped 0 | |
| `pnpm -C web exec playwright test tests/e2e/skeleton.spec.ts` (in the image) | 4 passed through `bash -c`; called directly: `exec format error` | pnpm's launcher has no shebang line (E6) |
| `check_recipe_commit.py 366edc2 --recipe <slice-0-ports RECIPE> --count <its count command>` | exit 0, "reproduces, the test count is unchanged" | |
| `run_slices.py` | `--help` only | kept `(not yet run)`: no delegate slice so far |

## Probe questions (fresh context, AGENTS.md and the map only), judged against the design
| Question | Verdict | Gap |
|---|---|---|
| What it does and talks to | right (new-system.md, ADR 0001 to 0004) | where telemetry goes: not in either file (part 3) |
| How to check a change | right, with setup and the image | the "done" line names lint and test only; browser and budget are enforced but not in it (proposal 1) |
| Where a realistic change goes | right on contract first, tenant rules, page and test patterns | endpoint code, generated client and data access have no pattern yet: part 3 names them |
| What it must never do | right, with reasons | none |
| Where a decision is recorded | existing ADRs right | where a new decision goes was missing: added (aidlc-design at the workspace root) |

Fixed after the probe: dev.sh's k3d detection read as "calls k3d" (it reads `docker ps`); the module rule's CI check
now says it checks nothing until a module has a type (D6); the map no longer calls accepted ADRs drafts; the six gates
named. Not changed: `dotnet test api/Jobwright.slnx` in the map, which the probe doubted, ran green above.

## For Prashant Sharma (decisions, not findings)
1. **Definition of done.** Add `scripts/check.sh browser` and `budget` (in the image) to the "must pass before you
   report done" line for any change under `web/`? Today they are enforced only in CI.
2. **Branch protection.** The repository is public, so GitHub Free offers branch protection on `main`. Mark slice 0's
   six checks (setup, lint, test, build, browser, budget) as required? This touches KL1 (spec v3); S2 already sends it
   to the workspace root.
3. **The four `(CI also checks this)` claims.** Three were not true today (the guard, the schema check, the chart
   test); the diff says they are planned. Confirm the wording, or name where each check comes from.

## Dispositions (2026-11-11)
Decided by Claude at Prashant Sharma's instruction; he may overturn any of them. Source:
`../stories/NEW-jobwright/decisions-2026-11-11.md`, decisions 1 to 3.

| # | Disposition | Where it landed |
|---|---|---|
| 1 | Yes: for any change under `web/`, the "must pass before you report done" line adds `scripts/check.sh browser` and `budget`, run in the pinned Playwright image | `AGENTS.md` Commands, branch `docs/NEW-jobwright-part-1-decisions` |
| 2 | Yes, through spec amendment 2 (approved 2026-11-11, spec v4, ADR 0014): `main` requires setup, lint, test, build, browser and budget, administrators included, no review (KL2); `STAGING_TOKEN` moves to the `main`-only environment `staging-release` (S2). Prashant Sharma applied both settings by hand | `AGENTS.md` How work runs here and the Workflows standard, same branch; the GitHub settings |
| 3 | Confirm the merged wording: `main` at f99b998 already says "No CI check yet", "it checks nothing until a module has a type, D6" and "CI will check this: … planned". The slice that adds each check changes it to "CI also checks this" | Nothing to change |
