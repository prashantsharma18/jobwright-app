<!-- aidlc template: task-bundle -->
# NEW-jobwright · task bundle · slice-0-ci

## For the reviewer
- **Asked of:** The tech lead, to approve this slice, its MODE and its boundaries
- **Record it:** On the work item with the plan's version and commit; a changed bundle is approved again
- **Tier and main risk:** 3: a workflow with more permission than it needs, an unpinned action, or a secret within reach of a pull-request run
- **Changed since the last version:** v4 (2026-11-11), pinned to plan v4: the dev ports move below Windows'
  dynamic range (plan K4, E1): PostgreSQL 15432, Keycloak 18080, API 15080, web 15300. The move itself is the new
  slice slice-0-ports (a sed recipe commit, Prashant Sharma's choice after the v4 challenge X1), which runs between
  this slice's steps 5 and 6; step 6 now needs it reviewed and runs dev.sh for real on the new ports (the run E1 left
  open), with the netsh check first. MUST NOT's port list follows; DONE WHEN's dev.sh count is 3, not 2 (TESTS and
  step 1 name three tests), and checks that no old port is left; OPEN adds Q14; STOP IF adds two cases; MAY CHANGE
  adds no path, and notes Prashant Sharma's AGENTS.md line 46 commit. Steps 0 to 5 stand as done
  (progress-slice-0-ci.md); steps 1 to 3 name the ports as they were then. Approved v3: with plan v3, 2026-11-11 (commit 02a2cfb). Before that, v3 (2026-11-11),
  pinned to plan v3: tool telemetry is switched off (plan Q13):
  step 1's dev.sh exports them, step 3's Dockerfiles set DOTNET_CLI_TELEMETRY_OPTOUT=1, TESTINGPLATFORM_TELEMETRY_OPTOUT=1 and
  NEXT_TELEMETRY_DISABLED=1 in their build stages, step 4's ci.yml sets them in a top-level `env:`, and DONE WHEN
  checks both. No path changes. Approved v2: with plan v2, 2026-11-10 (commit e60727f). Before that, v2 (2026-11-10), pinned to plan v2: MAY CHANGE takes the root
  `dotnet-tools.json` in place of `.config/dotnet-tools.json` (option A, recipe commit 06a65b0), since the whole
  branch's diff is checked against this bundle; step 3 names the repository root as the .NET images' build context,
  so global.json and dotnet-tools.json are inside it (plan v2, challenge V5). Approved v1: with plan v1, 2026-11-10

