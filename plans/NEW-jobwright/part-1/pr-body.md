Part 1 of 4 of NEW-jobwright in jobwright-app: slice 0 of route G (spec v3; plan v4, approved 2026-11-11, commit
6936a41). It lays the skeleton and the gates. It proves no spec criterion on its own: it prepares AC27 (the six gates
report here), AC12 (the axe scan) and AC26 (the budget and its number), and answers U13 (ArchUnitNET on xunit.v3 4.x
runs) and U15 (minutes per run).

**Evidence:** [plans/NEW-jobwright/part-1/evidence.md](plans/NEW-jobwright/part-1/evidence.md), drafted from the
trusted run [42999475010](https://github.com/prashantsharma18/jobwright-app/actions/runs/42999475010) on 9f05a3d:
all six gates green; 16 test executions, 16 passed, 0 failed, 0 skipped.

## Start with the tests
| Item | Test | CI |
|---|---|---|
| AC12 (harness) | web/tests/e2e/accessibility.spec.ts `AC12 every page has no WCAG 2.2 AA violation`, 360/1440 × light/dark | pass ×4 |
| AC26 (harness) | web/tests/e2e/budget.spec.ts `AC26 first load stays within the script budget`: 163,840 B (135,165 measured × 1.2, next 10 KiB) | pass |
| page | web/tests/e2e/skeleton.spec.ts `home page answers with the Jobwright heading` | pass ×4 |
| K2 | api/tests/Jobwright.Api.Tests/HealthLiveTests.cs `HealthLive_answers_200_without_authentication` | pass |
| U13, ADR 0001 | api/tests/Jobwright.ArchitectureTests/ModuleBoundaryTests.cs | pass |
| web | web/src/lib/utils.test.ts (cn) | pass ×2 |
| dev.sh | scripts/tests/test_dev.sh: refuses a running k3d (name and label), a silent docker, a taken port (15432) | pass ×3 |

Each of the six gates (setup, lint, test, build, browser, budget) was seen green, red for its own reason and green
again: drill 1 [42966349758](https://github.com/prashantsharma18/jobwright-app/actions/runs/42966349758), drill 2
[42966685123](https://github.com/prashantsharma18/jobwright-app/actions/runs/42966685123), revert
[42967216637](https://github.com/prashantsharma18/jobwright-app/actions/runs/42967216637); the first run's lint red was
a real fault, fixed (E12). Minutes (U15), from the trusted run: 1:55 wall clock, 6:27 job time; no Actions minutes
billed on a public repository (E11).

## What is in it
Four slices on one branch (K1), each with its progress note in plans/NEW-jobwright/part-1/:
- **slice-0-scaffold:** the generators' output as one recipe commit (06a65b0), reviewed as generated code (R1 to R9)
- **slice-0-skeleton:** exact pins and lock files, placeholders removed, the API's `/health/live` (K2), the cn test, the
  module-boundary test (U13), `scripts/check.sh` test | lint | build
- **slice-0-ci:** `scripts/dev.sh` and its refusal tests, the browser harness (page check, AC12 axe scan, AC26
  budget), the three images, `.github/workflows/ci.yml`
- **slice-0-ports:** the dev ports moved below Windows' dynamic range (plan K4 v4, E1): PostgreSQL 15432, Keycloak
  18080, API 15080, web 15300; one sed recipe commit (366edc2) checked by `scripts/check_recipe_commit.py`, reviewed
  by Prashant Sharma. new-system.md v6 records them (workspace root c3d4ea2; plan Q14 closed)

`scripts/dev.sh` ran for real on the new ports: all four answered on 127.0.0.1 and it cleaned up after itself (local
only by design; slice-0-ci step 6).

## For the reviewer (Prashant Sharma)
- **Decide before merge (evidence.md, For the approver):** D6, ModuleBoundaryTests' `.WithoutRequiringPositiveResults()`
  (8687793), against AGENTS.md's Quality bar (an owner and an expiry, or a ruling that it is not an exception); the
  scaffold review you delegated (06a65b0): this review is the human check of that generated code
- **Not run in slice 0:** dependency, secret and SAST scans (part 3: gitleaks, trivy, syft); before the repository
  went public, a full history scan found no secret (E11)
- **Kept from the generators (plan Q1, new-system.md v4/v5):** cn 0.5.2, @tailwindcss/turbopack 4.3.5, shadcn as a
  build-time devDependency, @types/react-dom 19.3.0, Microsoft.Extensions.Hosting 10.0.14, xunit.v3.mtp-v2 4.0.2.
  All 35 direct dependencies are exact and at new-system.md v6's pins
- **Transitive packages to read:** ArchUnitNET's five (CycleDetection, JetBrains.Annotations, Mono.Cecil,
  Newtonsoft.Json, System.ValueTuple; skeleton D1); Playwright's playwright and playwright-core, axe-core 4.14.0
- **Decisions taken at your instruction:** skeleton D1 to D9; slice-0-ci E1 to E13, among them E1 the dev-port move,
  E3 the heading's serif fallback (fonts are part 3's), E6 npm left pnpm's own install scripts unrun, E7
  UseHttpsRedirection unchanged, E8 the ci.yml choices, E10 three drill runs, E13 `agentRules: false` so `next dev`
  writes no web/AGENTS.md (eb0cece)
- **Size:** 90 files; the scaffold's 8,655 generated lines and the lock files are most of it; the hand-written
  change after the scaffold, outside plans/ and the lock files, is about 1,070 lines added and 340 removed
- **Slips:** skeleton slips 1 and 2 (files landed in the next commit; every commit builds; history not rewritten)
- **Not included:** publishing, `packages: write`, STAGING_TOKEN (part 3, ADR 0012); contract, integration and scan
  gates (part 3); the Helm chart; AGENTS.md's "not yet run" lines (aidlc-onboard confirm)
- **Raised separately:** E11's consequences of the public repository for ADR 0011, spec KL1 and plan C8 (the
  workspace root)

🤖 Generated with [Claude Code](https://claude.com/claude-code)
