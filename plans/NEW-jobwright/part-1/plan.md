<!-- aidlc template: plan -->
# Plan: NEW-jobwright · part 1 of 4: slice 0 of jobwright-app (skeleton, commands, CI)

## For the reviewer
- **Asked of:** The tech lead (Prashant Sharma), to approve plan v3 and the two bundles it changes (slice-0-skeleton,
  slice-0-ci, both v3); slice-0-scaffold is done and keeps plan v1
- **Record it:** On the work item (the story's files, tracker undecided, requirements Q1), with the plan's version and commit
- **Tier and main risk:** 3: a generator or template adds a package, file or setting the approved design does not name, and it reaches `main` unreviewed; second, CI permissions or an unpinned action
- **Changed since the last version:** v3 (2026-11-11), from new-system.md v4 (APPROVED v4, root commit 5d38c10),
  which chose xunit.v3 4.0.2 over xunit.v3.mtp-v2, and from the v3 challenge (W1 to W7, "Challenged (v3)"). Q10
  closed. Q11 (decided by Prashant Sharma): xunit's and the platform's transitive packages are expected, not a stop.
  The challenge showed that xunit.v3 is an alias whose platform package changes with its major version (3.2.2:
  mtp-v1; 4.0.2: exactly mtp-v2) and that the vendor's template never writes it; Prashant Sharma then chose
  xunit.v3.mtp-v2 again, so new Q12 sends that to new-system.md v5 and BLOCKS slice-0-skeleton until it is
  approved. FILES: the test projects keep xunit.v3.mtp-v2 and drop `TestingPlatformDotnetTestSupport` with the
  net10.0 retarget (W5, reversing V8's accepted risk). New Q13 (decided): tool telemetry off in check.sh, ci.yml
  and the Dockerfiles. U13's red run must show ArchUnitNET's own message (W4). Four facts added. Bundles:
  slice-0-skeleton v3 and slice-0-ci v3. Plan v2 approved 2026-11-10 (commit e60727f). Before that, v2 (2026-11-10), from the recipe review of slice-0-scaffold (decisions R1 to R9
  and option A in [progress-slice-0-scaffold.md](progress-slice-0-scaffold.md)): OPEN Q1 records what the generators
  actually added and what is kept (cn, @tailwindcss/turbopack, xunit.v3.mtp-v2) or not added (clsx, tailwind-merge,
  @tailwindcss/postcss, the two VSTest packages); FILES moves the tool manifest to the root `dotnet-tools.json` and
  says the scaffold created `global.json`; FILES gains the test projects' net10.0 (R4), shadcn as a devDependency
  (R5) and the dev ports (R7, launchSettings.json); new Q10 sends R1 to R3 and R5 to new-system.md v4 and blocks
  slice-0-skeleton until it is approved; Q3, Q5 and Q9 closed; two facts added; FILES gains the generated
  Jobwright.Api.http (weatherforecast on localhost:5066, missed in v1). The v2 challenge (V1 to V11, "Challenged
  (v2)") added: lint seen red once in slice-0-skeleton, the repository root as the images' build context in
  slice-0-ci, and the alternatives and full lock-file listing Q10 puts to the approver. Plan v1 approved 2026-11-10.

Inputs read: [spec v3](../../../../stories/NEW-jobwright/spec.md) (approved 2026-11-09), the approved
[design note](../../../../stories/NEW-jobwright/design-note.md) and
[design amendment 1](../../../../stories/NEW-jobwright/design-amendment-1.md),
[`new-system.md` v3](../../../../stories/NEW-jobwright/new-system.md) (APPROVED v3, 2026-11-10; v1 of this plan read
v2; it takes the place of the codebase map on route G), [coordination plan v2](../../../../stories/NEW-jobwright/coordination-plan.md) (part 1),
ADRs 0001, 0002, 0004, 0010, 0011, 0012 (drafts, accepted). No evidence pack: discover did not run (route G).
v2 also read: [progress-slice-0-scaffold.md](progress-slice-0-scaffold.md) (the recipe commit 06a65b0, its package
list, option A, R1 to R9) and the generated manifests (web/package.json, web/next.config.ts, web/eslint.config.mjs,
web/src/lib/utils.ts, the test projects' csproj, launchSettings.json, global.json, dotnet-tools.json).
v3 also read: [`new-system.md` v4](../../../../stories/NEW-jobwright/new-system.md) (APPROVED v4, 2026-11-10, root
commit 5d38c10; its "v4 review lists"), the nuget.org nuspecs and package listings of xunit.v3 (4.0.2, 3.2.2),
xunit.v3.mtp-v2 and xunit.v3.core.mtp-v2 4.0.2, the xunit3 template (xunit.v3.templates 4.0.2), the scaffold's
api/tests/Jobwright.Api.Tests/obj/project.assets.json, and the telemetry pages of the .NET SDK, Microsoft Testing
Platform and Next.js. Restatement confirmed by Prashant Sharma, 2026-11-11.

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
           dotnet-tools.json                        tool manifest pinning dotnet-ef 10.0.14 (migration bundles, later); at
                                                    the root, where SDK 10.0.403 writes it (v2, option A; v1 said .config/)
           global.json                              written by the xunit3 template's post-action with only the test runner
                                                    (v2, option A)
           (slice-0-skeleton: by hand)
           .gitignore                               bin/, obj/, test results, .next/ and node_modules/ never committed
           global.json                              completed: SDK 10.0.403, rollForward disabled, beside the generated
                                                    test runner entry (Microsoft Testing Platform)
           api/Directory.Build.props                nullable, warnings as errors, RestorePackagesWithLockFile (locked restore in CI)
           api/Directory.Packages.props             central package versions: the only place a .NET version is written;
                                                    xunit.v3.mtp-v2 4.0.2, no VSTest packages (v3: Q12, new-system.md v5)
           api/**/packages.lock.json                NuGet lock files, read by `dotnet restore --locked-mode`
           api/**/*.csproj, api/Jobwright.slnx      versions moved to central management; projects added to the solution;
                                                    both test projects net8.0 -> net10.0 (R4: one framework for every project)
                                                    and `TestingPlatformDotnetTestSupport` removed from both, as the
                                                    template's net10.0 output does (v3, W5); xunit.v3.mtp-v2 kept (Q12)
           api/src/Jobwright.Api/Program.cs         WeatherForecast removed; /health/live mapped (K2)
           api/src/Jobwright.Api/Properties/launchSettings.json  one http profile on 127.0.0.1:55080 (R7, K4); the
                                                    generated localhost:5066 and https 7131 profiles removed
           api/src/Jobwright.Api/Jobwright.Api.http the generated request file: host 127.0.0.1:55080, its
                                                    /weatherforecast/ request replaced by /health/live (R7; found in v2)
           api/tests/Jobwright.Api.Tests/HealthLiveTests.cs           the API's real behaviour test
           api/tests/Jobwright.ArchitectureTests/ModuleBoundaryTests.cs  ADR 0001's rule; U13's smoke test
           api/**/Class1.cs, UnitTest1.cs (deleted)  generator placeholders (quality floor: no placeholder)
           web/package.json, web/pnpm-lock.yaml     exact pins (Q1 keeps cn, @tailwindcss/turbopack); shadcn moved to
                                                    devDependencies (R5); packageManager pnpm@12.18.0; scripts test, lint,
                                                    format:check, typecheck; dev and start on -H 127.0.0.1 -p 55300 (R7:
                                                    Next.js defaults to port 3000, reserved); engines node 26.13.0
           web/.npmrc or web/pnpm-workspace.yaml    lifecycle scripts blocked except an allowlist (CI setup, new-system CI 1)
           web/.prettierrc.json, web/.prettierignore  Prettier 3.9.10 (S5)
           web/vitest.config.ts                     Vitest 5.1.0, unit tests only (tests/e2e excluded)
           web/src/lib/utils.test.ts                the web's real behaviour test (cn merges conflicting classes)
           web/src/app/page.tsx, layout.tsx         create-next-app's demo page replaced by a minimal "Jobwright" page
           web/public/*.svg (deleted)               the demo page's images
           scripts/check.sh                         the COMMANDS of new-system.md: test, lint, build; exports the three
                                                    tool telemetry opt-outs (v3, Q13)
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
                                                    no secrets, concurrency per pull request (C7, C8); top-level env
                                                    with the tool telemetry opt-outs (v3, Q13; also in each
                                                    Dockerfile's build stage)
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
                        Tenancy -> Identity reference, local, not committed; v3, W4: the red must carry ArchUnitNET's
                        own violation message, not a binding exception)
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
               Outcome (v2): the scaffold added cn, @tailwindcss/turbopack and xunit.v3.mtp-v2 instead; no coverlet,
               no ESLint helper; each decided in Q1 (R1 to R3), recorded in new-system.md by Q10
               Outcome (v3): new-system.md v4 approved with xunit.v3; after the v3 challenge, xunit.v3.mtp-v2 stays
               the direct reference, recorded by new-system.md v5 (Q12); its transitive graph is expected (Q11)
           R-b A generator writes an agent rules file (web/AGENTS.md, CLAUDE.md or similar) that agents would then load
               -> create-next-app does by default (FACT); `--no-agents-md` (Q6); STOP IF any other appears
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

OPEN       Q1 DECIDED (by Claude at Prashant Sharma's instruction, 2026-11-10): packages the generators add that
              DEPENDENCIES does not list. Rule: keep only what the generated code needs and what comes from an
              approved package's own vendor and release line; remove the rest; pin what is kept exactly.
              v1 named the packages expected before the scaffold ran. v2 records what recipe commit 06a65b0 actually
              added and the recipe review's decisions (R1 to R9, progress-slice-0-scaffold.md, taken by Claude at
              Prashant Sharma's instruction, 2026-11-10):
              - @types/react-dom: kept, devDependency, pinned to the 19.3.x the generator resolved (type definitions
                for the approved react-dom 19.3.1, same family as the approved @types/react 19.3.0; the generated
                code imports react-dom's types). A version outside 19.3.x is a stop. Resolved: 19.3.0 (R9)
              - Microsoft.Extensions.Hosting (the worker template's reference): kept, pinned in
                Directory.Packages.props to 10.0.14, the approved runtime's release (Microsoft's own, the worker's
                host). Resolved: 10.0.14 (R9). Part 3 revisits it when the worker gains its health and version
                endpoints (spec A3)
              - cn (added by shadcn 4.23.0; the 7 generated components under web/src/components/ui import it
                directly, `from "cn"`, and web/src/lib/utils.ts re-exports it; every later `shadcn add` will too):
                kept, exact 0.5.2 (R1): shadcn's own package, published with provenance; clsx and tailwind-merge,
                which DEPENDENCIES names for the same job, are not added. Risks accepted in R1: pre-1.0, a reused
                package name, two months old; slice-0-skeleton's cn tests pin its behaviour. v2 adds (challenge V2):
                reversing this later touches every component file, not only utils.ts; the lock also holds cn 0.2.6,
                shadcn's own dependency, which no generated file imports
              - @tailwindcss/turbopack (added by create-next-app; web/next.config.ts loads it as the CSS loader):
                kept, exact 4.3.5 (R2), Tailwind's own, the approved tailwindcss's release; no PostCSS config exists,
                so @tailwindcss/postcss, which DEPENDENCIES names, is not added
              - xunit.v3.mtp-v2 (added by the xunit3 template to both test projects): kept, central pin 4.0.2 (R3,
                reaffirmed in v3 by Q12). new-system.md v4 chose xunit.v3 4.0.2 instead; the v3 challenge showed
                xunit.v3 is an alias for whichever platform package its major version points at, and that the
                template never writes it (W1, W2), and Prashant Sharma chose xunit.v3.mtp-v2 again, for
                new-system.md v5 (Q12). xunit.runner.visualstudio and Microsoft.NET.Test.Sdk are not added (they
                serve VSTest mode only; Facts checked)
              - shadcn: stays (approved, 4.23.0) but moves from dependencies to devDependencies, exact (R5); it is
                needed at build time, since web/src/app/globals.css imports "shadcn/tailwind.css", so it is no
                longer "scaffolding only" as new-system.md says (Q10)
              - coverlet.collector, or any other coverage package: none was added (R9). Coverage is first measured
                at the end of part 3 (AGENTS.md Quality bar); that slice asks for its tool
              - @eslint/eslintrc or another ESLint compatibility helper: none was added; web/eslint.config.mjs
                imports only eslint/config and eslint-config-next
              - versions below their pins (react, react-dom 19.3.0; @types/node 20.19.43; eslint 9.39.5): no
                decision needed (R6); slice-0-skeleton's pin step sets Pinned versions, and a pin that fails is a stop
                (R-c)
              - anything else not listed: a stop for Prashant Sharma, with the package, its version and the file
                that uses it
              Every kept package is listed in the pull request description as "added by the generator, kept under
              Q1"; new-system.md records them through Q10
           Q2 DECIDED (by Claude at Prashant Sharma's instruction, 2026-11-10; he confirms with the plan): shadcn runs
              without prompts, by flags: `init --defaults --base radix --yes --no-monorepo --no-rtl` and `add ... --yes`.
              Why: an agent cannot answer prompts reliably, and answers typed by hand are recorded nowhere but a note;
              `--base radix` matches the approved runtime set (radix-ui in DEPENDENCIES; `base` or `aria` would bring
              unapproved packages); `--defaults` is the documented "--template=next --preset=nova"; `add` defaults
              to a confirmation prompt (`--yes` default false), so the approved add command needs `--yes` too (FACT,
              ui.shadcn.com/docs/cli). Colours come from requirements 9.3's tokens in part 3, so the preset's palette
              is replaced there. A prompt that still appears is a stop
           Q3 CLOSED (v2): the toolchain is installed (node v26.13.0, pnpm 12.18.0, .NET SDK 10.0.403 in
              ~/.local/opt; progress-slice-0-scaffold.md step 1). DECIDED (as Q2): user-level installs, no sudo, each verified against its published checksum and removable
              by deleting its folder; Prashant Sharma runs them (agents never install tools; AGENTS.md):
              Node.js 26.13.0 from nodejs.org/dist (SHASUMS256.txt) into ~/.local/opt/node-v26.13.0;
              pnpm 12.18.0 with that Node's npm (`npm install -g pnpm@12.18.0`), since corepack is not relied on (C4);
              .NET SDK 10.0.403 with Microsoft's dotnet-install.sh (`--version 10.0.403 --install-dir
              ~/.local/opt/dotnet-10.0.403`, apart from ~/.dotnet, which holds the CLI's user state), ahead of
              /usr/lib/dotnet (10.0.114) on PATH with DOTNET_ROOT set to it; actionlint 1.7.12 from its GitHub release (checksums file) into
              ~/.local/bin; Docker: started by Prashant Sharma, 2026-11-10. Docker for the agent (decided as Q2): the
              agent's sandbox cannot reach the socket (FACT: "permission denied ... /var/run/docker.sock"), and the
              socket can stop or change any container, k3d's included (AGENTS.md: agents never change a cluster). So
              slice-0-scaffold and slice-0-skeleton run without it; for the slice-0-ci session only, with the k3d
              cluster stopped, Prashant Sharma allows the socket through `/sandbox` (in .claude/settings.local.json,
              never committed) and removes it when that session ends
           Q4 U15: minutes of one pull request run and one main-branch run (read from the Actions usage after the
              draft pull request and the merge) -> Prashant Sharma; blocks only the monthly estimate (ADR 0011):
              estimate = minutes per PR run × PR runs a month + minutes per main run × merges a month
           Q5 CLOSED (v2): the root story index shows the row done, "merged to main as aba6d07".
              (patch prepared, see Q9) Story index at the root still shows "aidlc-onboard (prepare) | jobwright-app | to do", although
              part-1/README.md and commit aba6d07 show it done -> the workspace root updates it
           Q6 DECIDED (as Q2): the generators install, but no dependency build script runs. They run with
              PNPM_CONFIG_STRICT_DEP_BUILDS=false in their environment only: nothing is in allowBuilds, so every build
              script is disallowed (FACT), the install prints a warning instead of exiting (FACT), and pnpm records
              each ignored build in web/pnpm-workspace.yaml with a placeholder (FACT, pnpm.io/settings/build).
              slice-0-skeleton step 3 then sets each one to true or false, and strict mode, the default, applies to
              every later install and to CI. Nothing is committed that loosens a setting. `--skip-install` (the earlier
              proposal) was dropped: shadcn init and add install packages themselves, so it would only move the
              failure. Also decided: `--no-agents-md` on create-next-app, because it writes AGENTS.md by default
              (FACT, nextjs.org create-next-app reference: "--agents-md ... (default)"), and a web/AGENTS.md would
              become rules every agent loads (R-b). INFERENCE: the variable's name follows the documented
              PNPM_CONFIG_<SETTING> pattern (shown there for other settings). If pnpm ignores it and still exits,
              stop; the fallback is web/pnpm-workspace.yaml with `strictDepBuilds: false` for the scaffold only,
              removed in slice-0-skeleton, which needs the owner
           Q9 CLOSED (v2): new-system.md v3 APPROVED by Prashant Sharma, 2026-11-10 (root commit 82829b3).
              new-system.md's SCAFFOLD differs from slice-0-scaffold's RECIPE by the flags of Q2 and Q6
              (`--no-agents-md`; shadcn's flags; the environment variable) -> the workspace root records the
              change in new-system.md (design approver Prashant Sharma; this repository cannot edit ../stories);
              the bundle's approval stands in until it does. Patch prepared 2026-11-10 (decided at his instruction):
              new-system.md v3 (the scaffold flags, @types/react-dom and Microsoft.Extensions.Hosting, `--filter-trait`,
              an empty APPROVED v3 line for him) and the story index rows of Q5; applied by a session at the root
           Q7 new-system.md CI writes `dotnet test --filter Category=Unit`; under xunit.v3 on the Testing Platform
              the option is `--filter-trait "Category=Unit"`, and `--filter` is rejected with exit code 5 (FACT,
              xunit.net) -> Prashant Sharma (design approver) corrects new-system.md (patch prepared, see Q9); blocks part 3's split gates only
              (slice 0 runs every test in one gate)
           Q8 DECIDED (Prashant Sharma, 2026-11-10): the design's U13 fallback (a reflection test over project
              references, no library) is pre-approved; if ArchUnitNET does not run, slice-0-skeleton writes it and
              removes the ArchUnitNET reference, recording why in its progress note
           Q10 CLOSED (v3): new-system.md v4 APPROVED by Prashant Sharma (tech lead, design approver), 2026-11-10,
              root commit 5d38c10, with the v4 review lists; he chose xunit.v3 4.0.2 over xunit.v3.mtp-v2, which
              the v3 challenge reopened (Q12). The question as v2 put it:
              (v2) new-system.md v3 disagrees with Q1's v2 decisions: DEPENDENCIES names clsx and tailwind-merge (R1
              keeps cn), @tailwindcss/postcss (R2 keeps @tailwindcss/turbopack), xunit.v3 with xunit.runner.visualstudio
              and Microsoft.NET.Test.Sdk "kept ... until the platform mode is proved" (R3 keeps xunit.v3.mtp-v2 and
              adds neither); Pinned versions calls shadcn "scaffolding only" (R5: a build-time devDependency); and
              SCAFFOLD does not say that its commands write the root `dotnet-tools.json` and `global.json`
              (option A) -> the workspace root drafts new-system.md v4 (DEPENDENCIES and Pinned versions:
              cn 0.5.2 for clsx and tailwind-merge; @tailwindcss/turbopack 4.3.5 for @tailwindcss/postcss;
              xunit.v3.mtp-v2 4.0.2 for xunit.v3 and the two VSTest packages, or xunit.v3 4.0.2 if he prefers the
              alternative in Q1; shadcn as a build-time devDependency; the root dotnet-tools.json and the scaffold's
              global.json). For an approval that does not rest on Claude's summary (challenge V1), the v4 draft also
              lists every importer entry of web/pnpm-lock.yaml and every PackageReference against DEPENDENCIES,
              and the scaffold's `allowBuilds` (sharp: false, unrs-resolver: false); and states each alternative
              not taken with its cost: clsx and tailwind-merge in place of cn (every component's import changed,
              again after each `shadcn add`; V2); shadcn/tailwind.css copied into globals.css in place of shadcn as a
              build-time devDependency (shadcn's CSS updates no longer arrive with the package; V3); that
              @tailwindcss/turbopack ties Tailwind to Turbopack (`next build --webpack` and PostCSS-based tools get
              no Tailwind; V9) -> Prashant Sharma (design approver) approves v4. BLOCKS slice-0-skeleton: its build
              starts only after new-system.md v4 is APPROVED (bundle OPEN). If he chooses xunit.v3 over
              xunit.v3.mtp-v2, this plan and the bundle change again before the build
           Q11 DECIDED (Prashant Sharma, 2026-11-11, at plan v3's restatement): new-system.md v4 says xunit.v3 is used
              "alone" and xunit.v3.mtp-v2 "is not used"; but xunit.v3 4.0.2 depends on exactly xunit.v3.mtp-v2
              [4.0.2] (FACT, Facts checked v3), so mtp-v2 is in the lock files under either choice. Decision: xunit's
              and the platform's transitive packages are expected at slice-0-skeleton's step 2 CHECKPOINT and listed
              in the pull request, not a stop; xunit.v3.core.mtp-v2 or xunit.v3.assert at any version other than
              4.0.2 is a stop. The v3 challenge (W3) widened the list beyond the three xunit names: the platform
              also brings Microsoft.Testing.Extensions.Telemetry 2.5.1, Microsoft.ApplicationInsights 2.23.0,
              Microsoft.Win32.Registry 5.0.0, System.Security.AccessControl 6.0.1 and Microsoft.Bcl.AsyncInterfaces
              6.0.0, and ArchUnitNET brings System.Net.Http 4.3.4 and System.Text.RegularExpressions 4.3.1; the
              bundle names each, and Q12's v5 lists them for the design approver
           Q12 CLOSED (2026-11-11): new-system.md v5 APPROVED by Prashant Sharma (design approver), root commit
              fb508de, naming xunit.v3.mtp-v2 4.0.2; slice-0-skeleton is unblocked. Erratum, same day (from that
              commit): the template's option is `--framework` (dotnetcli.host.json maps the symbol Framework to
              longName "framework"; SDK 10.0.403 rejects `--Framework`), corrected below and in W2; no step or bundle
              changes. The question as v3 put it:
              (v3) BLOCKS slice-0-skeleton. Prashant Sharma (design approver), 2026-11-11, after the v3 challenge (W1,
              W2): the test projects reference xunit.v3.mtp-v2 4.0.2, as the template generates them, not new-system.md
              v4's xunit.v3. Why: xunit.v3 is an alias, 3.2.2 for mtp-v1 and 4.0.2 for mtp-v2, so a one-line bump
              could change the platform's major version unseen; the name xunit.v3.mtp-v2 says it; and every
              `dotnet new xunit3` writes it, so no project needs the hand edit -> the workspace root drafts
              new-system.md v5: DEPENDENCIES and Pinned versions name xunit.v3.mtp-v2 4.0.2 in place of xunit.v3
              (xunit.v3.templates 4.0.2 stays); SCAFFOLD's note says slice-0-skeleton changes the test projects to
              net10.0 only, and that later test projects are generated with `dotnet new xunit3 --framework net10.0`;
              the v4 review lists' two test-project rows and the "xunit.v3.mtp-v2 in place of xunit.v3"
              alternative are corrected (mtp-v2 is in the graph under either choice); the transitive packages of
              Q11 are listed for review; and Q13's opt-outs are recorded if he wants them in the design. Prashant
              Sharma approves v5. slice-0-skeleton step 0 stops without an APPROVED v5 line naming xunit.v3.mtp-v2
           Q13 DECIDED (Prashant Sharma, 2026-11-11, from the v3 challenge W3): tool telemetry is switched off wherever
              this repository runs tools: scripts/check.sh exports DOTNET_CLI_TELEMETRY_OPTOUT=1,
              TESTINGPLATFORM_TELEMETRY_OPTOUT=1 and NEXT_TELEMETRY_DISABLED=1 (slice-0-skeleton step 8); ci.yml sets
              them in a top-level env and each Dockerfile's build stage sets its own (slice-0-ci steps 3 and 4).
              Why: Microsoft Testing Platform's telemetry extension, the .NET SDK and Next.js send usage data to their
              vendors by default (Facts checked v3), and the requirements route telemetry only to the owner's lab
              (requirements 9.1, "Telemetry: OpenTelemetry to the owner's lab collector"). No dependency changes.
              A person's own shell is theirs to set; scripts/dev.sh (slice-0-ci) inherits the variables only if it
              sources them, so slice-0-ci step 1 exports them there too

FACTS      (checking-official-docs, see "Facts checked" below)

STRESS     (stress-testing-decisions, see "Challenged" below)

Checklist: every criterion maps to a check; every file has a reason; every risk mitigated or
accepted; no architecture decision hidden; rollback concrete; slices safe in order; each brief
has a scope test and concrete stop conditions.

APPROVAL   plan.md v1 (commit a522963, with Q1 and Q8 as recorded in the commit that records this line) approved by
           Prashant Sharma (tech lead), 2026-11-10, with its three bundles; recorded at his instruction.
           Conditions: risks C1, C2, C6 and C7 accepted by him; Q8 pre-approved; Q1 decided at his instruction;
           Q3 (the toolchain install) and Q9 (new-system.md at the workspace root) still open
           plan.md v2 (commit e60727f) approved by Prashant Sharma (tech lead), 2026-11-10; recorded at his
           instruction. Conditions: the risks accepted in "Challenged (v2)" (V1, V8, and V6's part 3 risk) accepted
           with the plan; Q10 open and blocking slice-0-skeleton. The bundles slice-0-skeleton and slice-0-ci at
           plan v2 (commit e60727f) approved by him, 2026-11-10; recorded at his instruction
           plan.md v3 (commit 02a2cfb) approved by Prashant Sharma (tech lead), 2026-11-11; recorded at his
           instruction. Conditions: "Challenged (v3)" answered with no new risk accepted, V8's risk withdrawn (W5);
           Q11 and Q13 decided by him; Q12 open and blocking slice-0-skeleton until new-system.md v5 is approved.
           The bundles slice-0-skeleton v3 and slice-0-ci v3 (commit 02a2cfb) approved by him, 2026-11-11;
           recorded at his instruction
```

## Hidden decisions flagged for their owner

- **New dependency:** none beyond `new-system.md`, which records what the generators added and OPEN Q1 keeps (@types/react-dom and Microsoft.Extensions.Hosting from v3; cn, @tailwindcss/turbopack and shadcn as a build-time devDependency from v4). v3: the test framework reference is xunit.v3.mtp-v2 4.0.2, a change to v4 that the design approver records in new-system.md v5 (Q12, which blocks slice-0-skeleton). Each is listed in the pull request.
- **Data leaving the machine (v3):** tool telemetry to Microsoft and Vercel is switched off in the repository's scripts, CI and images (Q13, decided by Prashant Sharma).
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
| FACT | create-next-app includes `AGENTS.md` by default (`--agents-md`, "(default)"); `--skip-install`, `--disable-git` and `--no-agent-feedback` exist; `--yes` "uses previous preferences or defaults for all options" | nextjs.org/docs/app/api-reference/cli/create-next-app (updated 2026-09-29) | Q6, slice-0-scaffold |
| FACT | shadcn `init`: `-t/--template`, `-b/--base` (base, radix, aria), `-p/--preset`, `-y/--yes` (default true), `-d/--defaults` (= `--template=next --preset=nova`), `--no-monorepo`, `--no-rtl`, `--css-variables` (default true). `add`: `-y/--yes` (default false), `-o/--overwrite`. The page does not list init's questions | ui.shadcn.com/docs/cli | Q2, slice-0-scaffold |
| FACT | Settings come from the command line, environment variables and pnpm-workspace.yaml; the environment form shown is `PNPM_CONFIG_<SETTING>` (for other settings); `strictDepBuilds: false` prints a warning instead of exiting; ignored builds are added to pnpm-workspace.yaml with a placeholder | pnpm.io/settings; pnpm.io/settings/build | Q6 |
| FACT | (v2) From xunit.v3 4.0.0, `xunit.v3` installs Microsoft Testing Platform v2 by default; `xunit.v3.mtp-v2` selects v2 explicitly; `mtp-v1` exists only for 3.x. On SDK 10, global.json's `test.runner` selects the platform; `TestingPlatformDotnetTestSupport` (in the generated csproj) is described only for SDK 8 and 9. The VSTest packages are needed only in VSTest mode | xunit.net/docs/getting-started/v3/microsoft-testing-platform, read 2026-11-10 | Q1 (R3), Q10; slice-0-skeleton step 2 |
| FACT | (v2) TngTech.ArchUnitNET.xUnitV3 0.13.5 depends on TngTech.ArchUnitNET 0.13.5 and `xunit.v3.assert` >= 1.1.0, not on `xunit.v3`; xunit.v3.mtp-v2 4.0.2 requires `xunit.v3.assert` [4.0.2], so the two resolve together | nuget.org nuspecs of both packages, read 2026-11-10 | slice-0-skeleton step 2, U13 |
| FACT | (v3) xunit.v3 4.0.2's only dependency is xunit.v3.mtp-v2 [4.0.2] (net472 and net8.0 groups); both packages hold only `lib/*/_._` and a README. xunit.v3.mtp-v2 depends on xunit.v3.core.mtp-v2 [4.0.2], xunit.v3.assert [4.0.2] and xunit.analyzers 2.2.0, with no include or exclude attributes. The build logic is in xunit.v3.core.mtp-v2's `buildTransitive/` props and targets | api.nuget.org v3-flatcontainer: the nuspecs and .nupkg listings of xunit.v3, xunit.v3.mtp-v2, xunit.v3.core.mtp-v2 4.0.2, read 2026-11-11 | Q1, Q11; slice-0-skeleton step 2 |
| FACT | (v3) xunit.v3 is an alias for a platform package that changes with its major version: 3.2.2 depends on exactly xunit.v3.mtp-v1 [3.2.2]; 4.0.2 on exactly xunit.v3.mtp-v2 [4.0.2] | api.nuget.org nuspecs of xunit.v3 3.2.2 and 4.0.2, read 2026-11-11 | Q12 (W1) |
| FACT | (v3) The xunit3 template 4.0.2 writes xunit.v3.mtp-v2 (default), xunit.v3.aot.mtp-v2 (NativeAOT) or xunit.v3.mtp-off with the VSTest packages; never xunit.v3. It leaves `TestingPlatformDotnetTestSupport` out when Framework is net10.0 | xunit.v3.templates.4.0.2.nupkg, content/project/xunit3/cs/TestProject.csproj and .template.config/template.json (the copy in ~/.templateengine), read 2026-11-11 | Q12 (W2), W5; slice-0-skeleton step 2 |
| FACT | (v3) The scaffold's test graph (net8.0) holds Microsoft.Testing.Extensions.Telemetry 2.5.1, Microsoft.ApplicationInsights 2.23.0, Microsoft.Win32.Registry 5.0.0, System.Security.AccessControl 6.0.1, Microsoft.Bcl.AsyncInterfaces 6.0.0 | api/tests/Jobwright.Api.Tests/obj/project.assets.json (generated, untracked), read 2026-11-11 | Q11, Q13 |
| FACT | (v3) Opt-outs: TESTINGPLATFORM_TELEMETRY_OPTOUT or DOTNET_CLI_TELEMETRY_OPTOUT set to 1 switches Microsoft Testing Platform's telemetry off; DOTNET_CLI_TELEMETRY_OPTOUT=1 the .NET SDK's; NEXT_TELEMETRY_DISABLED=1 Next.js's | learn.microsoft.com/dotnet/core/testing/microsoft-testing-platform-telemetry; learn.microsoft.com/dotnet/core/tools/telemetry; nextjs.org/telemetry, read 2026-11-11 | Q13 |
| FACT | pnpm 11+ replaces onlyBuiltDependencies with `allowBuilds`; packages not listed are disallowed; `strictDepBuilds` defaults to true, so an install with unreviewed build scripts exits non-zero; `--frozen-lockfile` is the CI default when a lock file exists | pnpm.io/settings/build; pnpm.io/cli/install | Q6; slice-0-skeleton step 3 |

## Challenged

stress-testing-decisions, 2026-11-10: a fresh reviewer, given only the decision paragraph and its assumptions, briefed
to oppose. Thirteen objections; each answered with evidence, a change, or a risk for its owner.

| ID | Objection | Severity | Answer |
|---|---|---|---|
| C1 | The generators are not reproducible: shadcn init prompts, shadcn add copies from the live registry, `dotnet new` output depends on the SDK patch | blocker | Evidence: a `(scaffold)` recipe is never re-run by the recipe check; the person reviews it as generated code (aidlc-build step 5). Change: the prompts are OPEN Q2; slice-0-scaffold step 1 stops unless the SDK is 10.0.403; the progress note records every resolved version. Accepted risk (Prashant Sharma, at plan approval, 2026-11-10): next week's registry may give different component files |
| C2 | create-next-app runs `pnpm install` before anything limits build scripts; `dotnet new install` changes the user-wide template store | blocker | Change: OPEN Q6 (proposed: `--skip-install`, so the first install runs in slice-0-skeleton after allowBuilds exists); STOP IF in slice-0-scaffold when an install exits on unreviewed builds. Evidence: pnpm 12 does not run unlisted build scripts by default (FACT, Facts checked), so nothing unvetted runs, the install stops instead. The template store: accepted risk (Prashant Sharma, 2026-11-10), undone by `dotnet new uninstall xunit.v3.templates` |
| C3 | "Stop on every unlisted package" will stall slice-0-skeleton | serious | Evidence: @types/node and @tailwindcss/postcss are listed (new-system.md DEPENDENCIES); transitive versions are reviewed in the pull request, not stopped on (new-system.md, above its block). Change: Q1 is answered once, as a batch, from the scaffold's progress note, before slice-0-skeleton starts |
| C4 | Lock files drift between the machine and CI: Node 25+ ships no corepack; a NuGet lock file without the runtime identifier fails a locked restore in Docker | serious | Change: Q3 installs pnpm 12.18.0 on its own (corepack is not relied on); CI installs it with pnpm/action-setup (pinned), which reads packageManager. slice-0-skeleton step 2 sets `RuntimeIdentifiers` linux-x64 in Directory.Build.props so the lock files cover the images' restore; slice-0-ci step 3 restores in Docker with `--locked-mode` |
| C5 | global.json's exact SDK pin and the SDK image or the runner's SDK can disagree | serious | Change: Dockerfile.api and Dockerfile.worker build in the SDK image whose tag names 10.0.403 exactly, by digest; CI installs the SDK with actions/setup-dotnet's `global-json-file: global.json`. A mismatch fails the build, which is the pin working |
| C6 | The skeleton × 1.2 budget is exceeded by part 3's first real Overview, and raising it then is a loosened check; "script bytes" is undefined | serious | Change: the measure is defined in slice-0-ci step 2 (encoded bytes of every script response of the production build's first load, empty cache, until the network is idle, Chromium, three runs). Accepted by Prashant Sharma, 2026-11-10 (plan approval), who chose K3 and owns ADR 0010: the number may be too tight for part 3. Raising it later needs a recorded exception (AGENTS.md Quality bar) or a design amendment |
| C7 | A red drill per gate costs a full run each, and with `needs:` chains the later gates never show red | serious | Change: the gates are independent jobs (no `needs:` between them, setup repeated per job from caches), so each reports on its own. The drill is one commit that breaks every gate at once, each for its own reason, then one revert: two runs. Each red is recorded with its failing line, to show it failed for the right reason. Accepted risk (Prashant Sharma, 2026-11-10): drill commits and their logs stay in GitHub's history (no secret is in reach) |
| C8 | About 2,000 minutes a month; an agent iterating could spend them, and then every check stops | serious | Evidence: accepted by ADR 0011 (Consequences) and KL1. Change: `concurrency` per pull request with cancel-in-progress on pull_request runs; U15 measured in slice-0-ci (Q4). Agents never push (AGENTS.md), so runs start only when the person pushes |
| C9 | Nothing enforces the gates on Free | serious | Evidence: KL1 and E28, decided by the spec owner (spec v3) |
| C10 | dev.sh's k3d check fails open when docker does not answer; the name filter misses a renamed cluster | serious | Change: dev.sh refuses when `docker` does not answer, and checks k3d's container label as well as the `k3d-` name prefix; test_dev.sh gains `refuses when docker does not answer` and a label-only case |
| C11 | The architecture test passes vacuously while the modules are empty; switching to the fallback stops mid-slice | minor | Evidence: the deliberate Tenancy -> Identity violation shows the rule fails (slice-0-skeleton step 6); the rule becomes meaningful as part 3 adds types. Change: the test also asserts that every module assembly was loaded. Q8 asks to pre-approve the fallback |
| C12 | Browser tests against `next start` leave the image's headers and runtime untested until part 3 | minor | Accepted (REJECTED above; ADR 0011's C24 moves them to the images in part 3); AC14 and AC15 are part 3's criteria |
| C13 | dev.sh's credentials could be committed | minor | Evidence: slice-0-ci step 1 generates throwaway credentials per run, never committed; gitleaks arrives in part 3 |

### Challenged (v2)

stress-testing-decisions, 2026-11-10: a fresh reviewer, given only v2's decision paragraph (R1 to R9, option A, the
Q10 blocker) and its labelled assumptions, briefed to oppose; it read the generated files. Eleven objections.

| ID | Objection | Severity | Answer |
|---|---|---|---|
| V1 | The owner has not read the diff and is also the design approver, so v4 could pass on Claude's summary alone; the swap list omits the rest of the lock file and `allowBuilds` | serious | Change: Q10 asks the v4 draft to list every lock-file importer entry and PackageReference against DEPENDENCIES, plus `allowBuilds`. Accepted risk (Prashant Sharma, at plan v2 approval): one person holds both roles (KL1, KL2); his review of the pull request before merge stays the human check (progress note, "Pauses confirmed") |
| V2 | `cn` is imported directly by every component, not through utils.ts, so reversing it touches every file; a second cn 0.2.6 is in the lock | serious | FACT, confirmed: 7 files under web/src/components/ui import `from "cn"`; cn@0.2.6 is in web/pnpm-lock.yaml (shadcn's own dependency). Change: Q1's text corrected; Q10 puts the clsx and tailwind-merge alternative and its cost to the approver. The rest stays R1's accepted risk |
| V3 | shadcn was approved as "scaffolding only"; as a build-time devDependency, a `pnpm install --prod` before `next build` fails | serious | Evidence: `next build` already needs devDependencies (typescript, tailwindcss, @tailwindcss/turbopack), so no image can build after a production-only install; slice-0-ci's Dockerfile.web builds with the full install and ships only the standalone output. Change: Q10 puts the alternative (copy shadcn/tailwind.css into globals.css) to the approver |
| V4 | eslint 10.14.0 differs from the generator's ^9; its plugins could crash or silently skip rules, and exit 0 proves nothing | serious | Evidence: new-system.md Pinned versions, "Supported by eslint-config-next from 16.4.0". Change: slice-0-skeleton step 8 sees lint red once with a react-hooks and a jsx-a11y violation; a plugin that crashes or reports nothing is a stop (R-c) |
| V5 | Root global.json and dotnet-tools.json fall outside an `api/` build context, so the images lose the SDK pin and the test runner; `rollForward` disabled breaks on an image bump | serious | Change: slice-0-ci step 3 names the repository root as the build context. Evidence: the SDK image is pinned to 10.0.403 by digest (plan C5) and Renovate is off (new-system.md v2, "Renovate off"), so no automated bump |
| V6 | `start -H 127.0.0.1` makes a container unreachable; Playwright, Keycloak redirects, CORS and cookies break if localhost and 127.0.0.1 are mixed; the https profile must go too | serious | Evidence: the image runs the standalone server.js with `HOSTNAME` (plan Facts checked; slice-0-ci step 3), never `pnpm start`; Playwright's webServer is `next start` on 127.0.0.1:55300 (FILES), the same as the script; step 3b removes the https profile. Risk for part 3 (owner Prashant Sharma, tech lead): the Keycloak redirect URIs and the API base URL use 127.0.0.1, never localhost (K4) |
| V7 | The ArchUnitNET smoke test passes vacuously over empty modules | serious | Evidence: already planned (C11): slice-0-skeleton step 6 asserts that each module assembly was loaded and shows the rule red with a temporary Tenancy -> Identity reference |
| V8 | Both csproj keep `TestingPlatformDotnetTestSupport` (a bridge for SDK 8 and 9); without the VSTest packages, an IDE's test explorer finds tests only with the platform enabled | minor | Evidence: xunit.net describes the property only for SDK 8 and 9 (Facts checked); INFERENCE: it has no effect on SDK 10 with global.json's runner, so it stays as generated (no DO step edits it). Accepted risk (Prashant Sharma): IDE discovery needs the platform switched on; aidlc-onboard (confirm) writes it into the map. `xunit.runner.json` is xUnit's own configuration under either mode. Superseded in v3 by W5: the property is removed |
| V9 | @tailwindcss/turbopack ties Tailwind to Turbopack; it is still `^4` | minor | Change: Q10 states the tie for the approver. Evidence: step 3 pins it exactly to 4.3.5; the only unit test (cn) needs no CSS |
| V10 | react 19.3.1 moves away from the generator's 19.3.0; react-dom must move with it; pins must hold in the lock file and CI | minor | Evidence: step 3 pins react and react-dom together; the step 3 CHECKPOINT and DONE WHEN read versions from the lock file; `--frozen-lockfile` is CI's default (Facts checked). A peer conflict with next 16.4.5 is a stop (R-c) |
| V11 | No Directory.Packages.props, so versions drift per csproj | minor | Evidence: step 2 creates api/Directory.Packages.props and removes Version= from every PackageReference |

Rollback for v2's changes: nothing is pushed or published. Each slice's commits revert alone, but reversing R1 or
R5 later costs more than a revert: every component's cn import (V2) and the globals.css import (V3) must change.

Simplest alternative considered: write the skeleton by hand without generators, and keep CI to setup, lint, test
and build, adding axe and the budget in part 3. Not taken: new-system.md's SCAFFOLD is the design approver's decision
and AGENTS.md says slice 0 writes the axe and budget commands. Changing either is a design amendment for Prashant
Sharma, not a planning choice.

### Challenged (v3)

stress-testing-decisions, 2026-11-11: a fresh reviewer, given only v3's first decision paragraph (xunit.v3 4.0.2 in
place of xunit.v3.mtp-v2, transitive mtp-v2 accepted) and its nine labelled assumptions, briefed to oppose; it read
the nuspecs, the template package and the generated assets file. Seven objections; the facts behind W1, W2, W3 and W5
were checked again by this session (Facts checked, v3).

| ID | Objection | Severity | Answer |
|---|---|---|---|
| W1 | xunit.v3 is an alias whose platform package changes with its major version (3.2.2: mtp-v1; 4.0.x: mtp-v2), so a one-line bump of the central pin could switch the platform's major version, visible only as a transitive name in the lock files | serious | FACT, confirmed. Change: Prashant Sharma chose xunit.v3.mtp-v2 again (Q12), so the platform's version is in the name a reviewer reads; new-system.md v5 records it and blocks slice-0-skeleton |
| W2 | The vendor's xunit3 template never writes xunit.v3, so every later test project needs a hand edit that nothing enforces; "not used" in v4 contradicts every lock file | serious | FACT, confirmed. Change: Q12 (the template's own package); v5 corrects the v4 rows; later test projects are generated with `--framework net10.0` |
| W3 | Accepting "three xunit names" lets more in: the platform's telemetry extension with Application Insights, registry and access-control packages, and ArchUnitNET's System packages; the telemetry sends usage data to Microsoft by default, while the requirements route telemetry only to the lab | serious | FACT, confirmed (assets file; vendor pages). Change: Q11 and the slice-0-skeleton bundle name every one of them for the CHECKPOINT and the pull request; Q13 (decided by Prashant Sharma) switches tool telemetry off in check.sh, dev.sh, ci.yml and the Dockerfiles. Applies under either xunit choice |
| W4 | Step 6's "show it red" passes on a binding crash (MissingMethodException, TypeLoadException) as well as on a real violation, so U13 could be "proved" by a crash | serious | Change: slice-0-skeleton step 6 counts the red only if the output carries ArchUnitNET's own violation message naming the Tenancy -> Identity dependency |
| W5 | Retargeting by hand keeps `TestingPlatformDotnetTestSupport`, which the template's own net10.0 output leaves out; V8's "no effect" is untested | minor | FACT, confirmed (template `#if (Framework != "net10.0" ...)`). Change (Prashant Sharma, 2026-11-11): step 2 removes the property with the retarget, reversing V8's accepted risk; tests not discovered without it is a stop |
| W6 | On net10.0 the restore prunes packages the framework provides and NuGet audit checks transitive packages, so the lock files will not match the net8.0 graph that was reviewed, and an audit warning under TreatWarningsAsErrors fails the restore | minor | Evidence: both failures are loud. Change: step 2's CHECKPOINT reads the net10.0 lock files as new; STOP IF adds an audit warning that fails the restore (never suppressed: AGENTS.md quality floor) |
| W7 | Rollback is cheap now (two names, one pin, fresh lock files) but becomes a design amendment once merged, and must be repeated in every later test project | minor | Evidence: Q12 takes the reversal now, before any build, when it costs one new-system.md version. Nothing is irreversible: nothing is built, pushed or published |

Risks accepted: none new. V8's accepted risk is withdrawn (W5).

Simplest alternative considered: the reviewer's own, keep xunit.v3.mtp-v2 as generated and amend the design row.
Taken (Q12).