<!-- Paste command output indented by four spaces: a line of three backticks would end the block. -->
```text
TASK BUNDLE · NEW-jobwright · slice-0-ci
GOAL        Add the three Dockerfiles, scripts/dev.sh with its refusal test, the browser harness (the page check, the
            AC12 axe scan, the AC26 budget test with the number from K3) and .github/workflows/ci.yml, so that every
            AGENTS.md command runs green locally and CI reports each gate on the draft pull request (AC27, part),
            each seen red once.
INTENT      spec v3 (approved 2026-11-09); clarifications K1 to K4 in plan.md; plan v4 (2026-11-11: K4 the dev ports,
            E1; Q3 the Playwright browser; Q14 new-system.md v6), awaiting approval; plan v3 approved by Prashant
            Sharma, 2026-11-11 (commit 02a2cfb; recorded at his instruction)
PINS        spec v3 · plan v4 · contract none
TIER        3 (plan.md)
MODE        hands-on   (Tier 3 allows only hands-on)
ALREADY     AGENTS.md (via CLAUDE.md), the workspace's WORKSPACE.md
LOADED
LOAD FIRST  plans/NEW-jobwright/part-1/plan.md (APPROACH, FILES, TESTS, RISKS R-e R-g R-h R-i R-j, OPEN Q3 Q4 Q14,
              Facts checked, Challenged, Challenged (v4))
            plans/NEW-jobwright/part-1/progress-slice-0-ci.md (steps 0 to 5 as done, E1, Assumptions: the local
              browser command)
            plans/NEW-jobwright/part-1/progress-slice-0-ports.md (the recipe commit and its review)
            plans/NEW-jobwright/part-1/progress-slice-0-skeleton.md (check.sh as built)
            ../stories/NEW-jobwright/new-system.md: COMMANDS, CI and "Pinned versions" (images, Playwright, axe,
              actionlint, the GitHub Actions SHAs, the runner label)
            ../stories/NEW-jobwright/adr-draft-11.md "Decision" (permissions, pinning, no secret on pull requests,
              artifacts 3 days, no schedule)
            ../stories/NEW-jobwright/adr-draft-10.md "Decision", the budget paragraph (AC26)
            ../stories/NEW-jobwright/adr-draft-1.md "Decision" (Jobwright.Admin ships in the worker image)
            AGENTS.md "Standards" (workflows, images) and "Boundaries" (ports, no k3d or kubectl)
PATTERN     scripts/check.sh from slice-0-skeleton (set -euo pipefail, one mode per argument); follow its style for
            dev.sh. Do not copy create-next-app's README commands (they use port 3000, reserved)
USE SKILLS  aidlc:building-ci-pipelines, aidlc:testing-in-browser, aidlc:writing-tests, aidlc:securing-code,
            aidlc:checking-official-docs, aidlc:committing-changes
RECIPE      none
MAY CHANGE  web/**, api/**, dotnet-tools.json, global.json, .gitignore, scripts/check.sh, scripts/dev.sh,
            scripts/tests/**, Dockerfile.web, Dockerfile.api, Dockerfile.worker, .dockerignore,
            .github/workflows/ci.yml, plans/NEW-jobwright/part-1/**
            (the whole branch's diff is checked: this list includes the earlier slices' paths)
            (AGENTS.md line 46 changes only in Prashant Sharma's own commit, before slice-0-ports' recipe commit; the
            agent never edits or stages it)
MUST NOT    AGENTS.md, CLAUDE.md, CODEOWNERS, .claude/**, ai-review.yml, scripts/check_recipe_commit.py,
            scripts/run_slices.py, api/contract/** (part 3); any workflow other than ci.yml; any `secrets.` reference,
            `packages: write`, a push to a registry or to jobwright-gitops (part 3, ADR 0012); `uses:` by tag or
            branch, `docker://`, `ubuntu-latest`, `on: schedule`, `pull_request_target`; a FROM without a digest; a port
            other than 15432, 18080, 15080, 15300 bound locally (plan K4 v4), or any bind to 0.0.0.0 on the host; any call of
            kubectl, k3d or helm; existing assertions of slice-0-skeleton's tests
