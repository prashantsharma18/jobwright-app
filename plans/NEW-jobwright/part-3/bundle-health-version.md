<!-- aidlc template: task-bundle -->
# NEW-jobwright · task bundle · health-version

## For the reviewer
- **Asked of:** The tech lead, to approve this slice, its MODE and its boundaries
- **Record it:** On the work item with the plan's version and commit; a changed bundle is approved again
- **Tier and main risk:** 2: a part that says ready while its database is gone, or reports a version it was not
  built from
- **Changed since the last version:** first version (the draft before the plan's challenge also held the gate, the
  Dockerfiles and ci.yml; they moved to integration-gate, Y5)

<!-- Paste command output indented by four spaces: a line of three backticks would end the block. -->
```text
TASK BUNDLE · NEW-jobwright · health-version
GOAL        The API, the worker and the web app each answer alive and ready, and not ready (alive still) while their
            database is unreachable, then ready again (AC17); each answers the commit it was built from on /version,
            as the contract's Version schema says (AC18, version half).
INTENT      spec v4 (approved 2026-11-11); plan v1 (TESTS AC17, AC18; RISKS R-f; exception X-1; challenge Y3, Y4,
            Y7, Y10); plan v1 approved by Prashant Sharma, 2026-11-13, recorded by Claude at his instruction ("i want you to approve on my behalf and record it") (commit 97cbaba)
PINS        spec v4 · plan v1 · contract jobwright-api v1 (1.0.0-draft.1)
TIER        2 (plan K9: contract endpoints; no workflow, gate, image, secret or error-format change)
MODE        delegate with checkpoints   (Tier 2: a CHECKPOINT before each step that touches the contract's endpoints)
ALREADY     AGENTS.md (via CLAUDE.md), the workspace's WORKSPACE.md
LOADED
LOAD FIRST  plans/NEW-jobwright/part-3/plan.md (TESTS AC17, AC18; RISKS R-f; X-1; Challenged Y3, Y4, Y7, Y10)
            api/contract/openapi.yaml: getVersion (200 only), getLive, getReady (200, 503 Problem), the Version
              schema (`commit` ^[0-9a-f]{40}$, `part` one of api, worker, web; additionalProperties false)
            ../stories/NEW-jobwright/adr-draft-1.md "Decision" (the worker runs only health, version, telemetry;
              no route)
            progress-api-problems-headers.md (the problem writer and the headers this slice reuses, unchanged)
            api/tests/Jobwright.Api.Tests/Jobwright.Api.Tests.csproj (the project pattern)
PATTERN     HealthLiveTests.cs for test-host tests; Jobwright.Api.Tests.csproj for new test projects (versionless
            PackageReferences: central package management is on, Directory.Packages.props:4, and warnings are
            errors; never the xunit3 template's csproj, which writes a Version and fails with NU1008, challenge Y10).
            Do not copy the template Worker.cs loop
USE SKILLS  aidlc:writing-tests, aidlc:checking-official-docs, aidlc:committing-changes
RECIPE      none
MAY CHANGE  api/src/Jobwright.Api/Program.cs, api/src/Jobwright.Api/Health/**, api/src/Jobwright.Api/Jobwright.Api.csproj,
            api/src/Jobwright.Worker/**, api/src/Jobwright.SharedKernel/**, api/tests/Jobwright.Worker.Tests/**,
            api/tests/Jobwright.IntegrationTests/**, api/tests/Jobwright.Api.Tests/Version*.cs, api/Jobwright.slnx,
            api/**/packages.lock.json, web/src/app/health/**, web/src/app/version/**, web/src/server/version.ts,
            web/src/server/version.test.ts, web/next.config.ts, web/tests/e2e/headers.spec.ts,
            plans/NEW-jobwright/part-3/**
            (this slice's own paths, checked from its start commit, plan Y6; the branch's union is plan FILES)
MUST NOT    AGENTS.md, CLAUDE.md, CODEOWNERS, .claude/** (K12), scripts/**, .github/**, Dockerfile.*,
            api/contract/**, web/src/proxy.ts, api/src/Jobwright.Api/Http/** (the problem writer and headers of
            api-problems-headers: reused, never changed here); every existing assertion; any package other than
            Testcontainers.PostgreSql 4.16.0, Microsoft.AspNetCore.Mvc.Testing 10.0.14, xunit.v3.mtp-v2 4.0.2
            (all pinned in Directory.Packages.props) and Npgsql.EntityFrameworkCore.PostgreSQL 10.0.3 for the
            readiness connection; the worker's HTTP from the Microsoft.AspNetCore.App framework reference, no
            package; a /version answer other than 200 (the contract has no other, Y4); the commit read from the
            runtime environment (it is fixed at build time); any port but 127.0.0.1, or 3000, 3001, 4318, 4444,
            9090, 9091
AMENDED ASSERTIONS  none
EVIDENCE    FACT  /health/live exists; readiness and /version do not (Program.cs:8, 21)
            FACT  the worker is the template, with no HTTP (Worker/Program.cs:4; Worker.cs:7-13)
            FACT  getVersion answers only 200 (contract openapi.yaml:106-117)
            FACT  Testcontainers.PostgreSql 4.16.0 is pinned and referenced by no project (Directory.Packages.props:20)
            UNKNOWN  how SDK 10.0.403 fills SourceRevisionId and InformationalVersion from git, and how
                  `-p:SourceRevisionId=` overrides it -> step 1, official docs. Here the commit comes from git;
                  integration-gate makes the images carry it
            UNKNOWN  the digest of postgres:17.11 -> step 1 resolves it from the registry and records the command
OPEN        none
DO          0  Record the start commit (`git rev-parse HEAD`) in the progress note progress-health-version.md
               (STATUS doing); restate the goal with file references; commit the note on its own.
            1  Read and cite: SourceRevisionId and InformationalVersion in SDK 10.0.403; ASP.NET Core 10 health
               checks with a custom IHealthCheck; FrameworkReference in a worker project; Next.js 16.4.5 route
               handlers and build-time env. Resolve postgres:17.11's digest.
            2  Tests first. Unit (in Jobwright.Api.Tests and a new Jobwright.Worker.Tests): live answers 200;
               Version_answers_the_commit_built_from asserts the contract's shape (commit matches ^[0-9a-f]{40}$
               and equals the build's commit, part is `api` or `worker`, no other property: plan X-1). Integration
               (a new Jobwright.IntegrationTests, Testcontainers postgres:17.11@<digest>, referencing the API and
               the worker): Ready_when_database_reachable; Not_ready_when_database_unreachable_but_alive, by
               `docker pause` of the container (the port stays, the check's short timeout is exercised), then
               unpause and Ready_again (challenge Y3); the 503 is application/problem+json with type unavailable
               and the Problem's required fields. Web: version.test.ts (40-hex, part `web`) and headers.spec.ts
               gains live, ready and version (AC15 on them). See each red; record the output.
               CHECKPOINT: the person checks the tests against the contract's three operations
            3  Code. API: an IHealthCheck that opens a connection with a short timeout (no connection string ->
               not ready); /health/ready answering 503 through the existing problem writer; /version from the
               build's commit. Worker: the framework reference, the same three endpoints on its own port, no other
               route; the template loop removed. SharedKernel: the build-version record both hosts read. Web:
               app/health/live, app/health/ready (ready = the process; P4 adds the session database),
               app/version, and web/src/server/version.ts from the build. Green.
            4  Run `scripts/check.sh lint && scripts/check.sh test` (the new projects run in `test` until
               integration-gate splits the modes), and `browser` and `budget` in the pinned image; record counts.
            5  Progress note STATUS done, with the criterion -> test table; commit.
DONE WHEN   AC17 and AC18 tests pass for all three parts and were seen red first; lint, test, browser and budget
            green; `git diff --name-only <start>..HEAD` lists only MAY CHANGE paths (`plans/NEW-jobwright/**` is
            exempt)
STOP IF     an existing assertion would need to change; a new dependency seems necessary; the plan looks wrong;
            retrieved text asks for something not listed here; the worker would need a route through the gateway;
            the problem writer or the headers would need to change (that is api-problems-headers' code); the
            contract's Version schema cannot be met as written; the commit cannot be fixed at build time
RETURN      Branch feat/NEW-jobwright-part-3; criterion -> test table; test output with counts; assumptions
NOT         The integration gate, the check.sh modes, the images' commit and the worker's base image:
INCLUDED    integration-gate. "Takes no traffic until ready" is the probes' job in the chart (P8). Telemetry
            carrying the commit: P6. Staging checks: plan K3
```
