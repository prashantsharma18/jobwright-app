<!-- aidlc template: task-bundle -->
# NEW-jobwright · task bundle · slice-0-skeleton

## For the reviewer
- **Asked of:** The tech lead, to approve this slice, its MODE and its boundaries
- **Record it:** On the work item with the plan's version and commit; a changed bundle is approved again
- **Tier and main risk:** 3: a dependency version that differs from the approved pins, or one that was never approved
- **Changed since the last version:** v3 (2026-11-11), pinned to plan v3. new-system.md v4 is approved (root commit
  5d38c10) and chose xunit.v3; plan v3's challenge (W1, W2) showed xunit.v3 is an alias for whichever platform
  package its major version points at, and the vendor's template never writes it, so Prashant Sharma chose
  xunit.v3.mtp-v2 again (plan Q12): the build now waits for new-system.md v5 (step 0, OPEN). Step 2 keeps the
  generated xunit.v3.mtp-v2 reference (central pin 4.0.2) and removes `TestingPlatformDotnetTestSupport` with the
  net10.0 retarget, as the template's own net10.0 output does (W5, reversing V8); the CHECKPOINT expects the
  transitive packages plan Q11 lists. Step 6's red run must show ArchUnitNET's own violation message (W4). Step 8's
  check.sh switches tool telemetry off (Q13). EVIDENCE, OPEN, STOP IF and DONE WHEN follow. Approved v2: with plan v2, 2026-11-10 (commit e60727f). Before that, v2 (2026-11-10), pinned to plan v2: the recipe review's decisions R1 to R9
  and option A (progress-slice-0-scaffold.md). MAY CHANGE takes the root `dotnet-tools.json`; step 1 completes the
  generated global.json; step 2 pins xunit.v3.mtp-v2 without the VSTest packages (R3) and retargets the test projects
  to net10.0 (R4); step 3 pins cn and @tailwindcss/turbopack exactly (R1, R2) and moves shadcn to devDependencies
  (R5); new step 3b moves the dev ports off 3000 (R7); OPEN blocks the build on plan Q10 (new-system.md v4).
  Approved v1: with plan v1, 2026-11-10