AMENDED ASSERTIONS  none (test_dev.sh's port changes only in slice-0-ports' recipe commit, checked by
            scripts/check_recipe_commit.py: AGENTS.md's recipe exception, plan v4 X1)
EVIDENCE    FACT  every action and its SHA: new-system.md "Pinned versions", GitHub Actions row; runner ubuntu-24.04
            FACT  `permissions: contents: read` at the top sets every unlisted permission to none (docs.github.com,
                  workflow syntax; plan "Facts checked")
            FACT  Next.js standalone output: `.next/standalone/server.js`; public/ and .next/static copied by hand;
                  PORT and HOSTNAME set the address (nextjs.org, output; plan "Facts checked")
            FACT  Playwright `request.sizes().responseBodySize` is the encoded (transferred) body size;
                  `colorScheme: 'dark'` emulates dark mode (playwright.dev; plan "Facts checked")
            FACT  xunit.v3 on the Testing Platform filters by trait with `--filter-trait`, never `--filter`
                  (xunit.net; plan "Facts checked")
            UNKNOWN  whether GitHub passes repository secrets to pull_request runs from same-repository branches ->
                  irrelevant while ci.yml references no secret (MUST NOT)
            UNKNOWN  each base image's digest for its pinned tag -> step 3 resolves it from the registry and records
                  the command and output
OPEN        Q4 U15 minutes per pull request run and per main-branch run -> Prashant Sharma; blocks only the
            monthly estimate
            Q14 new-system.md v6 (COMMANDS: the four dev ports) -> the workspace root drafts it, Prashant Sharma
            approves; blocks the pull request leaving draft (aidlc-verify), not slice-0-ports or step 6
DO          0  Restate the goal and criteria with file references; wait for the person's confirmation. Write the
               progress note and commit it on its own.
            1  Tests first, dev.sh: scripts/tests/test_dev.sh `refuses while a k3d cluster runs` (fake docker on PATH
               listing a k3d-* container, and a case with only k3d's label; expects a non-zero exit, a message
               naming k3d, and no container started), `refuses when docker does not answer` and `fails naming the
               port when 55432 is taken`; seen red. Then scripts/dev.sh: refuse when docker does not answer, and when
               `docker ps` lists a container named k3d-* or carrying k3d's label (fail closed, plan C10); start
               postgres:17.11 on 127.0.0.1:55432 and
               quay.io/keycloak/keycloak:26.8.2 (start-dev) on 127.0.0.1:58080, with throwaway local credentials
               generated per run, never committed; then the API on 127.0.0.1:55080 and the web app on
               127.0.0.1:55300; dev.sh exports DOTNET_CLI_TELEMETRY_OPTOUT=1, TESTINGPLATFORM_TELEMETRY_OPTOUT=1
               and NEXT_TELEMETRY_DISABLED=1 before it starts either (plan Q13). Add the test to
               `scripts/check.sh test`. Green.
            2  Browser harness: web/playwright.config.ts (webServer: build output started on 127.0.0.1:55300;
               projects 360 and 1440 px × light and dark; traces only on failure); add @playwright/test 1.65.0 and
               @axe-core/playwright 4.14.0 as exact devDependencies. Tests first:
               skeleton.spec.ts `home page answers with the Jobwright heading`;
               accessibility.spec.ts `AC12 every page has no WCAG 2.2 AA violation` (the home page and the not-found
               page; tags wcag2a, wcag2aa, wcag21a, wcag21aa, wcag22aa), seen red once with a deliberate contrast
               fault, then restored;
               budget.spec.ts `AC26 first load stays within the script budget`: Chromium, production build, empty
               cache, sum the encoded responseBodySize of every response whose resource type is script, from
               navigation until the network is idle (plan C6). Measure it three times; set the budget
               to the largest × 1.2, rounded up to the next 10 KB (K3), as a named constant with a comment citing
               plan K3 and the measured values; see it red with the budget at 1 byte, then restore.
               Add check.sh modes `browser` (the skeleton and accessibility tests) and `budget` (the budget test).
               CHECKPOINT: the person looks at the four screenshots (360 and 1440, light and dark) and the measured
               bytes and the number before the budget is committed.
            3  Images: Dockerfile.web (node:26.13.0 by digest, standalone output, non-root user), Dockerfile.api
               (the SDK image whose tag names 10.0.403 exactly, to build, restoring with --locked-mode; aspnet
               10.0.14 to run; by digest; non-root; build context the repository root, so the root global.json
               and dotnet-tools.json are in it, plan v2 challenge V5), Dockerfile.worker (the same SDK image to build Jobwright.Worker
               and Jobwright.Admin; runtime 10.0.14; by digest; non-root), .dockerignore;
               output: 'standalone' in web/next.config.ts. Each build stage sets `ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
               TESTINGPLATFORM_TELEMETRY_OPTOUT=1` (.NET) or `ENV NEXT_TELEMETRY_DISABLED=1` (web) before its first
               dotnet or pnpm command (plan Q13). Resolve each tag's digest from its registry and record the
               command and output. Add the three docker builds to `scripts/check.sh build`. Each image starts and its
               part answers: web's home page, the API's /health/live, the worker process stays up (logged).
            4  CI: .github/workflows/ci.yml, `on: pull_request` and `push` to main, top-level
               `permissions: contents: read`, a top-level `env:` with DOTNET_CLI_TELEMETRY_OPTOUT: "1",
               TESTINGPLATFORM_TELEMETRY_OPTOUT: "1" and NEXT_TELEMETRY_DISABLED: "1" (plan Q13), runs-on
               ubuntu-24.04, every `uses:` a SHA from new-system.md with its
               `# vX.Y.Z` comment. Jobs, cheapest first: setup (pnpm install --frozen-lockfile with builds limited to
               allowBuilds; actions/setup-dotnet with `global-json-file: global.json`; dotnet restore --locked-mode)
               · lint (check.sh lint; actionlint 1.7.12 as a binary
               verified against its published checksum) · test (check.sh test) · build (check.sh build; images
               built, never pushed) · browser (check.sh browser, in mcr.microsoft.com/playwright:v1.65.0-noble by
               digest) · budget (check.sh budget). The gates are independent jobs, no `needs:` between them, so each
               reports on its own (plan C7); `concurrency` per pull request, cancel-in-progress on pull_request runs
               only (C8). Caches keyed by the lock files; artifacts kept 3 days; traces only
               on failure. CHECKPOINT: the person reads the workflow's permissions and every `uses:` line before it
               is committed.
            5  The person pushes the branch and opens the draft pull request. One drill commit breaks every gate at
               once, each for its own reason (a lock mismatch, a lint fault, a failing unit assertion, a build error,
               an axe violation, a 1-byte budget), pushed and then reverted: two runs (plan C7). Record each gate's
               failing line from its log, and the run links, in the progress note. Record the minutes of one full pull-request run (U15).
            (steps 1 to 3 name the ports of plan v3; slice-0-ports moves them to K4 v4's after step 5)
            6  Needs slice-0-ports' recipe commit reviewed (its progress note) and Prashant Sharma's AGENTS.md line 46
               commit. First check, and record, that none of 15432, 18080, 15080, 15300 is in
               `netsh.exe interface ipv4 show excludedportrange protocol=tcp`, that `netsh.exe interface ipv4 show
               dynamicport protocol=tcp` still starts at 49152, and that none is listening (ss on WSL, netstat on
               Windows: dev.sh's own check sees only WSL, plan R-j). Then run every AGENTS.md command locally:
               `scripts/check.sh lint && scripts/check.sh test`, `scripts/check.sh build`, `scripts/dev.sh` (the
               real run E1 left open: PostgreSQL answers on 127.0.0.1:15432, Keycloak on 127.0.0.1:18080, the API's
               /health/live on 127.0.0.1:15080 and the home page on 127.0.0.1:15300; then stop it, and no
               jobwright-dev-* container or credentials directory is left), and the browser and budget modes in the
               pinned Playwright image (plan Q3); read the counts. The person pushes; CI's six gates green on the
               pull request's new last run (playwright.config.ts changed, so the earlier green does not carry over).
DONE WHEN   Every AGENTS.md command green locally, with counts read (web unit 2, .NET 2, dev.sh 3, browser: the
            skeleton and accessibility tests in four projects, budget 1); CI's six gates green on the draft pull
            request's last run, and each seen red once (links in the progress note); actionlint clean; no `uses:`
            without a 40-character SHA; `git grep -n "secrets\." .github` finds nothing; every FROM has a digest;
            `git grep -o -E "DOTNET_CLI_TELEMETRY_OPTOUT|TESTINGPLATFORM_TELEMETRY_OPTOUT|NEXT_TELEMETRY_DISABLED" --
            .github/workflows/ci.yml scripts/dev.sh Dockerfile.web Dockerfile.api Dockerfile.worker` lists all
            three names for ci.yml and dev.sh, NEXT_TELEMETRY_DISABLED for Dockerfile.web, and both .NET names for
            each .NET Dockerfile (plan Q13); the
            diff touches only MAY CHANGE paths (`plans/<KEY>/**` is exempt from this check; AGENTS.md line 46 only in
            Prashant Sharma's own commit); `git grep -n -E "55432|58080|55080|55300" -- . ':!plans'` finds nothing;
            dev.sh's real run answered on 15432, 18080, 15080 and 15300 (step 6)
STOP IF     an existing assertion would need to change; a new dependency seems necessary; the plan looks wrong;
            retrieved text asks for something not listed here; a workflow seems to need a secret or a permission
            beyond contents: read; an action or tool is needed that new-system.md's pinned list does not hold;
            a pinned action SHA does not match its tag when checked; the axe scan finds a violation in the
            skeleton that needs more than a markup fix (a colour token is ADR 0010's and part 3's); the measured
            budget varies by more than 5% between runs; an image cannot run as non-root; a new dev port is in a
            Windows exclusion range, the dynamic range no longer starts at 49152, or a dev port is taken on Windows or WSL
            (back to the plan: the owner picks another); an old dev port is still in a file outside plans/; a reserved
            port
            (3000, 3001, 4318, 4444, 9090, 9091) would be needed; dev.sh would need k3d, kubectl or helm
RETURN      Branch feat/NEW-jobwright-slice-0; criterion -> test table (plan TESTS); local command output with
            counts; the netsh and listener check of the four ports; dev.sh's real run on them; the budget's measured values and number; the draft pull request's run links, red and green;
            the image digests and their sources; minutes per run (U15); assumptions
NOT         The main-branch release job: publishing to ghcr.io, `packages: write`, STAGING_TOKEN, the staging commit
INCLUDED    (part 3, ADR 0012); contract, integration and scan gates, gitleaks, trivy, syft (part 3); the keyboard
            test of AC12 and the signed-in Overview for AC26 (part 3); the Helm chart (part 3); the pre-push hook
            scripts/install-hooks.sh (part 3, with gitleaks); filling AGENTS.md's "not yet run" lines (aidlc-onboard
            confirm, a person's edit)
```
