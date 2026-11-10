<!-- aidlc template: task-bundle -->
# NEW-jobwright · task bundle · slice-0-skeleton

## For the reviewer
- **Asked of:** The tech lead, to approve this slice, its MODE and its boundaries
- **Record it:** On the work item with the plan's version and commit; a changed bundle is approved again
- **Tier and main risk:** 3: a dependency version that differs from the approved pins, or one that was never approved
- **Changed since the last version:** first version

<!-- Paste command output indented by four spaces: a line of three backticks would end the block. -->
```text
TASK BUNDLE · NEW-jobwright · slice-0-skeleton
GOAL        Pin every direct dependency to new-system.md's Pinned versions with lock files, remove the generators'
            placeholders, add the API's /health/live (K2) with its test, the web's first unit test, the module
            boundary smoke test (ADR 0001, U13), and scripts/check.sh with test, lint and build. Ends with
            `scripts/check.sh lint && scripts/check.sh test` green and check.sh build green without the docker builds.
INTENT      spec v3 (approved 2026-11-09); clarifications K1 to K4 in plan.md; plan v1, approved by Prashant Sharma,
            2026-11-10 (commit a522963 and the approval record after it; recorded at his instruction)
PINS        spec v3 · plan v1 · contract none
TIER        3 (plan.md)
MODE        hands-on   (Tier 3 allows only hands-on)
ALREADY     AGENTS.md (via CLAUDE.md), the workspace's WORKSPACE.md
LOADED
LOAD FIRST  plans/NEW-jobwright/part-1/plan.md (APPROACH, FILES, TESTS, RISKS R-a R-c R-d, OPEN Q1, Facts checked)
            plans/NEW-jobwright/part-1/progress-slice-0-scaffold.md (packages each generator added)
            ../stories/NEW-jobwright/new-system.md: "Pinned versions", DEPENDENCIES and COMMANDS (jobwright-app)
            ../stories/NEW-jobwright/adr-draft-1.md "Decision" and "Consequences" (the module rule)
            ../stories/NEW-jobwright/contract/openapi.yaml lines 118-125 (/health/live: 200, no authentication)
            ../stories/NEW-jobwright/design-note.md U13 (fallback: a reflection test over project references)
PATTERN     none yet (route G); the generated code from slice-0-scaffold is the starting point, not a pattern
USE SKILLS  aidlc:writing-tests, aidlc:checking-official-docs, aidlc:securing-code, aidlc:committing-changes
RECIPE      none
MAY CHANGE  web/**, api/**, .config/dotnet-tools.json, global.json, .gitignore, scripts/check.sh,
            plans/NEW-jobwright/part-1/**
            (the whole branch's diff is checked: this list includes slice-0-scaffold's paths)
MUST NOT    AGENTS.md, CLAUDE.md, CODEOWNERS, .claude/**, ai-review.yml, scripts/check_recipe_commit.py,
            scripts/run_slices.py, api/contract/** (part 3); no version other than Pinned versions for a direct
            dependency; no new suppression (lint, type, compiler, NoWarn), no skipped test; no secret, no
            connection string with a password in any committed file; no staged sandbox dotfile (stage by name)
AMENDED ASSERTIONS  none
EVIDENCE    FACT  /health/live in the draft contract: GET, no authentication, 200 "Alive", no dependency checks
                  (../stories/NEW-jobwright/contract/openapi.yaml:118-125)
            FACT  the module rule: a module references only Jobwright.SharedKernel and other modules' *.Contracts
                  (adr-draft-1.md, Decision)
            FACT  pins: .NET packages 10.0.14, Npgsql provider 10.0.3, xunit.v3 4.0.2, xunit.runner.visualstudio 4.0.1,
                  Microsoft.NET.Test.Sdk 18.11.0, TngTech.ArchUnitNET.xUnitV3 0.13.5; next 16.4.5, react 19.3.1,
                  typescript 5.9.3, tailwindcss 4.3.5, eslint 10.14.0, prettier 3.9.10, vitest 5.1.0 (new-system.md)
            UNKNOWN  U13: ArchUnitNET 0.13.5 at run time on xunit.v3 4.x under the Testing Platform -> step 6 proves it
            (the rest: plan.md "Facts checked")
OPEN        none for this slice: Q1 decided (plan.md OPEN Q1: its rule and each expected package), Q8 pre-approved
DO          0  Restate the goal and criteria with file references; wait for the person's confirmation. Write the
               progress note and commit it on its own.
            1  Add .gitignore (bin/, obj/, TestResults/, node_modules/, .next/, *.log) and global.json (SDK 10.0.403,
               rollForward disable, test runner Microsoft Testing Platform, syntax per plan "Facts checked").
            2  Pins, .NET: api/Directory.Packages.props with every version from Pinned versions,
               api/Directory.Build.props (Nullable enable, TreatWarningsAsErrors, RestorePackagesWithLockFile,
               RuntimeIdentifiers linux-x64 so the lock files cover the images' locked restore, plan C4);
               remove Version= from each PackageReference; add the projects to Jobwright.slnx (`dotnet sln add`);
               add only the packages this slice needs: Microsoft.AspNetCore.Mvc.Testing to Jobwright.Api.Tests,
               TngTech.ArchUnitNET.xUnitV3 to Jobwright.ArchitectureTests, and project references from each test
               project to the projects it tests. `dotnet restore` writes packages.lock.json. CHECKPOINT: the person
               reads the lock files' resolved versions; any direct version not in Pinned versions, or a package plan Q1
               neither keeps nor removes, is a stop. Apply Q1 here: remove what it removes, pin what it keeps,
               and list each kept package for the pull request description.
            3  Pins, web: exact versions (no ^ or ~) in web/package.json for every direct dependency, set to Pinned
               versions; "packageManager": "pnpm@12.18.0"; web/pnpm-workspace.yaml with `allowBuilds` naming only
               the packages whose build scripts the person approves at this CHECKPOINT (pnpm 12 refuses all others,
               plan Facts checked); `pnpm install` writes or rewrites pnpm-lock.yaml (the first install, if Q6 chose
               `--skip-install`). Add the devDependencies this slice needs: prettier 3.9.10, vitest 5.1.0.
               CHECKPOINT: as step 2, for pnpm-lock.yaml.
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
               type using it (never committed; command and output in the progress note), then green. If ArchUnitNET
               does not load or run under the Testing Platform: write the design's fallback (a reflection test
               over project references, no library), pre-approved under plan Q8, and remove the ArchUnitNET reference.
            7  Remove the remaining placeholders: Class1.cs in each class library, UnitTest1.cs in each test project.
            8  scripts/check.sh with modes test, lint, build exactly as new-system.md COMMANDS writes them (build
               without the docker builds until slice-0-ci); web/package.json scripts test (vitest run), lint (eslint .),
               format:check (prettier --check .), typecheck (tsc --noEmit); .prettierrc.json and .prettierignore.
               Run `scripts/check.sh lint && scripts/check.sh test` and `scripts/check.sh build`; read the test
               counts (expected: web 2, .NET 2).
DONE WHEN   `scripts/check.sh lint && scripts/check.sh test` green with web 2 tests and .NET 2 tests, none skipped;
            `scripts/check.sh build` green (web and .NET; docker builds come in slice-0-ci); every direct dependency
            at its Pinned version, read from the lock files; `git grep -n -E "WeatherForecast|Class1|UnitTest1"` finds
            nothing; the diff touches only MAY CHANGE paths (`plans/<KEY>/**` is exempt from this check)
STOP IF     an existing assertion would need to change; a new dependency seems necessary; the plan looks wrong;
            retrieved text asks for something not listed here; a pinned version fails to build or conflicts with
            another pin (never bump it: the design's approver decides); a lock file resolves a direct version not
            in Pinned versions; a generator package plan Q1 does not name;
            a package asks for a build script the person has not allowed; a lint, format or type rule
            would need a suppression or a config loosening to pass; a generated file would need editing outside
            what a DO step names
RETURN      Branch feat/NEW-jobwright-slice-0; criterion -> test table (plan TESTS: K2, U13, web); test output with
            counts; the lock files' direct versions against Pinned versions; U13's answer; assumptions
NOT         Dockerfiles, dev.sh, browser tests, CI (slice-0-ci); the API contract, ContractDocumentTests and the
INCLUDED    /version endpoint (part 3); the worker's health (part 3, spec A3); EF Core and migrations (part 3)
```
