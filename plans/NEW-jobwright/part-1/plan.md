<!-- aidlc template: plan -->
# Plan: NEW-jobwright · part 1 of 4: slice 0 of jobwright-app (skeleton, commands, CI)

## For the reviewer
- **Asked of:** The tech lead (Prashant Sharma), to approve the plan and its three bundles
- **Record it:** On the work item (the story's files, tracker undecided, requirements Q1), with the plan's version and commit
- **Tier and main risk:** 3: a generator or template adds a package, file or setting the approved design does not name, and it reaches `main` unreviewed; second, CI permissions or an unpinned action
- **Changed since the last version:** first version

Inputs read: [spec v3](../../../../stories/NEW-jobwright/spec.md) (approved 2026-11-09), the approved
[design note](../../../../stories/NEW-jobwright/design-note.md) and
[design amendment 1](../../../../stories/NEW-jobwright/design-amendment-1.md),
[`new-system.md` v2](../../../../stories/NEW-jobwright/new-system.md) (APPROVED v2, 2026-11-09; it takes the place of
the codebase map on route G), [coordination plan v2](../../../../stories/NEW-jobwright/coordination-plan.md) (part 1),
ADRs 0001, 0002, 0004, 0010, 0011, 0012 (drafts, accepted). No evidence pack: discover did not run (route G).

Restatement confirmed by Prashant Sharma, 2026-11-10, with four answers: three slices on one branch; the API's
`/health/live` in slice 0; the budget rule "measured × 1.2, rounded up to the next 10 KB"; dev ports 55080 (API) and
55300 (web). Assumptions stated and not corrected: Tier 3 hands-on; CI without secrets or publishing; generator
placeholders removed; `dev.sh` detects k3d without calling it; the local toolchain is fixed by the owner before build.

```text
SPEC       v3 (approved 2026-11-09). Route G: slice 0 builds only the skeleton (spec, Sources). It proves no AC on its own;
           it lays the ground for AC27 (the gates report on a pull request), AC12 (the axe command), AC26 (the budget
           harness and its number), and answers U13 (ArchUnitNET on xunit.v3 4.x) and U15 (Actions minutes).
           Clarifications (2026-11-10, Prashant Sharma): K1 three slices on one branch and one pull request;
           K2 the API answers /health/live in slice 0 (path of the draft contract; the contract itself lands in part 3's
           first slice, whose ContractDocumentTests then covers it); K3 the budget is the skeleton home page's measured
           script bytes × 1.2, rounded up to the next 10 KB; K4 dev.sh runs the API on 127.0.0.1:55080 and the web app on
           127.0.0.1:55300.

APPROACH   Run the approved SCAFFOLD exactly, as a scaffold recipe commit, and stop for review (slice-0-scaffold). Then by
           hand, tests first: pin every direct dependency to new-system.md's Pinned versions with lock files, remove the
           generators' placeholders, add one real behaviour test on each side (the API's /health/live through the
           in-process host; the web's cn() class merging), the architecture smoke test (U13), and scripts/check.sh with
           its test, lint and build modes (slice-0-skeleton). Then the three Dockerfiles, scripts/dev.sh with a test of
           its refusal, the browser harness (one page check, the axe scan, the budget test) and .github/workflows/ci.yml
           running the COMMANDS on every pull request and push to main, each gate seen red once in a draft pull request
           (slice-0-ci). Nothing is published and no secret is read: images are built, never pushed (part 3).

FILES      (slice-0-scaffold: generator output only)
           web/**                                   create-next-app 16.4.5 output, then shadcn 4.23.0 init and add
           api/Jobwright.slnx                       dotnet new sln (U10: .slnx expected on SDK 10; a .sln is a stop)
           api/src/Jobwright.{Api,Worker,Admin,SharedKernel}/**   the three hosts and the shared kernel (ADR 0001)
           api/src/Modules/{Tenancy,Tenancy.Contracts,Identity,Identity.Contracts}/**   increment 1's modules (ADR 0001)
           api/tests/Jobwright.Api.Tests/**         xunit3 project: the health test (K2)
           api/tests/Jobwright.ArchitectureTests/** xunit3 project: the module boundary smoke test (ADR 0001, U13)
           .config/dotnet-tools.json                tool manifest pinning dotnet-ef 10.0.14 (migration bundles, later)
           (slice-0-skeleton: by hand)
           .gitignore                               bin/, obj/, test results, .next/ and node_modules/ never committed
           global.json                              SDK 10.0.403, rollForward disabled; dotnet test on Microsoft Testing Platform
           api/Directory.Build.props                nullable, warnings as errors, RestorePackagesWithLockFile (locked restore in CI)
           api/Directory.Packages.props             central package versions: the only place a .NET version is written
           api/**/packages.lock.json                NuGet lock files, read by `dotnet restore --locked-mode`
           api/**/*.csproj, api/Jobwright.slnx      versions moved to central management; projects added to the solution
           api/src/Jobwright.Api/Program.cs         WeatherForecast removed; /health/live mapped (K2)
           api/tests/Jobwright.Api.Tests/HealthLiveTests.cs           the API's real behaviour test
           api/tests/Jobwright.ArchitectureTests/ModuleBoundaryTests.cs  ADR 0001's rule; U13's smoke test
           api/**/Class1.cs, UnitTest1.cs (deleted)  generator placeholders (quality floor: no placeholder)
           web/package.json, web/pnpm-lock.yaml     exact pins; packageManager pnpm@12.18.0; scripts test, lint,
                                                    format:check, typecheck; engines node 26.13.0
           web/.npmrc or web/pnpm-workspace.yaml    lifecycle scripts blocked except an allowlist (CI setup, new-system CI 1)
           web/.prettierrc.json, web/.prettierignore  Prettier 3.9.10 (S5)
           web/vitest.config.ts                     Vitest 5.1.0, unit tests only (tests/e2e excluded)
           web/src/lib/utils.test.ts                the web's real behaviour test (cn merges conflicting classes)
           web/src/app/page.tsx, layout.tsx         create-next-app's demo page replaced by a minimal "Jobwright" page
           web/public/*.svg (deleted)               the demo page's images
           scripts/check.sh                         the COMMANDS of new-system.md: test, lint, build
           (slice-0-ci: by hand)
           Dockerfile.web, Dockerfile.api, Dockerfile.worker   images from official bases by digest, non-root user;
                                                    the worker image also carries Jobwright.Admin (ADR 0001)
           .dockerignore                            keeps node_modules, bin, obj, .git out of the build context
           web/next.config.ts                       output: 'standalone' for Dockerfile.web (checked, see FACTS)
           scripts/dev.sh                           PostgreSQL 17.11 on 127.0.0.1:55432, Keycloak 26.8.2 on 127.0.0.1:58080,
                                                    then API on 55080 and web on 55300 (K4); refuses while k3d runs
           scripts/tests/test_dev.sh                plain-bash test with a fake docker on PATH: dev.sh refuses a running k3d
           web/playwright.config.ts                 Playwright 1.65.0; webServer `next start` on 127.0.0.1:55300; 360 and 1440 px,
                                                    light and dark projects
           web/tests/e2e/skeleton.spec.ts           the home page answers with the Jobwright heading
           web/tests/e2e/accessibility.spec.ts      axe (@axe-core/playwright 4.14.0), WCAG 2.2 AA tags, every page, light/dark, 360/1440
           web/tests/e2e/budget.spec.ts             AC26 harness: sums script bytes of the first load; fails above the budget (K3)
           .github/workflows/ci.yml                 the gates as independent jobs, pinned by SHA, permissions contents: read,
                                                    no secrets, concurrency per pull request (C7, C8)
           scripts/check.sh                         adds the dev.sh test to `test`, and `browser` and `budget` modes
           (every slice) plans/NEW-jobwright/part-1/**  this plan, the bundles, the progress notes, the part index

TESTS      Slice 0 proves no spec criterion; each foundation it lays maps to a named check:
           AC27 (part)  ci.yml: each gate (setup, lint, test, build, browser, budget) reports on the draft pull request,
                        and each is seen red once by a deliberate failure pushed to that draft, then reverted
                        (evidence: run links in the progress note of slice-0-ci)
           AC12 (harness) web/tests/e2e/accessibility.spec.ts `AC12 every page has no WCAG 2.2 AA violation` (browser,
                        four projects: 360/1440 × light/dark); seen red once with a deliberate contrast fault, local
           AC26 (harness) web/tests/e2e/budget.spec.ts `AC26 first load stays within the script budget` (browser);
                        seen red once with the budget set to 1 byte, local
           K2           api/tests/Jobwright.Api.Tests/HealthLiveTests.cs `HealthLive_answers_200_without_authentication`
                        (in-process host, Microsoft.AspNetCore.Mvc.Testing; Category=Unit)
           U13 / ADR 0001  api/tests/Jobwright.ArchitectureTests/ModuleBoundaryTests.cs
                        `Modules_reference_only_SharedKernel_and_Contracts` (ArchUnitNET; seen red once with a temporary
                        Tenancy -> Identity reference, local, not committed)
           web          web/src/lib/utils.test.ts `cn keeps the last of two conflicting Tailwind classes` (Vitest unit)
           dev.sh       scripts/tests/test_dev.sh `refuses while a k3d cluster runs` (by name and by label),
                        `refuses when docker does not answer`, `fails naming the port when 55432 is taken` (bash, fake docker)
           page         web/tests/e2e/skeleton.spec.ts `home page answers with the Jobwright heading` (browser)
FIRST      none: the spec's edge cases (E1 to E31) belong to the criteria of parts 3 and 4. Slice 0's own edge cases:
           a generator adds an unlisted package or file (stop, see STOP IF); a lock file resolves a transitive version
           not in Pinned versions (listed in the pull request for review, new-system.md); dev.sh with a k3d cluster
           running (test_dev.sh); a port already taken (dev.sh fails naming the port).

ORDER      1 slice-0-scaffold   the recipe commit only; stops for the person's review of generated code (every mode)
           2 slice-0-skeleton   needs 1 reviewed; ends with `scripts/check.sh lint && scripts/check.sh test` green and
                                `scripts/check.sh build` green without the docker builds (they come in 3)
           3 slice-0-ci         needs 2; ends with every AGENTS.md command green locally and CI's gates reported on the
                                draft pull request, each seen red once
           Stop where it fails: a stop in 1 goes to the design's approver (new-system.md); a stop in 2 or 3 to the tech
           lead. aidlc-verify and aidlc-review run once, after 3, on the one pull request; then aidlc-onboard (confirm).

RISKS      R-a A generator adds an unlisted package (expected: @types/react-dom from create-next-app;
               Microsoft.Extensions.Hosting from the worker template; possibly coverlet.collector from xunit3, and
               eslint helpers) -> stop at the pin step; the design's approver decides each (OPEN Q1)
           R-b A generator writes an agent rules file (web/AGENTS.md, CLAUDE.md or similar) that agents would then load
               -> STOP IF in slice-0-scaffold; the person decides whether it stays
           R-c Pinning down from what the generators resolved breaks the build -> the pin step runs the build; a version
               that will not work is a stop for the design's approver, never a silent bump
           R-d ArchUnitNET 0.13.5 fails on xunit.v3 4.x under the Testing Platform (U13) -> the design's fallback: a
               reflection test over project references, no library; the person approves the switch in the bundle
           R-e The budget is measured on the unsigned skeleton page, not the signed-in Overview (AC26's wording) ->
               accepted by Prashant Sharma with K3: the number is the skeleton's; part 3 moves the test to the
               Overview and must stay within it
           R-f The local toolchain differs from the pins (FACT: no Node or pnpm; .NET SDK 10.0.114, not 10.0.403;
               docker does not answer; no actionlint) -> the owner installs the pinned versions before build (OPEN Q3);
               slice-0-scaffold's first step checks each version and stops on a difference
           R-g A workflow leaks a secret or runs an unpinned action -> every `uses:` by 40-character SHA from
               new-system.md's list, actionlint in the lint gate, permissions contents: read, no secret referenced
               (ADR 0011); securing-code review of ci.yml in slice-0-ci
           R-h CI minutes: browser and docker builds are the costliest -> gates ordered cheapest first, caches keyed by
               the lock files, artifacts kept 3 days (ADR 0011); minutes measured (U15, OPEN Q4)
           R-i Docker builds fail because the base images' digests are not resolved -> the build session resolves each
               pinned tag to its digest from the registry and records the source; no tag-only FROM

REJECTED   One slice-0 bundle -> one review of ~700 hand-written lines; rejected by the person (K1)
           Two parts (two pull requests) -> changes the coordination plan for little gain; rejected (K1)
           Web health route instead of the API's /health/live -> the API would have no behaviour test until part 3;
               the person chose K2
           Browser tests against the built image in slice 0 -> needs the image passed between jobs (minutes, storage);
               slice 0 runs them against `next start`; part 3 moves them to the images by digest (ADR 0011, C24)
           Calling `k3d cluster list` in dev.sh -> would need the gitops repository's guard (AGENTS.md); a `docker ps`
               name filter needs neither
           A bats or shunit2 harness for test_dev.sh -> a new dependency; plain bash suffices

ROLLBACK   Nothing is deployed and nothing is published. Before merge: drop the branch, or revert a slice's commits
           (each slice reverts alone; slice 3 depends on 2, 2 on 1). After merge: revert the merge commit on main.

OPEN       Q1 Packages the generators add that DEPENDENCIES does not list (R-a): approve each with a version, or remove
              -> Prashant Sharma (design approver); blocks slice-0-skeleton's pin step
           Q2 shadcn init's prompts: the approved command has no flags, so it asks questions -> Prashant Sharma: answer
              them by hand in slice-0-scaffold (recorded in its progress note), or amend new-system.md with flags;
              blocks slice-0-scaffold
           Q3 Install Node.js 26.13.0, pnpm 12.18.0 (via packageManager), .NET SDK 10.0.403, a working Docker and
              actionlint 1.7.12 on the machine -> Prashant Sharma; blocks slice-0-scaffold
           Q4 U15: minutes of one pull request run and one main-branch run (read from the Actions usage after the
              draft pull request and the merge) -> Prashant Sharma; blocks only the monthly estimate (ADR 0011):
              estimate = minutes per PR run × PR runs a month + minutes per main run × merges a month
           Q5 Story index at the root still shows "aidlc-onboard (prepare) | jobwright-app | to do", although
              part-1/README.md and commit aba6d07 show it done -> the workspace root updates it
           Q6 pnpm 12 refuses dependency build scripts not in allowBuilds and exits non-zero (FACT, pnpm.io), so
              create-next-app's own install may stop before a lock file exists (C2) -> Prashant Sharma (design
              approver): (a) add `--skip-install` to the create-next-app command in new-system.md, and install in
              slice-0-skeleton once allowBuilds is written (proposed); or (b) name the builds to allow before the
              recipe runs; blocks slice-0-scaffold
           Q7 new-system.md CI writes `dotnet test --filter Category=Unit`; under xunit.v3 on the Testing Platform
              the option is `--filter-trait "Category=Unit"`, and `--filter` is rejected with exit code 5 (FACT,
              xunit.net) -> Prashant Sharma (design approver) corrects new-system.md; blocks part 3's split gates only
              (slice 0 runs every test in one gate)
           Q8 Pre-approve the design's U13 fallback (a reflection test over project references, no library), so a
              failing ArchUnitNET does not stop slice-0-skeleton mid-way (C11) -> Prashant Sharma; the bundle stops
              until he answers

FACTS      (checking-official-docs, see "Facts checked" below)

STRESS     (stress-testing-decisions, see "Challenged" below)

Checklist: every criterion maps to a check; every file has a reason; every risk mitigated or
accepted; no architecture decision hidden; rollback concrete; slices safe in order; each brief
has a scope test and concrete stop conditions.

APPROVAL   plan.md <version> (commit <sha>) approved by <tech lead>, <YYYY-MM-DD>. Conditions: <...>
```

## Hidden decisions flagged for their owner

- **New dependency:** none beyond `new-system.md`. The generators may add some (Q1); none is accepted here.
- **Change to the approved COMMANDS:** `scripts/check.sh test` also runs `scripts/tests/test_dev.sh`, and check.sh
  gains `browser` and `budget` modes for CI's gates 8 and 9, which `new-system.md` names but gives no command.
  AGENTS.md's Quality bar says the axe and budget commands are "written by slice 0". The AGENTS.md lines they fill
  are a person's edit, in `aidlc-onboard (confirm)`.
- **Contract first (ADR 0004):** `/health/live` is API code before `api/contract/openapi.yaml` exists. Decided by
  the tech lead, K2. The path and its 200 match the draft contract, so part 3's ContractDocumentTests covers it.
- **Shared module behaviour, infrastructure, integration pattern:** none.

## Facts checked

checking-official-docs, 2026-11-10, read on the vendors' own pages. The build checks again anything it relies on
beyond these (each bundle's USE SKILLS).

| Label | Finding | Source | Used in |
|---|---|---|---|
| FACT | `dotnet new sln` writes `.slnx` by default from .NET 10; `--format sln\|slnx` exists since SDK 9.0.200 | learn.microsoft.com/dotnet/core/tools/dotnet-new-sdk-templates | slice-0-scaffold (U10) |
| FACT | global.json selects the Testing Platform with `"test": { "runner": "Microsoft.Testing.Platform" }`, a top-level sibling of `"sdk"`; needs the platform 1.7 or later. No official example shows both together (INFERENCE that they combine; the schema allows it) | learn.microsoft.com/dotnet/core/tools/global-json; …/testing/unit-testing-with-dotnet-test | slice-0-skeleton step 1 |
| FACT | xunit.v3 on the Testing Platform filters with `--filter-trait "Category=Unit"`; VSTest's `--filter` is rejected (exit code 5) | xunit.net/docs/getting-started/v3/microsoft-testing-platform; learn.microsoft.com | Q7; part 3 |
| FACT | On the Testing Platform, xunit.runner.visualstudio and Microsoft.NET.Test.Sdk can be removed; xUnit advises keeping them until every environment uses the platform (as new-system.md does) | xunit.net, same page | slice-0-skeleton step 2 |
| FACT | `output: 'standalone'` writes `.next/standalone/server.js`; `public/` and `.next/static` are copied by hand; `PORT` and `HOSTNAME` set the address | nextjs.org/docs/app/api-reference/config/next-config-js/output | slice-0-ci step 3 |
| FACT | `next lint` is removed in Next.js 16; lint is the ESLint CLI with flat config `eslint.config.mjs` | nextjs.org/docs/app/api-reference/config/eslint | slice-0-skeleton step 8 |
| FACT | `request.sizes().responseBodySize` is the received body size, encoded (as transferred). Chromium-specific notes: UNKNOWN; the budget test runs in Chromium and its stability is checked by three measurements (STOP IF over 5% apart) | playwright.dev/docs/api/class-request | slice-0-ci step 2 |
| FACT | Dark mode: `use: { colorScheme: 'dark' }` per project, or `page.emulateMedia` | playwright.dev/docs/emulation | slice-0-ci step 2 |
| FACT | A top-level `permissions:` block sets every permission it does not name to `none`. Whether same-repository pull-request runs receive repository secrets is UNKNOWN (the pages state only the fork rule), so ci.yml references no secret at all | docs.github.com, workflow syntax; using secrets | slice-0-ci step 4 |
| FACT | pnpm 11+ replaces onlyBuiltDependencies with `allowBuilds`; packages not listed are disallowed; `strictDepBuilds` defaults to true, so an install with unreviewed build scripts exits non-zero; `--frozen-lockfile` is the CI default when a lock file exists | pnpm.io/settings/build; pnpm.io/cli/install | Q6; slice-0-skeleton step 3 |

## Challenged

stress-testing-decisions, 2026-11-10: a fresh reviewer, given only the decision paragraph and its assumptions, briefed
to oppose. Thirteen objections; each answered with evidence, a change, or a risk for its owner.

| ID | Objection | Severity | Answer |
|---|---|---|---|
| C1 | The generators are not reproducible: shadcn init prompts, shadcn add copies from the live registry, `dotnet new` output depends on the SDK patch | blocker | Evidence: a `(scaffold)` recipe is never re-run by the recipe check; the person reviews it as generated code (aidlc-build step 5). Change: the prompts are OPEN Q2; slice-0-scaffold step 1 stops unless the SDK is 10.0.403; the progress note records every resolved version. Accepted risk (Prashant Sharma, at plan approval): next week's registry may give different component files |
| C2 | create-next-app runs `pnpm install` before anything limits build scripts; `dotnet new install` changes the user-wide template store | blocker | Change: OPEN Q6 (proposed: `--skip-install`, so the first install runs in slice-0-skeleton after allowBuilds exists); STOP IF in slice-0-scaffold when an install exits on unreviewed builds. Evidence: pnpm 12 does not run unlisted build scripts by default (FACT, Facts checked), so nothing unvetted runs, the install stops instead. The template store: accepted risk (Prashant Sharma), undone by `dotnet new uninstall xunit.v3.templates` |
| C3 | "Stop on every unlisted package" will stall slice-0-skeleton | serious | Evidence: @types/node and @tailwindcss/postcss are listed (new-system.md DEPENDENCIES); transitive versions are reviewed in the pull request, not stopped on (new-system.md, above its block). Change: Q1 is answered once, as a batch, from the scaffold's progress note, before slice-0-skeleton starts |
| C4 | Lock files drift between the machine and CI: Node 25+ ships no corepack; a NuGet lock file without the runtime identifier fails a locked restore in Docker | serious | Change: Q3 installs pnpm 12.18.0 on its own (corepack is not relied on); CI installs it with pnpm/action-setup (pinned), which reads packageManager. slice-0-skeleton step 2 sets `RuntimeIdentifiers` linux-x64 in Directory.Build.props so the lock files cover the images' restore; slice-0-ci step 3 restores in Docker with `--locked-mode` |
| C5 | global.json's exact SDK pin and the SDK image or the runner's SDK can disagree | serious | Change: Dockerfile.api and Dockerfile.worker build in the SDK image whose tag names 10.0.403 exactly, by digest; CI installs the SDK with actions/setup-dotnet's `global-json-file: global.json`. A mismatch fails the build, which is the pin working |
| C6 | The skeleton × 1.2 budget is exceeded by part 3's first real Overview, and raising it then is a loosened check; "script bytes" is undefined | serious | Change: the measure is defined in slice-0-ci step 2 (encoded bytes of every script response of the production build's first load, empty cache, until the network is idle, Chromium, three runs). Risk for acceptance by Prashant Sharma, who chose K3 and owns ADR 0010: the number may be too tight for part 3. Raising it later needs a recorded exception (AGENTS.md Quality bar) or a design amendment; a looser rule can be chosen now instead |
| C7 | A red drill per gate costs a full run each, and with `needs:` chains the later gates never show red | serious | Change: the gates are independent jobs (no `needs:` between them, setup repeated per job from caches), so each reports on its own. The drill is one commit that breaks every gate at once, each for its own reason, then one revert: two runs. Each red is recorded with its failing line, to show it failed for the right reason. Accepted risk: drill commits and their logs stay in GitHub's history (no secret is in reach) |
| C8 | About 2,000 minutes a month; an agent iterating could spend them, and then every check stops | serious | Evidence: accepted by ADR 0011 (Consequences) and KL1. Change: `concurrency` per pull request with cancel-in-progress on pull_request runs; U15 measured in slice-0-ci (Q4). Agents never push (AGENTS.md), so runs start only when the person pushes |
| C9 | Nothing enforces the gates on Free | serious | Evidence: KL1 and E28, decided by the spec owner (spec v3) |
| C10 | dev.sh's k3d check fails open when docker does not answer; the name filter misses a renamed cluster | serious | Change: dev.sh refuses when `docker` does not answer, and checks k3d's container label as well as the `k3d-` name prefix; test_dev.sh gains `refuses when docker does not answer` and a label-only case |
| C11 | The architecture test passes vacuously while the modules are empty; switching to the fallback stops mid-slice | minor | Evidence: the deliberate Tenancy -> Identity violation shows the rule fails (slice-0-skeleton step 6); the rule becomes meaningful as part 3 adds types. Change: the test also asserts that every module assembly was loaded. Q8 asks to pre-approve the fallback |
| C12 | Browser tests against `next start` leave the image's headers and runtime untested until part 3 | minor | Accepted (REJECTED above; ADR 0011's C24 moves them to the images in part 3); AC14 and AC15 are part 3's criteria |
| C13 | dev.sh's credentials could be committed | minor | Evidence: slice-0-ci step 1 generates throwaway credentials per run, never committed; gitleaks arrives in part 3 |

Simplest alternative considered: write the skeleton by hand without generators, and keep CI to setup, lint, test
and build, adding axe and the budget in part 3. Not taken: new-system.md's SCAFFOLD is the design approver's decision
and AGENTS.md says slice 0 writes the axe and budget commands. Changing either is a design amendment for Prashant
Sharma, not a planning choice.
