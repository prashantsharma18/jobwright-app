<!-- aidlc template: progress-note -->
# Progress · NEW-jobwright · slice-0-ci

Session state, not memory: it lets a fresh session resume from the record.
File: `plans/NEW-jobwright/part-1/progress-slice-0-ci.md`, committed on its own as the slice's first commit,
then with the slice; the compliance reviewer and the slice runner read it.

```text
STATUS      stopped: steps 0 to 5 done; the dev ports move (E1) needs plan v4 and bundle slice-0-ci v4 before step 6
MODE        hands-on
```

## Restatement (delegate modes)
- Not applicable: hands-on. The restatement was given in the session and confirmed by Prashant Sharma, 2026-11-11,
  with its ten flagged points (see Assumptions)

## Pauses confirmed (by the person)
- checkpoint 4 confirmed by Prashant Sharma, 2026-11-11 (recorded at his instruction: "do these part A steps for
  me"; with it, the drill takes three runs, E10)
- checkpoint 2 confirmed by Prashant Sharma, 2026-11-11 (recorded at his instruction; with it, E5: "10 KB" is
  10,240 bytes, so the budget is 163,840)

## Session plan
- [x] 0 Baseline before any change: `scripts/check.sh lint && scripts/check.sh test` exit 0 (web 1 file, 2 passed;
      .NET total 2, failed 0, skipped 0). Docker answers (server 29.4.2); no container named k3d-* or labelled
      app=k3d; 55432, 58080, 55080, 55300 free; actionlint 1.7.12 in ~/.local/bin. Restatement confirmed. This note
      committed on its own
- [x] 1 dev.sh, tests first (babae09) — scripts/tests/test_dev.sh red against a dev.sh with no refusals, for the
      expected reasons (k3d: "exit status: 0", calls "docker run ...;dotnet run ..."; silent docker: "calls: docker run
      ..."; port: "exit status: 0"); then green: "test_dev.sh: 3 passed, 0 failed". `scripts/check.sh test` exit 0
      (web 2 passed; .NET total 2, failed 0, skipped 0; dev.sh 3 passed). FACT k3d v5.9.0 pkg/types/defaults.go:
      DefaultRuntimeLabels {"app": "k3d"}, plus k3d.version; FACT keycloak.org/server/containers:
      KC_BOOTSTRAP_ADMIN_USERNAME and KC_BOOTSTRAP_ADMIN_PASSWORD with start-dev.
      Real run: OPEN, blocked by the machine (see Decisions, E1): Docker Desktop refused to publish 127.0.0.1:55432
      ("ports are not available: exposing port TCP 127.0.0.1:55432 -> 127.0.0.1:0: /forwards/expose returned
      unexpected status: 500"); dev.sh exited 125 and its cleanup left no container, no credentials, no port bound
- [x] 2 Browser harness, tests first (06e18b0 the dependencies, a03108a the harness) — files: web/package.json, web/pnpm-lock.yaml, web/playwright.config.ts,
      web/tests/e2e/{skeleton,accessibility,budget}.spec.ts, web/.gitignore, web/eslint.config.mjs, scripts/check.sh.
      Committed after checkpoint 2:
      - `pnpm -C web add -D -E @playwright/test@1.65.0 @axe-core/playwright@4.14.0`: the lock adds exactly five
        packages: @playwright/test, playwright, playwright-core 1.65.0 (Microsoft's), @axe-core/playwright and
        axe-core 4.14.0 (Deque's); no build script; the only other lock change is next's peer key naming
        @playwright/test
      - Playwright 1.65.0 wants Chromium revision 1254 (browsers.json); the cache holds 1247, so local browser runs
        use the pinned image mcr.microsoft.com/playwright:v1.65.0-noble@sha256:6e3fb709...273d with the host's Node
        26.13.0 mounted read-only (command under Assumptions); no browser installed
      - skeleton and AC12 green at once (the page exists), then both red with one temporary edit of page.tsx, never
        committed (heading "Jobright", class text-[#bbbbbb]): 8 failed; AC12: `"rule": "color-contrast"` on /;
        skeleton: "expect(locator).toBeVisible() failed ... element(s) not found"; page.tsx restored, no diff
      - AC26 red at a 1-byte budget: "Expected: <= 1  Received: 135165". Measured four times (one fresh build, three
        on the same build): 135,165 bytes in 5 script responses each time, spread 0 % (STOP IF is > 5 %). Encoded:
        `next start` serves the chunks with Content-Encoding: gzip (e.g. raw 229,283 -> 71,760). Budget (K3):
        135,165 × 1.2 = 162,198 -> rounded up to 16 × 10,240 = 163,840 bytes (160 KB); green at it
      - `scripts/check.sh browser` (in the image): 8 passed, 0 failed, 0 skipped; `scripts/check.sh budget`: 1 passed;
        `scripts/check.sh lint` exit 0 after Prettier formatted two of the new files
      - Screenshots (inspected): home page at 360 and 1440, light and dark: the heading "Jobwright" centred, black on
        white, no overflow or clipping; dark identical to light (no theme until part 3); the heading renders in a serif
        fallback, not Geist (see Decisions, E3); not-found page at 360 light: Next's default "404 | This page could not
        be found."
      CHECKPOINT 2: Prashant Sharma looks at the four screenshots, the measured bytes and the number
- [x] 3 Images (2a861a8; 869961e moves Playwright to the standalone server) — `scripts/check.sh build` exit 0: next
      build compiled; dotnet build -c Release "0 Warning(s) 0 Error(s)"; the three docker builds tagged
      jobwright-{web,api,worker}:local. FACT from `docker image inspect`: aspnet and runtime 10.0.14 set APP_UID=1654
      and ASPNETCORE_HTTP_PORTS=8080, default user root; node:26.13.0 has user node (1000), npm 11.20.0, no corepack.
      Each image started (no host port published, E1; probed from inside its network namespace with the node image's
      curl): web uid 1000 (node), / 200 with `<h1 class="text-3xl font-semibold">Jobwright</h1>`; API uid 1654 (app),
      /health/live "Healthy 200"; worker uid 1654, running, 0 restarts, logging "Worker running at", /app/admin holds
      Jobwright.Admin.dll. Containers removed. With output: 'standalone', next start warned '"next start" does not work
      with "output: standalone" configuration. Use "node .next/standalone/server.js" instead.', so Playwright's
      webServer now copies .next/static and runs server.js (restatement point 5); browser 8 passed, budget 1 passed at
      the same 135,165 bytes, no warning. Lint and test exit 0 after the step
- [x] 4 CI — .github/workflows/ci.yml, committed after checkpoint 4. Every action SHA matches its tag
      (`git ls-remote`, annotated tags peeled): checkout v7.0.1, setup-node v7.1.0, pnpm/action-setup v6.1.1,
      setup-dotnet v6.1.0, upload-artifact v7.0.2 (and cache v6.1.0, not used). Inputs read from each action.yml at
      its SHA. actionlint 1.7.12 sha256 8aca8db96f1b94770f1b0d72b6dddcb1ebb8123cb3712530b08cc387b349a3d8 from
      actionlint_1.7.12_checksums.txt (its GitHub release). Local: `actionlint -shellcheck= -pyflakes=` exit 0; the
      SHA rule passes 24 uses: lines and catches `actions/checkout@v7` in a scratch file; `git grep -n "secrets\."
      .github` finds nothing. CHECKPOINT 4: Prashant Sharma reads the permissions and every uses: line
- [x] 5 Draft pull request https://github.com/prashantsharma18/jobwright-app/pull/1 (opened by Prashant Sharma, who
      pushes every commit). Runs, each gate's failing line from its log:
      - first run https://github.com/prashantsharma18/jobwright-app/actions/runs/42964529734 (b084658): lint red, a real fault, fixed (E12)
      - green https://github.com/prashantsharma18/jobwright-app/actions/runs/42965610747 (84e5644): all six green; 1:44 wall clock, 5:48 job time (U15)
      - DRILL 1 https://github.com/prashantsharma18/jobwright-app/actions/runs/42966349758 (96f71d6, vitest 5.1.1 without the lock): all six red at `pnpm -C web install
        --frozen-lockfile`; setup: "Error: ERR_PNPM_OUTDATED_LOCKFILE ... - vitest (lockfile: 5.1.0, manifest: 5.1.1)"
      - DRILL 2 https://github.com/prashantsharma18/jobwright-app/actions/runs/42966685123 (5a1a690, after the revert 1ccc75c): setup green; lint "[warn] next.config.ts ... Code
        style issues found in the above file"; test "failed Jobwright.Api.Tests.HealthLiveTests.HealthLive_answers_200_
        without_authentication ... Assert.Equal() Failure: Values differ Expected: OK Actual: NotFound"; build "COPY
        api/drill-missing.props api/ ... "/api/drill-missing.props": not found"; browser 4 failed (AC12 in all four
        projects, "rule": "color-contrast"), 4 passed (the skeleton test); budget "AC26 script bytes: 135165 in 5
        responses (budget 1) ... Expected: <= 1 Received: 135165"
      - revert 9e6c1dc: the tree outside plans/ is identical to 1b0aca9 (`git diff --stat 1b0aca9 HEAD -- .
        ':!plans'` empty); https://github.com/prashantsharma18/jobwright-app/actions/runs/42967216637 (9b5f3f9): all six green (setup 0:35, test 0:42, lint 0:43, budget 1:10,
        browser 1:14, build 1:52)
      Step 5 DONE: each of the six gates seen green, red for its own reason, green again (AC27, part)
- [ ] 6 BLOCKED until bundle v4 (E1): every AGENTS.md command run locally, counts read; boundary check and self-review (aidlc-build steps 8, 9);
      report; index row; this note and the index committed together

## Skills loaded
- aidlc:building-ci-pipelines — plugin version 5.0.0
- aidlc:testing-in-browser — plugin version 5.0.0
- aidlc:writing-tests — plugin version 5.0.0
- aidlc:securing-code — plugin version 5.0.0
- aidlc:checking-official-docs — plugin version 5.0.0
- aidlc:committing-changes — plugin version 5.0.0

## Deviations
- none yet

## Amended assertions seen red
- none (the bundle lists none)

## Image digests (step 1 and step 3)
Command: `docker buildx imagetools inspect <tag>` (Docker 29.4.2), 2026-11-11; the index digest (all platforms):
- postgres:17.11 — sha256:ff87138949ad9a46f32ff23bd6852b52ce024a13dffe9b4087be98292cdd3b4f (OCI index)
- quay.io/keycloak/keycloak:26.8.2 — sha256:723b1d6e254c0fc96d5cffec860c7e0744d6a3277822b865bb538cf891575e41
- node:26.13.0 — sha256:438603bbb5cda404b9416f0b5c8026f61501ab911760d861ec28c36b5d675725
- mcr.microsoft.com/dotnet/sdk:10.0.403 — sha256:212fe4cb74627d5adf9817a4088906ae3edff1bd853bb27565d4b46731efe61e
- mcr.microsoft.com/dotnet/aspnet:10.0.14 — sha256:1a48394b6f29d3a32c79d9edecd4abda0ecbe8776d567dbfc4590ed6979c740c
- mcr.microsoft.com/dotnet/runtime:10.0.14 — sha256:4f1f30cf0bb4ab0c8b2daa84613051683456f8df4a9bf7c812e20d74962992ac
- mcr.microsoft.com/playwright:v1.65.0-noble — sha256:6e3fb709361521eb27161606e6da6d2674e5e89fa16516cb37d6fdd91372273d

## Decisions made while working (for the PR)
- E1 (step 1, for Prashant Sharma) Windows holds three of the four approved ports. `netsh interface ipv4 show
  excludedportrange protocol=tcp` lists dynamic (not administered) exclusions 55007-55106, 55268-55367 and
  55368-55467, which hold 55080, 55300 and 55432; 58080 is free. Docker Desktop cannot publish a port in them, so
  dev.sh's real run and step 3's image checks with a published port fail on this machine. The ports are K4's and
  requirements 9.5's, so nothing in the repository changes. The owner frees them (an elevated
  `net stop winnat` then `net start winnat` usually releases dynamic exclusions; a reboot may move them back), and the
  real run is repeated at step 6. Until then dev.sh is proved by test_dev.sh only.
  DECIDED by Prashant Sharma, 2026-11-11: move the dev ports below Windows' dynamic range (49152-65535; `netsh
  interface ipv4 show dynamicport protocol=tcp`), so neither WinNAT nor the lab is touched. Not freeing them: no
  process listens on them (netstat), they are reservations of hns or winnat (INFERENCE: netsh names no owner), and
  `net stop winnat` would briefly cut the lab's published ports and may not survive a reboot. Candidates checked
  free on WSL (ss) and Windows (netstat), outside every excluded range, absent from jobwright-gitops and from the
  lab's list: PostgreSQL 15432, Keycloak 18080, API 15080, web 15300 (new numbers to be confirmed in the plan).
  NOT APPLIED IN THIS BUNDLE: the four numbers are plan K4's, this bundle's MUST NOT, new-system.md COMMANDS (line
  69) and AGENTS.md (line 46). Route: aidlc-plan drafts plan v4 (K4) and bundle slice-0-ci v4 (MUST NOT's port list,
  a DO step moving dev.sh, test_dev.sh, launchSettings.json, Jobwright.Api.http, web/package.json and
  web/playwright.config.ts); the workspace root updates new-system.md; Prashant Sharma edits AGENTS.md; he approves
  the plan and bundle. The slice cannot close (DONE WHEN: dev.sh green locally) until that step lands
- E2 (step 2) Local browser runs set PNPM_CONFIG_VERIFY_DEPS_BEFORE_RUN=false in the container only. Without it,
  pnpm's default `verifyDepsBeforeRun: install` (FACT, pnpm.io/settings/build) reinstalled all 596 packages into a
  new store at the repository root (`.pnpm-store/`, 622 MB; the container's mounts are separate filesystems). Both
  stray stores were deleted (untracked, created by this session) and the host's node_modules restored with
  `pnpm -C web install --frozen-lockfile --offline` (storeDir again ~/.local/share/pnpm/store/v11). Not a repository
  setting; CI installs inside its own container
- E3 (step 2, for part 3) The home page's heading renders in a serif fallback: layout.tsx sets --font-geist-sans and
  --font-geist-mono, but no class applies them. Not changed: no DO step names it, and fonts are requirements 9.3's
  (part 3, D9). Listed in the pull request
- E4 (step 2) The skeleton test also asserts that the page logs no console error (testing-in-browser), inside the
  same test, so the counts stay as DONE WHEN gives them
- E6 (step 3) Dockerfile.web's `npm install --global pnpm@12.18.0` prints "1 package has install scripts not yet
  covered by allowScripts: pnpm@12.18.0 (preinstall: node install.js; postinstall: node install.js)": npm 11.20.0
  does not run them, and pnpm works without them (the build succeeds). Left so: running them is a script allowance
- E7 (step 3, carried from slice-0-skeleton) The API image logs "Failed to determine the https port for redirect"
  (UseHttpsRedirection) and serves /health/live over http with 200; the redirect never applies in the image. Not
  changed (no DO step names Program.cs); part 3's chart and /health/ready slice decide it
- E8 (step 4) ci.yml choices: actionlint runs with `-shellcheck= -pyflakes=`, as the runner's own shellcheck and
  pyflakes are not pinned; the SHA rule is a grep step in the lint job (actionlint alone does not enforce SHAs);
  checkout keeps no credentials (`persist-credentials: false`); setup-node's pnpm cache and setup-dotnet's NuGet
  cache are keyed by web/pnpm-lock.yaml and api/**/packages.lock.json; each job has a timeout (10 to 30 minutes);
  setup-dotnet's LTS pre-pass is left at its default
- E9 Root .gitignore gains `.pnpm-store/` (E2) and `.env*` (only web/ had it), asked for by Prashant Sharma
  (e1775f1); `git check-ignore -v --no-index` matches .pnpm-store/x, .env, .env.local and api/.env.development
- E10 (step 5) The drill takes three runs, not plan C7's two: every gate job repeats the setup install, so a lock
  mismatch fails all six at the install and hides the other five reasons. Drill 1 breaks setup only (a lock
  mismatch); drill 2 breaks lint, test, build, browser and budget, each for its own reason; then one revert.
  Drill 1 is web/package.json vitest 5.1.0 -> 5.1.1 without the lock: on a clean worktree `pnpm install
  --frozen-lockfile` exits 1 with "ERR_PNPM_OUTDATED_LOCKFILE ... vitest (lockfile: 5.1.0, manifest: 5.1.1)".
  Every job runs that install, so all six go red at it; setup's red is the one this drill proves
  Confirmed by Prashant Sharma with checkpoint 4
- E11 (step 5) DECIDED by Prashant Sharma, 2026-11-11: github.com/prashantsharma18/jobwright-app is PUBLIC. Before
  the push: no token, key or password in any commit of main or the branch (`git log --all -p` scan); the only
  addresses are his noreply, Anthropic's noreply (co-author lines) and one in shadcn's generated code; this note
  names his home path, the lab's container names and the Windows port ranges (kept as the record). Consequences
  for the workspace root to record (ADR 0011, spec KL1, plan C8): standard runners cost no Actions minutes on a
  public repository, so U15 informs speed, not budget; GitHub Free offers branch protection on public repositories,
  so KL1 ("nothing is enforced") can be revisited; the code, plans and every CI log, the drill's red runs included,
  are world-readable. ci.yml needs no change: pull_request runs from forks get a read-only token and no secret
- E12 (step 5) First pull-request run, https://github.com/prashantsharma18/jobwright-app/pull/1, run 42964529734 on
  b084658: setup, test, build, browser and budget green; lint red at `scripts/check.sh lint`: "src/app/layout.tsx(19,50):
  error TS2304: Cannot find name 'LayoutProps'." Cause: LayoutProps is a global type Next.js generates into .next/types
  and next-env.d.ts (both ignored) during next dev or next build; every local typecheck ran on a tree an earlier build
  had left them in, while CI's lint job checks out a clean tree and never builds. Reproduced on a clean `git worktree`
  (same TS2304). Fix: web/package.json `typecheck` is `next typegen && tsc --noEmit`, the documented way to type-check
  without a build (FACT, nextjs.org/docs/app/api-reference/cli/next, "next typegen", added v15.5.0). On the clean
  worktree: typecheck exit 0, then the whole `scripts/check.sh lint` exit 0 (eslint, prettier, typegen and tsc, dotnet
  format, which CI never reached). Not a drill: the gate caught a real fault. Second run, 42965610747 on 84e5644:
  all six green (setup 0:35, lint 0:40, test 0:44, budget 0:59, browser 1:08, build 1:42; 1:44 wall clock, 5:48
  job time in all, the U15 figure; no Actions minutes billed on a public repository, E11)
- E5 (step 2) "10 KB" is read as 10,240 bytes; with 10,000 the budget would be 170,000. Confirmed by Prashant
  Sharma at checkpoint 2

## Assumptions
Confirmed by Prashant Sharma, 2026-11-11 (restatement):
- test_dev.sh holds three tests (k3d by name and by label in one, docker silent, port taken), so the dev.sh count is
  3, not DONE WHEN's 2
- The local browser is the cached Playwright Chromium if its revision matches @playwright/test 1.65.0; otherwise
  Prashant Sharma runs `playwright install chromium`, or the local run uses the pinned Playwright image (agents never
  install tools)
- Chromium only: the four projects (360/1440 × light/dark) and a separate budget project (1 test)
- Light and dark render the same until part 3's theme (ADR 0010); the dark projects emulate `colorScheme: 'dark'`
- Playwright's webServer stays `next start` if the docs confirm it serves standalone builds; otherwise the standalone
  server.js with public/ and .next/static copied
- ci.yml repeats the setup steps per job (a composite action is outside MAY CHANGE); the budget job runs in the same
  pinned Playwright image; plain `docker build` through check.sh, no buildx action, no layer cache
- Dockerfile.web uses node:26.13.0 for both stages (as named); the worker image publishes Worker and Admin to separate
  folders
- dev.sh writes its per-run credentials to a mode-600 file in a mktemp directory outside the repository, prints only
  the path, and removes its containers on exit
- Carried over: D9's Google Fonts egress for the web build (CI and Dockerfile.web); the pnpm audit findings stay
  deferred to part 3 (trivy); UseHttpsRedirection unchanged (the API image serves http)
- Docker is used with the k3d cluster stopped (plan Q3); only containers named jobwright-dev-* and images this slice
  builds are touched, never the owner's ai-lab-* containers
- The pinned toolchain through `PATH=~/.local/opt/node-v26.13.0/bin:~/.local/opt/dotnet-10.0.403:$PATH` and
  `DOTNET_ROOT=~/.local/opt/dotnet-10.0.403`, as in slice-0-skeleton
- `.claude/settings.json` (sandbox disabled, Prashant Sharma's change) is never staged; every commit stages by name
- Local browser command (not in the repository): `docker run --rm --ipc=host --user "$(id -u):$(id -g)" -e HOME=/tmp
  -e PNPM_CONFIG_VERIFY_DEPS_BEFORE_RUN=false -v "$PWD:/repo" -v "$HOME/.local/opt/node-v26.13.0:/opt/node:ro"
  -w /repo -e PATH=/opt/node/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
  mcr.microsoft.com/playwright:v1.65.0-noble@sha256:6e3fb709...273d scripts/check.sh browser|budget`

## Context gaps noticed (B5)
- wrong: slice-0-skeleton's "lint green" (and this slice's) ran on a working tree with .next/types left by earlier
  builds; a clean checkout failed typecheck (E12). Local checks before a push now include a clean worktree
- wrong: bundle DONE WHEN says "dev.sh 2" while TESTS and DO 1 name three tests
- gap: neither the plan nor requirements 9.5 says Windows' dynamic port exclusions (WinNAT) can hold the approved
  dev ports on a WSL2 machine with Docker Desktop (E1)
- gap: the plan's Q3 tool list has no Playwright browser; the cache held another revision (1247 for 1254)
