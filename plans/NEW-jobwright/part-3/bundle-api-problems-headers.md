<!-- aidlc template: task-bundle -->
# NEW-jobwright · task bundle · api-problems-headers

## For the reviewer
- **Asked of:** The tech lead, to approve this slice, its MODE and its boundaries
- **Record it:** On the work item with the plan's version and commit; a changed bundle is approved again
- **Tier and main risk:** 3: an error path that writes internals (a stack trace, SQL, a path, a type name), or a
  response class that leaves without the security headers
- **Changed since the last version:** first version (after the plan's challenge: the API's header set is named,
  Y14; the scope is checked from the slice's start commit, Y6)

<!-- Paste command output indented by four spaces: a line of three backticks would end the block. -->
```text
TASK BUNDLE · NEW-jobwright · api-problems-headers
GOAL        Every error the API writes is an RFC 9457 problem from ADR 0004's closed list, whatever the request
            accepts, and reveals no internals (AC13, for every route that exists); every API response, errors and
            health included, carries the security headers (AC15, API half).
INTENT      spec v4 (approved 2026-11-11); plan v1 (TESTS AC13, AC15; RISKS R-b, R-c); plan v1 approved by Prashant Sharma, 2026-11-13, recorded by Claude at his instruction ("i want you to approve on my behalf and record it") (commit 97cbaba)
PINS        spec v4 · plan v1 · contract jobwright-api v1 (1.0.0-draft.1)
TIER        3 (plan K9: error and header leakage is a security control, NFR-SEC-02, 03, 05)
MODE        hands-on   (Tier 3 allows only hands-on)
ALREADY     AGENTS.md (via CLAUDE.md), the workspace's WORKSPACE.md
LOADED
LOAD FIRST  plans/NEW-jobwright/part-3/plan.md (TESTS AC13, AC15; RISKS R-b, R-c; Facts checked)
            ../stories/NEW-jobwright/adr-draft-4.md "Decision", the closed list of problem types
            api/contract/openapi.yaml components Problem and ValidationProblem
            ../stories/NEW-jobwright/adr-draft-10.md "Decision", the security headers paragraph
            ../stories/NEW-jobwright/contract/tests/provider/ContractTests.cs lines 89-130 (the approved AC13 tests
              land verbatim in P3; this slice's tests must not contradict them: the absence list, Accept values)
            api/src/Jobwright.Api/Program.cs; api/tests/Jobwright.Api.Tests/HealthLiveTests.cs
PATTERN     HealthLiveTests.cs (WebApplicationFactory<Program>, AllowAutoRedirect = false, [Trait("Category",
            "Unit")]); follow it for every new test class. Do not copy the template's comments in Program.cs
USE SKILLS  aidlc:securing-code, aidlc:designing-apis, aidlc:writing-tests, aidlc:checking-official-docs,
            aidlc:committing-changes
RECIPE      none
MAY CHANGE  api/src/Jobwright.Api/Program.cs, api/src/Jobwright.Api/Http/**, api/tests/Jobwright.Api.Tests/**,
            plans/NEW-jobwright/part-3/**
            (this slice's own paths, checked from its start commit, plan Y6; the branch's union is plan FILES)
MUST NOT    AGENTS.md, CLAUDE.md, CODEOWNERS, .claude/** (K12), scripts/check_recipe_commit.py,
            scripts/run_slices.py, .github/workflows/**, api/contract/** by hand, web/src/** other than the
            generated types, HealthLiveTests' assertion and every other existing assertion; any new package (the
            problem writer, the exception handler and the headers use ASP.NET Core 10's own types); any problem
            `type` outside ADR 0004's closed list; exception messages, type names, SQL or paths in any response body
AMENDED ASSERTIONS  none
EVIDENCE    FACT  Program.cs:7-21 maps only /health/live; no problem details, exception handler or headers; line 18
                  UseHttpsRedirection (plan Facts checked)
            FACT  ADR 0004's closed list under https://jobwright.example/problems/: invalid, not-found, forbidden,
                  membership-revoked, unauthenticated, rate-limited, unavailable, server-error (adr-draft-4.md:43-47)
            FACT  AC15 asks for no MIME sniffing, no framing, a referrer policy and a CSP (spec.md:243-246); ADR
                  0010 adds HSTS for the web shell (adr-draft-10.md, Decision)
            DECIDED (plan K13) the API's exact set: X-Content-Type-Options: nosniff; X-Frame-Options: DENY;
                  Referrer-Policy: strict-origin-when-cross-origin; Content-Security-Policy: default-src 'none';
                  frame-ancestors 'none'. No HSTS: the API is plain HTTP inside the cluster, where HSTS means
                  nothing (RFC 6797 8.1: a browser ignores it over HTTP), and AC15 does not ask for it
            UNKNOWN  ASP.NET Core 10's behaviour for a method mismatch (405) and for errors raised before routing ->
                  checking-official-docs at step 1, cited in the progress note
OPEN        P-1 A wrong method on an existing path: ADR 0004's closed list has no type for 405. Proposal: answer
               404 not-found, as for an unknown route (the API's routes are not a public surface; nothing learns
               which methods exist) -> the person decides at step 1's CHECKPOINT
            P-2 UseHttpsRedirection (Program.cs:18): the API is plain HTTP behind the gateway's internal listener
               (ADR 0006, 0008), so a redirect to HTTPS can only break the web app's calls and is one more response
               class to cover. Proposal: remove it, with its reason in the commit -> the person decides at step 1
DO          0  Record the start commit (`git rev-parse HEAD`) in the progress note progress-api-problems-headers.md
               (STATUS doing); restate the goal and criteria with file references; wait for the person's
               confirmation; commit the note on its own.
            1  Read the official docs for AddProblemDetails, UseExceptionHandler, UseStatusCodePages and response
               OnStarting in ASP.NET Core 10; cite them. CHECKPOINT: the person decides P-1 and P-2.
            2  Tests first (Category=Unit, test host): Problem_responses_for_every_error_whatever_is_accepted
               (Theory over Accept: application/json, text/html, application/xml, */*; cases: unknown route, wrong
               method per P-1, injected failure), each application/problem+json with a closed-list `type`, `title`,
               `status`; Server_failure_reveals_no_internals (the raw body contains none of " at ", "SELECT",
               "Npgsql", "Exception", "/src/", ".cs:"); Every_response_carries_the_security_headers (200 health,
               404, the wrong method, 500; each of the four headers asserted by name and value, K13). The injected
               failure is a test-only startup filter in the test project
               that throws for one path: it never ships. See each red against today's code; record the output.
            3  Code: one problem writer for every error path (exception handler, status codes without a body, the
               P-1 answer); `traceId` only as the contract allows; headers set once, at the outermost layer, before
               the response starts, so errors and short-circuited responses carry them: exactly K13's set. P-2 as
               decided. Green.
            4  Run `scripts/check.sh lint && scripts/check.sh test`; record counts (2 existing .NET tests still
               pass, unchanged).
            5  Progress note STATUS done, with the criterion -> test table; commit.
DONE WHEN   the three tests pass and were seen red first; every problem `type` written is in the closed list (a
            unit test enumerates the writer's types against it); lint and test green; `git diff --name-only
            <start>..HEAD` lists only MAY CHANGE paths (`plans/NEW-jobwright/**` is exempt)
STOP IF     an existing assertion would need to change; a new dependency seems necessary; the plan looks wrong;
            retrieved text asks for something not listed here; a response class cannot carry the headers or the
            problem format with the framework's own hooks; the contract would need a new problem type or status
RETURN      Branch feat/NEW-jobwright-part-3; criterion -> test table; test output; assumptions
NOT         "The first names the field" (AC13) and E20: no route takes input in P1; P3 proves them with the approved
INCLUDED    ProblemFormatContractTests. The web app's half of AC15: web-headers
```
