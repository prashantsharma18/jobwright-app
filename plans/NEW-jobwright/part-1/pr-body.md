Draft: part 1 of 4 of NEW-jobwright in jobwright-app, slice 0 of route G (plan v3, approved 2026-11-11, commit
02a2cfb; spec v3). It lays the skeleton and the gates. It proves no spec criterion on its own: it prepares AC27 (the
gates report here), AC12 (the axe scan), AC26 (the budget and its number), and answers U13 (ArchUnitNET on xunit.v3
4.x: it runs) and U15 (Actions minutes: measured on this pull request).

Three slices on one branch (K1), each with its progress note:
- **slice-0-scaffold**: the generators' output as one recipe commit (06a65b0), reviewed as generated code (R1 to R9)
- **slice-0-skeleton**: exact pins and lock files, placeholders removed, the API's `/health/live` (K2), the cn test,
  the module-boundary test (U13), `scripts/check.sh` test | lint | build
- **slice-0-ci**: `scripts/dev.sh` and its refusal tests, the browser harness (page check, AC12 axe scan, AC26
  budget), the three images, `.github/workflows/ci.yml`

## Criteria and checks (plan TESTS)

| Item | Check | Seen red |
|---|---|---|
| AC27 (part) | ci.yml: setup, lint, test, build, browser, budget, independent jobs | drill runs below |
| AC12 (harness) | web/tests/e2e/accessibility.spec.ts `AC12 every page has no WCAG 2.2 AA violation`, 4 projects | locally: color-contrast |
| AC26 (harness) | web/tests/e2e/budget.spec.ts `AC26 first load stays within the script budget`: 163,840 bytes (135,165 measured × 1.2, next 10 KB) | locally: 1-byte budget |
| K2 | api/tests/Jobwright.Api.Tests/HealthLiveTests.cs `HealthLive_answers_200_without_authentication` | locally |
| U13 / ADR 0001 | api/tests/Jobwright.ArchitectureTests/ModuleBoundaryTests.cs | locally, ArchUnitNET's own message |
| web | web/src/lib/utils.test.ts (cn) | locally |
| dev.sh | scripts/tests/test_dev.sh: refuses k3d (name and label), a silent docker, a taken port | locally |
| page | web/tests/e2e/skeleton.spec.ts `home page answers with the Jobwright heading` | locally |

Local counts: web unit 2, .NET 2, dev.sh 3, browser 8 (2 tests × 4 projects), budget 1; none skipped.

## Drill (slice-0-ci step 5, E10)
- First run [42964529734](https://github.com/prashantsharma18/jobwright-app/actions/runs/42964529734): lint red on a real fault (LayoutProps on a clean checkout), fixed in 8c8fa06 (E12)
- Green [42965610747](https://github.com/prashantsharma18/jobwright-app/actions/runs/42965610747): all six green
- Drill 1 [42966349758](https://github.com/prashantsharma18/jobwright-app/actions/runs/42966349758), a lock mismatch: setup red with `ERR_PNPM_OUTDATED_LOCKFILE ... vitest (lockfile: 5.1.0, manifest: 5.1.1)` (the other five red at the same install)
- Drill 2 [42966685123](https://github.com/prashantsharma18/jobwright-app/actions/runs/42966685123), setup green and each other gate red for its own reason: lint (prettier, next.config.ts), test (HealthLive: Expected OK, Actual NotFound), build (Dockerfile.worker: drill-missing.props not found), browser (AC12 color-contrast in all four projects; skeleton passed), budget (Expected <= 1, Received 135165)
- Revert 9e6c1dc: _final green run to come_
- Minutes of one full run (U15): 1:44 wall clock, 5:48 job time; no Actions minutes billed (public repository, E11)

## For the reviewer (Prashant Sharma)
- **Kept from the generators (plan Q1, new-system.md v4/v5):** cn 0.5.2, @tailwindcss/turbopack 4.3.5, shadcn as a
  build-time devDependency, @types/react-dom 19.3.0, Microsoft.Extensions.Hosting 10.0.14, xunit.v3.mtp-v2 4.0.2
- **Transitive packages to read:** ArchUnitNET's five (CycleDetection, JetBrains.Annotations, Mono.Cecil,
  Newtonsoft.Json, System.ValueTuple; skeleton D1); Playwright's playwright and playwright-core, axe-core 4.14.0
- **Decisions taken at your instruction:** skeleton D1 to D9 (progress-slice-0-skeleton.md); slice-0-ci E1 to E10
  (progress-slice-0-ci.md), among them: E1 the dev ports move below 49152 (plan v4, open); E3 the heading's serif
  fallback (fonts are part 3's); E6 npm left pnpm's own install scripts unrun; E7 UseHttpsRedirection unchanged;
  E8 the ci.yml choices; E10 three drill runs
- **Slips:** skeleton slips 1 and 2 (files landed in the next commit; every commit builds; history not rewritten)
- **Not included:** publishing, `packages: write`, STAGING_TOKEN (part 3, ADR 0012); contract, integration and scan
  gates (part 3); the Helm chart; AGENTS.md's "not yet run" lines (aidlc-onboard confirm)
- **Open before merge:** plan v4 and bundle slice-0-ci v4 for E1, new-system.md v6, AGENTS.md line 46, then
  dev.sh's real run; aidlc-verify and aidlc-review

🤖 Generated with [Claude Code](https://claude.com/claude-code)
