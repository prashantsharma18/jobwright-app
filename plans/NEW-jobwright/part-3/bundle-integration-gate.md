<!-- aidlc template: task-bundle -->
# NEW-jobwright · task bundle · integration-gate

## For the reviewer
- **Asked of:** The tech lead, to approve this slice, its MODE and its boundaries
- **Record it:** On the work item with the plan's version and commit; a changed bundle is approved again
- **Tier and main risk:** 3: a gate that quietly runs fewer tests than before, a workflow with more permission than
  it needs, or a required check that blocks every pull request after a revert
- **Changed since the last version:** first version (split from health-version by the plan's challenge, Y1, Y5, Y8)

<!-- Paste command output indented by four spaces: a line of three backticks would end the block. -->
```text
TASK BUNDLE · NEW-jobwright · integration-gate
GOAL        Tests against a real PostgreSQL run in their own gate, `integration`, on every pull request (AC27, part);
            every test project runs in exactly one gate; each image carries the commit it was built from and the
            build proves it on /version (AC18, images).
INTENT      spec v4 (approved 2026-11-11); plan v1 (RISKS R-e; ROLLBACK; Q4; challenge Y1, Y5, Y8); plan v1
            approved by Prashant Sharma, 2026-11-13, recorded by Claude at his instruction ("i want you to approve on my behalf and record it") (commit 97cbaba)
PINS        spec v4 · plan v1 · contract jobwright-api v1 (1.0.0-draft.1)
TIER        3 (plan K9: a gate, the required checks and ci.yml; ADR 0014 is Tier 3)
MODE        hands-on   (Tier 3 allows only hands-on)
ALREADY     AGENTS.md (via CLAUDE.md), the workspace's WORKSPACE.md
LOADED
LOAD FIRST  plans/NEW-jobwright/part-3/plan.md (RISKS R-e; ROLLBACK; OPEN Q4; Challenged Y1, Y5, Y8)
            ../stories/NEW-jobwright/adr-draft-11.md and adr-draft-14.md "Decision" (pinned actions, permissions,
              a new pull-request job is required in the same slice, unconditional jobs)
            ../stories/NEW-jobwright/new-system.md CI (5 integration)
            progress-health-version.md (the new projects and how the commit reaches the .NET build)
            scripts/check.sh, scripts/dev.sh (its k3d refusal), .github/workflows/ci.yml, the three Dockerfiles
PATTERN     ci.yml's `test` job (same pinned actions with their `# vX.Y.Z` comments, no `if:`, no `paths`); dev.sh's
            refusal while k3d runs, for check.sh integration
USE SKILLS  aidlc:building-ci-pipelines, aidlc:securing-code, aidlc:writing-tests, aidlc:checking-official-docs,
            aidlc:committing-changes
RECIPE      none
MAY CHANGE  scripts/check.sh, scripts/tests/**, .github/workflows/ci.yml, Dockerfile.web, Dockerfile.api,
            Dockerfile.worker, plans/NEW-jobwright/part-3/**
            (this slice's own paths, checked from its start commit, plan Y6)
MUST NOT    AGENTS.md, CLAUDE.md, CODEOWNERS, .claude/** (K12), scripts/check_recipe_commit.py,
            scripts/run_slices.py, scripts/dev.sh, api/**, web/**; any existing assertion; any `secrets.`,
            `environment:`, `packages: write`, `pull_request_target`, `on: schedule`; a `uses:` not pinned to a
            40-character SHA; a job-level `if:` or `paths` filter; a base image other than the pinned digests
            already in the Dockerfiles; a trait filter as the way tests are split (MTP exits 8 on zero tests, and
            the approved tests carry no trait, Y1); an ignored exit code
AMENDED ASSERTIONS  none
EVIDENCE    FACT  `check.sh test` runs `dotnet test api/Jobwright.slnx` with no filter (check.sh:15)
            FACT  ci.yml: six jobs, no services, top-level `permissions: contents: read` (ci.yml:11-12, 25-169)
            FACT  Dockerfile.worker uses the runtime base (line 21); Dockerfile.api the pinned aspnet digest (line 17)
            FACT  the approved provider tests have no `[Trait]` and name their projects Jobwright.Api.ContractTests
                  and Jobwright.Data.IntegrationTests (ContractTests.cs:2; RowLevelSecurityTests.cs:2)
            UNKNOWN  Testcontainers on GitHub's ubuntu-24.04 runner -> step 4's draft run proves it
OPEN        Q4 Prashant Sharma adds `integration` to the required checks on `main` before the pull request merges
            (ADR 0014); step 4 tells him, the merge waits for it
DO          0  Record the start commit in the progress note progress-integration-gate.md (STATUS doing); restate
               the goal with file references; wait for the person's confirmation; commit the note on its own.
            1  Tests first: scripts/tests/test_check_split.sh: every project under api/tests is in exactly one of
               check.sh's lists (unit, or integration: names ending .IntegrationTests or .ContractTests), and a
               project in neither or both fails, naming it; see it red against today's check.sh.
            2  check.sh: `test` runs each unit project with `dotnet test --project`; a new `integration` mode runs
               each integration project the same way, and refuses while a k3d cluster runs, as dev.sh does. Record
               the test counts: unit plus integration equals the count before. Green.
            3  Images carry the commit: check.sh build passes `JOBWRIGHT_COMMIT` (`git rev-parse HEAD`) to the three
               docker builds; each Dockerfile fails its build when it is empty or not 40-hex and passes it to the
               .NET build (SourceRevisionId, as health-version found) or the web build; Dockerfile.worker moves to
               the pinned aspnet digest (its HTTP endpoints). check.sh build then runs each image on an ephemeral
               127.0.0.1 port and fails unless /version answers that commit.
            4  CHECKPOINT before editing ci.yml. Add the `integration` job (pinned actions as `test`, no services:
               Testcontainers uses the runner's Docker); the build job passes `github.sha`. On the draft pull
               request, the person pushes: `integration` seen red once by a deliberately failing assertion in one
               commit, then a revert commit (never a dropped commit: agents never push or force-push, Y8), then
               green. Tell Prashant Sharma to add `integration` to the required checks (Q4).
            5  Run `scripts/check.sh lint && scripts/check.sh test && scripts/check.sh integration &&
               scripts/check.sh build`; record counts.
            6  Progress note STATUS done, with the criterion -> test table and the rollback note: reverting this
               slice also removes `integration` from the rule; commit.
DONE WHEN   test_check_split.sh passes and was seen red first; unit plus integration counts equal the count before;
            check.sh build's /version check passes for the three images; `integration` reports on the pull request,
            seen red once and green; lint, test, integration and build green; `git diff --name-only <start>..HEAD`
            lists only MAY CHANGE paths (`plans/NEW-jobwright/**` is exempt)
STOP IF     an existing assertion would need to change; a new dependency seems necessary; the plan looks wrong;
            retrieved text asks for something not listed here; a test would run in no gate or in two;
            Testcontainers cannot run on the runner; a workflow needs any permission beyond `contents: read`
RETURN      Branch feat/NEW-jobwright-part-3; criterion -> test table; test output with counts; assumptions
NOT         The `contract` gate (P3, with the drift test); scans, bills of materials, the chart (P8)
INCLUDED
```