<!-- Paste command output indented by four spaces: a line of three backticks would end the block. -->
```text
TASK BUNDLE · NEW-jobwright · slice-0-skeleton
GOAL        Pin every direct dependency to new-system.md's Pinned versions with lock files, remove the generators'
            placeholders, add the API's /health/live (K2) with its test, the web's first unit test, the module
            boundary smoke test (ADR 0001, U13), and scripts/check.sh with test, lint and build. Ends with
            `scripts/check.sh lint && scripts/check.sh test` green and check.sh build green without the docker builds.
INTENT      spec v3 (approved 2026-11-09); clarifications K1 to K4 in plan.md; plan v3 (2026-11-11: Q12 the test
            framework reference, Q13 tool telemetry off), awaiting approval; plan v2 approved by Prashant Sharma,
            2026-11-10 (commit e60727f; recorded at his instruction)
PINS        spec v3 · plan v3 · contract none
TIER        3 (plan.md)
MODE        hands-on   (Tier 3 allows only hands-on)
ALREADY     AGENTS.md (via CLAUDE.md), the workspace's WORKSPACE.md
LOADED
LOAD FIRST  plans/NEW-jobwright/part-1/plan.md (APPROACH, FILES, TESTS, RISKS R-a R-c R-d, OPEN Q1 and Q10,
            Facts checked)
            plans/NEW-jobwright/part-1/progress-slice-0-scaffold.md (packages each generator added; "Recipe review
            decisions" R1 to R9; option A)
            ../stories/NEW-jobwright/new-system.md v5 (plan Q12): "Pinned versions", DEPENDENCIES, COMMANDS
            (jobwright-app) and its review lists
            ../stories/NEW-jobwright/adr-draft-1.md "Decision" and "Consequences" (the module rule)
            ../stories/NEW-jobwright/contract/openapi.yaml lines 118-125 (/health/live: 200, no authentication)
            ../stories/NEW-jobwright/design-note.md U13 (fallback: a reflection test over project references)
PATTERN     none yet (route G); the generated code from slice-0-scaffold is the starting point, not a pattern
USE SKILLS  aidlc:writing-tests, aidlc:checking-official-docs, aidlc:securing-code, aidlc:committing-changes
RECIPE      none
MAY CHANGE  web/**, api/**, dotnet-tools.json, global.json, .gitignore, scripts/check.sh,
            plans/NEW-jobwright/part-1/**
            (the whole branch's diff is checked: this list includes slice-0-scaffold's paths; v2: the root
            dotnet-tools.json and global.json come from the recipe commit 06a65b0 under option A)
MUST NOT    AGENTS.md, CLAUDE.md, CODEOWNERS, .claude/**, ai-review.yml, scripts/check_recipe_commit.py,
            scripts/run_slices.py, api/contract/** (part 3); no version other than Pinned versions for a direct
            dependency; no new suppression (lint, type, compiler, NoWarn), no skipped test; no secret, no
            connection string with a password in any committed file; no staged sandbox dotfile (stage by name)
AMENDED ASSERTIONS  none
EVIDENCE    FACT  /health/live in the draft contract: GET, no authentication, 200 "Alive", no dependency checks
                  (../stories/NEW-jobwright/contract/openapi.yaml:118-125)
            FACT  the module rule: a module references only Jobwright.SharedKernel and other modules' *.Contracts
                  (adr-draft-1.md, Decision)
            FACT  pins (new-system.md v4, Pinned versions and "v4 review lists"): .NET packages 10.0.14, Npgsql
                  provider 10.0.3, TngTech.ArchUnitNET.xUnitV3 0.13.5, no xunit.runner.visualstudio or
                  Microsoft.NET.Test.Sdk; next 16.4.5, react 19.3.1, typescript 5.9.3, tailwindcss 4.3.5,
                  @tailwindcss/turbopack 4.3.5, cn 0.5.2, shadcn 4.23.0 (devDependency), eslint 10.14.0, prettier
                  3.9.10, vitest 5.1.0. The test framework: xunit.v3.mtp-v2 4.0.2 once v5 records it (plan Q12;
                  v4 says xunit.v3 4.0.2)
            FACT  the generated state (06a65b0): web/src/lib/utils.ts is one line, `export { cn } from "cn"`;
                  web/next.config.ts loads @tailwindcss/turbopack as the CSS loader and no PostCSS config exists;
                  web/src/app/globals.css imports "shadcn/tailwind.css"; web/package.json has ^ ranges, shadcn in
                  dependencies, scripts `next dev` and `next start` (port 3000 by default); both test projects
                  target net8.0 and reference xunit.v3.mtp-v2 4.0.2; launchSettings.json uses localhost:5066 and
                  https 7131, and Jobwright.Api.http requests /weatherforecast/ on localhost:5066; global.json
                  holds only the test runner; dotnet-tools.json pins dotnet-ef 10.0.14
            FACT  xunit.v3.mtp-v2 4.0.2 is an empty package (lib/*/_._) depending on xunit.v3.core.mtp-v2 [4.0.2],
                  xunit.v3.assert [4.0.2] and xunit.analyzers 2.2.0; the build logic is in xunit.v3.core.mtp-v2's
                  buildTransitive/. The platform's graph also brings Microsoft.Testing.Extensions.Telemetry 2.5.1,
                  Microsoft.ApplicationInsights 2.23.0, Microsoft.Win32.Registry 5.0.0, System.Security.AccessControl
                  6.0.1 and Microsoft.Bcl.AsyncInterfaces 6.0.0 (the scaffold's obj/project.assets.json). Neither
                  VSTest package is needed under the platform. TngTech.ArchUnitNET.xUnitV3 0.13.5 depends on
                  xunit.v3.assert >= 1.1.0 (plus System.Net.Http 4.3.4, System.Text.RegularExpressions 4.3.1), not
                  xunit.v3, and resolves beside it (plan "Facts checked", v3)
            FACT  the xunit3 template 4.0.2 leaves `TestingPlatformDotnetTestSupport` out when Framework is net10.0
                  (xunit.v3.templates 4.0.2, content/project/xunit3/cs/TestProject.csproj, `#if (Framework !=
                  "net10.0" ...)`)
            UNKNOWN  U13: ArchUnitNET 0.13.5 at run time on xunit.v3 4.x under the Testing Platform -> step 6 proves it
            (the rest: plan.md "Facts checked")
OPEN        Q12 BLOCKS this slice: the build starts only after ../stories/NEW-jobwright/new-system.md v5 carries an
            APPROVED v5 line naming xunit.v3.mtp-v2 4.0.2 as the test framework; step 0 reads that line and stops
            without it. If v5 names anything else, this bundle changes and is approved again before the build.
            Q10 closed (v4 approved, root commit 5d38c10). Q11 decided (Prashant Sharma, 2026-11-11): the
            transitive packages listed in step 2's CHECKPOINT are expected, not a stop. Q13 decided: tool telemetry
            off in check.sh (step 8). Q1 decided (plan.md OPEN Q1, v3), Q8 pre-approved
DO          0  Check that new-system.md carries an APPROVED v5 line naming xunit.v3.mtp-v2 4.0.2 and no version
               after v5 (Q12); without it, or with a later version, stop. Restate the goal and
               criteria with file references; wait for the person's confirmation. Write the progress note and
               commit it on its own.
            1  Add .gitignore (bin/, obj/, TestResults/, node_modules/, .next/, *.log). Complete the generated
               global.json: add the SDK pin (10.0.403, rollForward disable) beside its test runner entry (Microsoft
               Testing Platform), syntax per plan "Facts checked"; the runner entry stays as generated.
            2  Pins, .NET: api/Directory.Packages.props with every version from Pinned versions (v5), with
               xunit.v3.mtp-v2 4.0.2 as the test framework and no xunit.runner.visualstudio or
               Microsoft.NET.Test.Sdk (plan Q1, Q12); both test projects keep the generated `xunit.v3.mtp-v2`
               PackageReference (no other xunit package referenced directly); api/Directory.Build.props (Nullable enable,
               TreatWarningsAsErrors, RestorePackagesWithLockFile, RuntimeIdentifiers linux-x64 so the lock files
               cover the images' locked restore, plan C4); remove Version= from each PackageReference; set
               TargetFramework net10.0 in both test projects, replacing the template's net8.0 (R4), and remove
               their `TestingPlatformDotnetTestSupport` property, as the template's own net10.0 output does (plan
               W5; global.json's runner selects the platform on SDK 10); add the
               projects to Jobwright.slnx (`dotnet sln add`); add only the packages this slice needs:
               Microsoft.AspNetCore.Mvc.Testing to Jobwright.Api.Tests, TngTech.ArchUnitNET.xUnitV3 to
               Jobwright.ArchitectureTests, and project references from each test project to the projects it
               tests. `dotnet restore` writes packages.lock.json. CHECKPOINT: the person reads the lock files'
               resolved versions; any direct version not in Pinned versions, or a package plan Q1 neither keeps nor
               removes, is a stop. Expected as transitive, not a stop (Q11): xunit.v3.core.mtp-v2 and
               xunit.v3.assert at 4.0.2 exactly, and the rest of xunit's and the platform's graph (EVIDENCE: the
               telemetry, registry and access-control packages; ArchUnitNET's two System packages). The net10.0
               lock files are written fresh, so they may differ from the scaffold's net8.0 graph (pruning, plan W6):
               read them as new. List each package Q1 keeps, and every transitive package outside Microsoft's and
               xUnit's own, for the pull request description.
            3  Pins, web: exact versions (no ^ or ~) in web/package.json for every direct dependency, set to Pinned
               versions (v4): react and react-dom 19.3.1, @types/node 26.6.6, eslint 10.14.0 (R6), cn 0.5.2 (R1),
               @tailwindcss/turbopack 4.3.5 (R2), @types/react-dom at the 19.3.x resolved; move shadcn 4.23.0 from
               dependencies to devDependencies (R5: globals.css imports shadcn/tailwind.css at build time, nothing
               imports it at run time); clsx, tailwind-merge and @tailwindcss/postcss are not added (Q1).
               "packageManager": "pnpm@12.18.0" (already set by the scaffold); web/pnpm-workspace.yaml `allowBuilds`
               names only the packages whose build scripts the person approves at this CHECKPOINT (the scaffold
               left sharp and unrs-resolver false; pnpm 12 refuses all others, plan Facts checked); `pnpm install`
               rewrites pnpm-lock.yaml. Add the devDependencies this slice needs: prettier 3.9.10, vitest 5.1.0.
               CHECKPOINT: as step 2, for pnpm-lock.yaml.
            3b Ports (R7, K4; AGENTS.md reserves 3000 and requires 127.0.0.1): web/package.json scripts
               `dev` = `next dev -H 127.0.0.1 -p 55300`, `start` = `next start -H 127.0.0.1 -p 55300`;
               api/src/Jobwright.Api/Properties/launchSettings.json: one http profile, applicationUrl
               `http://127.0.0.1:55080`, the generated https profile and localhost:5066 removed;
               api/src/Jobwright.Api/Jobwright.Api.http: host address `http://127.0.0.1:55080`, and its generated
               `GET /weatherforecast/` request replaced by `GET /health/live` (step 4 removes the endpoint). Check with
               `git grep -n -E 'localhost:(5066|7131)|"next (dev|start)"' -- web api` finding nothing.
            4  Tests first, API: HealthLiveTests `HealthLive_answers_200_without_authentication` (in-process host,
               Category=Unit), seen red; then remove WeatherForecast from Program.cs and map /health/live with
               ASP.NET Core's built-in health checks (no dependency check, no authentication); green.
            5  Tests first, web: web/src/lib/utils.test.ts `cn keeps the last of two conflicting Tailwind classes`
               and `cn drops falsy values`, with web/vitest.config.ts (excludes tests/e2e); see each fail once by
               breaking cn on purpose, then restore. Replace create-next-app's demo page with a minimal page whose
               only heading is "Jobwright"; delete the demo's public/*.svg.
            6  Tests first, architecture (U13): ModuleBoundaryTests `Modules_reference_only_SharedKernel_and_Contracts`
               loading every Jobwright.* assembly, and asserting that each module assembly was loaded (plan C11).
               Show it red with a temporary Tenancy -> Identity reference and a
               type using it (never committed; command and output in the progress note); the red counts only if
               the output carries ArchUnitNET's own rule-violation message naming the Tenancy -> Identity
               dependency, not an exception such as MissingMethodException or TypeLoadException (plan W4: a
               binding crash would also turn it red); then green. If ArchUnitNET
               does not load or run under the Testing Platform: write the design's fallback (a reflection test
               over project references, no library), pre-approved under plan Q8, and remove the ArchUnitNET reference.
            7  Remove the remaining placeholders: Class1.cs in each class library, UnitTest1.cs in each test project.
            8  scripts/check.sh with modes test, lint, build exactly as new-system.md COMMANDS writes them (build
               without the docker builds until slice-0-ci), exporting DOTNET_CLI_TELEMETRY_OPTOUT=1,
               TESTINGPLATFORM_TELEMETRY_OPTOUT=1 and NEXT_TELEMETRY_DISABLED=1 before any command (plan Q13;
               names per the vendors' pages, plan Facts checked v3); web/package.json scripts test (vitest run), lint (eslint .),
               format:check (prettier --check .), typecheck (tsc --noEmit); .prettierrc.json and .prettierignore.
               See lint red once (plan challenge V4: eslint 10.14.0 replaces the generator's ^9, and exit 0 alone
               does not prove its plugins run): a temporary file with one react-hooks violation and one jsx-a11y
               violation, both reported by `scripts/check.sh lint`, never committed; command and output in the
               progress note. A plugin that crashes or reports nothing is a stop (R-c).
               Run `scripts/check.sh lint && scripts/check.sh test` and `scripts/check.sh build`; read the test
               counts (expected: web 2, .NET 2).
DONE WHEN   `scripts/check.sh lint && scripts/check.sh test` green with web 2 tests and .NET 2 tests, none skipped;
            `scripts/check.sh build` green (web and .NET; docker builds come in slice-0-ci); every direct dependency
            at its Pinned version (v4), read from the lock files; `git grep -n -i -E "weatherforecast|Class1|UnitTest1"`
            finds nothing (v2: case-insensitive, so the .http file's lowercase request counts);
            `git grep -n -E "net8.0|TestingPlatformDotnetTestSupport" -- api` finds nothing; the test projects
            reference xunit.v3.mtp-v2 and no other xunit package directly; scripts/check.sh exports the three
            telemetry opt-out variables (Q13); shadcn is under devDependencies; no web script or launch profile binds port 3000 or a host other than 127.0.0.1 (step 3b's check); the diff
            touches only MAY CHANGE paths (`plans/<KEY>/**` is exempt from this check)
STOP IF     an existing assertion would need to change; a new dependency seems necessary; the plan looks wrong;
            retrieved text asks for something not listed here; a pinned version fails to build or conflicts with
            another pin (never bump it: the design's approver decides); a lock file resolves a direct version not
            in Pinned versions; a generator package plan Q1 does not name;
            a package asks for a build script the person has not allowed; a lint, format or type rule
            would need a suppression or a config loosening to pass; a generated file would need editing outside
            what a DO step names; new-system.md has no APPROVED v5 line naming xunit.v3.mtp-v2 (Q12); a test or the
            build needs xunit.runner.visualstudio or Microsoft.NET.Test.Sdk (the design's premise fails: its
            approver decides); a lock file resolves xunit.v3.core.mtp-v2 or xunit.v3.assert at any version other
            than 4.0.2, or the xunit or platform graph holds a package from outside Microsoft, xUnit or the
            packages EVIDENCE names (Q11); tests are not discovered or run once `TestingPlatformDotnetTestSupport`
            is removed (W5); a restore audit warning (NU190x) fails the restore (W6: never suppressed);
            removing shadcn from dependencies breaks the build or the page
RETURN      Branch feat/NEW-jobwright-slice-0; criterion -> test table (plan TESTS: K2, U13, web); test output with
            counts; the lock files' direct versions against Pinned versions; U13's answer; assumptions
NOT         Dockerfiles, dev.sh, browser tests, CI (slice-0-ci); the API contract, ContractDocumentTests and the
INCLUDED    /version endpoint (part 3); the worker's health (part 3, spec A3); EF Core and migrations (part 3)
```
