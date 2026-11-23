<!-- aidlc template: plan -->
# Plan: NEW-jobwright · part 3 of 4: increment 1 criteria (app)

## For the reviewer
- **Asked of:** The tech lead (Prashant Sharma), to approve plan v1: the slice map for all of part 3, its split into
  nine pull requests (K1, which also needs `aidlc-design` at the workspace root), exception X-1, and the five bundles
  of the first pull request (P1): `contract`, `api-problems-headers`, `web-headers`, `health-version`,
  `integration-gate`
- **Record it:** On the work item (the story's files; tracker undecided, requirements Q1), with the plan's version and
  commit
- **Tier and main risk:** 3 for the part: one tenant reaching another's data, a weakness in signing in, personal data
  in telemetry, or a release that writes what it should not. Each slice is rated on its own (SLICES below); P1's main
  risk is an error or header path that leaks internals or misses a header
- **Changed since the last version:** first version

Inputs read: [spec v4](../../../../stories/NEW-jobwright/spec.md) (approved 2026-11-11), the approved
[design note](../../../../stories/NEW-jobwright/design-note.md) with design amendments 1 to 3,
[`new-system.md` v8](../../../../stories/NEW-jobwright/new-system.md),
[coordination plan v4](../../../../stories/NEW-jobwright/coordination-plan.md) (part 3; ORDER: contract first),
ADRs 0001 to 0015 (`adr-draft-<n>.md`; decisions of 0001, 0002, 0003, 0004, 0008, 0009, 0010, 0011, 0012, 0014 read in
full), the approved contract `contract/openapi.yaml` (v1, `1.0.0-draft.1`, sha256 `4667ae8d…49f4f`, root commit
6952aeb) and its tests under `contract/tests/`, AGENTS.md, `docs/codebase-map.md`, part 1's review record (M1, M2).
The code was read read-only by three explorer passes (api/, web/, the contract tests); three citations of each were
spot-checked and held. No evidence pack: discover did not run (route G).

Restatement (step 1) given 2026-11-13 with ten points; Prashant Sharma answered "i want you take appropriate
decisions" the same day. The decisions are K1 to K12 below: **decided by Claude at his instruction; he may overturn
any of them**, and approving this plan is his confirmation. Two of them cannot be decided here and are asked of him
(Q1, Q2), and one belongs to the workspace root (K1's split).

```text
SPEC       v4 (approved 2026-11-11). Part 3 proves AC1 to AC19, AC22, AC24 to AC27 and AC29 (coordination plan v4).
           Clarifications, decided by Claude at Prashant Sharma's instruction (2026-11-13; he may overturn any):
           K1  Part 3 is about nine pull requests of work, far past the ~1000 changed lines reviewing-code gives for
               one; and "every slice runs aidlc-review before its merge" means merges per group of slices. So the
               work is split into nine pull requests, P1 to P9 (SLICES below), merged in ORDER. P1 stays part 3,
               on branch feat/NEW-jobwright-part-3. P2 to P9 become parts of their own, each with its own branch,
               part index and plan, through aidlc-design at the workspace root (coordination plan v5, proposed in
               root-proposal.md). Until v5 is approved, only P1 is built. This plan is their slice map; each part's
               own aidlc-plan writes its bundles, pinned to whatever the earlier parts taught.
           K2  AC16, jobwright-app's share (revised by challenge Y15): no code reads or logs a client's
               forwarded-address header (E18), and health is never limited; P4's browser-sign-in proves both. The
               limit (Traefik, ADR 0008), the 11th attempt, the two-pod test and the refusal's body are part 4's
               (U1, U3). Traefik refuses before the web app sees the request, so a problem body for the 429 needs
               Traefik's errors middleware to forward to a web route: Q5 asks part 4's owner; if it does, P4 adds the
               route that renders `rate-limited` with Retry-After.
           K3  AC17, AC18 and AC19: part 3 proves them with integration tests, and AC19 with an in-process exporter
               that records every attribute against the allowlist (ADR 0009) and searches for seeded personal values.
               The checks in deployed staging run once staging exists (after part 4 and P9), from a person's runtime
               evidence: agents have no lab access (WORKSPACE.md). They are aidlc-release's rows, not P1's.
           K4  AC29: the command is Jobwright.Admin (ADR 0001); jobwright-gitops's create-tenant.sh is the guarded
               wrapper, and "refuses any other cluster" is its guard (part 4). Part 3 proves AC29 by an integration
               test against containers (PostgreSQL by Testcontainers, Keycloak 26.8.2, and the mail stand-in if Q2
               allows); the owner's run on the cluster is outside the agent (spec rule; AGENTS.md Boundaries).
               AC22 in jobwright-app: no script here acts on a cluster; P8 adds the CI lint that any script calling
               kubectl, helm or k3d sources the guard, seen red once with a fixture.
           K5  AC25 (revised by challenge Y11): the previous version is the one staging runs, which after P9 is
               `main`'s head (every merge updates staging, ADR 0012), and before P9 is `main`'s head too. So AC25's job
               always runs `main`'s integration tests against the branch's schema. Its first run, with P2's first
               migration, finds no database tests on `main` and proves only the mechanism; from P2's second
               migration on it tests something. new-system.md's "from the second release" changes to this: a design
               change, sent to aidlc-design (root-proposal.md 4).
           K6  S12's "one tenant-owned table" is `invitations`: the contract has /v1/invitations, and the approved
               RowLevelSecurityTests list memberships, tenant_settings and invitations (RowLevelSecurityTests.cs:16).
           K7  The contract lands byte for byte as approved, `info.version: 1.0.0-draft.1` included (a mechanical
               recipe commit, `contract` step 1). `1.0.0` is set at the first release, by aidlc-release, with the
               release tag that oasdiff then compares against. Until then a change goes through aidlc-design.
           K8  The release slice (P9) waits for three things: jobwright-gitops's M1, M2 and M3 fixed and its security
               gate given (story index), and part 4's AppProject slice merged (coordination plan v4 ORDER, C5; risk
               R-k). It is not built before all three.
           K9  Tier and MODE per slice (SLICES below). Tier 3, hands-on only: anything that touches sign-in,
               sessions, tokens, tenant isolation, error and header leakage, telemetry, scans, gates and workflows,
               the tenant command or the release. Tier 2, delegate with checkpoints: a slice that touches the
               contract's endpoints and nothing above. Tier 1, delegate: the shell's look and navigation and the
               accessibility harness, when they touch none of the above. "rs" marks a slice run_slices.py can run
               once its bundle is approved AND the working tree is clean: today `.claude/settings.json` is
               modified (K12), which run_slices.py refuses (run_slices.py:118-119), and a step that installs a
               package needs a person's permission (`pnpm -C web add` is an "ask" rule), which a headless session
               is denied (challenge Y2; Q6). P2 to P9's tiers are provisional: each part's own plan rates them
               (challenge Y12).
           K10 Every slice runs aidlc-review before its pull request merges (Prashant Sharma's rule for part 3, unlike
               part 2's slice 0). Each part index carries the rows aidlc-plan, aidlc-build, aidlc-verify,
               aidlc-review, merged; the merged row is marked in the final commit, after review.
           K11 The approved provider and consumer tests go in word for word, each in the slice whose fixtures it
               needs: RowLevelSecurityTests in P2, ContractTests.cs (the drift test and AC4, AC6, AC13, E2) in P3,
               the consumer test in P4. The contract file and the web types generated from it land first (ORDER), and
               every API change after that is test first against it. Changing the drift test so that it passes
               earlier was rejected (REJECTED).
           K12 The uncommitted `.claude/settings.json` (sandbox off) is Prashant Sharma's setting; no slice stages or
               changes it (every bundle's MUST NOT). It also blocks run_slices.py while it stays uncommitted (Q6).
           K13 The API's security headers (challenge Y14), asserted by name and value: X-Content-Type-Options:
               nosniff; X-Frame-Options: DENY; Referrer-Policy: strict-origin-when-cross-origin;
               Content-Security-Policy: default-src 'none'; frame-ancestors 'none'. No HSTS on the API: it is plain
               HTTP inside the cluster (RFC 6797 8.1: browsers ignore HSTS over HTTP), and AC15 does not ask for it.
               The web app sends HSTS (ADR 0010), as it is reached over HTTPS through the gateway.
           X-1 Exception to AGENTS.md's "contract first ... its failing tests before any API code" (challenge Y7),
               for Prashant Sharma's approval with this plan: from P1 until P3's contract-tests, the API's /version,
               /health/* and problem responses are checked against the contract by tests that assert the contract's
               shapes (Version's pattern and enum, Problem's required fields, the media type), not by the drift
               test, which needs a YAML reader (Q1) and the fixtures of P3. Reason: the approved drift test cannot
               run before every operation exists, and changing it was rejected (K11). Owner: Prashant Sharma.
               Expiry: P3's contract-tests merge, or 2026-12-31, whichever comes first; past that it is a violation.
APPROACH   Contract first, then each criterion test first, in nine reviewable pull requests (K1). P1 lays what every
           later part stands on: the contract in the repository, generated web types, one error format for the API,
           the security headers on both servers, health and version for every part, and the integration gate
           against a real PostgreSQL. P2 builds isolation in the database before anything reads tenant data; P3 the
           API's authorization and the v1 operations, closing the contract's drift test; P4 sign-in and sessions in
           the web app; then the shell, telemetry, the tenant command and the remaining gates, which do not depend on
           each other; the release job last, behind K8's three waits.
SLICES     (P = pull request; P1 is this part's; P2 to P9 are proposed parts, K1; "rs" = safe for run_slices.py)
           P1  part 3: contract, errors, headers, health, version (this plan's five bundles)
               contract              K7 recipe, generated web types, lint keeps them current   T2 hands-on (Y2: the install asks)
               api-problems-headers  AC13 (API, every route that exists), AC15 (API, K13)   T3 hands-on
               web-headers           AC15 (web): nonce CSP, headers on pages, 404, redirects, static   T3 hands-on
               health-version        AC17, AC18 (version) for API, worker, web; tests by project   T2 delegate w/ checkpoints  rs
               integration-gate      AC27 (part): `integration` gate, tests split by project, commit in the images   T3 hands-on
           P2  isolation in the database (ADR 0003)
               schema-roles          AC5, AC4 (unique per tenant), NFR-DATA-02; RowLevelSecurityTests verbatim; schema check   T3
               tenant-context        ADR 0003 interceptors: set at TransactionStarted, fail loudly (C1, C4)   T3
               migration-gates       up-down-up job; AC25's job (K5); expand-only rule   T3
           P3  the API: authorization and the v1 operations (ADR 0002 web-to-API, ADR 0004)
               api-auth              JwtBearer, membership and role per request, X-Jobwright-Tenant; E2, E5   T3
               api-v1                /v1/me, tenant/settings, members, invitations; AC4, AC6 (API), E20   T3
               contract-tests        ContractTests.cs verbatim, ApiFixture, the drift test (Q1); `contract` gate   T3
           P4  sign-in and sessions in the web app (ADR 0002)
               web-session           web_sessions, __Host-jw-session, AES-256-GCM tokens; AC3, E1, E8, E12   T3
               web-oidc              openid-client PKCE; AC1, AC2, E4, E6, E7, refresh lock, E3's choice   T3
               web-api-client        openapi-fetch client, problem handling, the consumer test verbatim; E2   T3
               browser-sign-in       browser gate with a test Keycloak realm: AC1, AC2, AC14, E12, E25; AC16 (K2)   T3
           P5  the shell (ADR 0010), after P4
               tokens-theme          AC9, AC11, E10, Inter; M1 (dark really applied)   T1 delegate  rs
               navigation            AC6 (offered), AC7, AC8, E11, Settings read only (U4)   T1 delegate  rs
               top-bar               AC10, E19, the tenant switch control (E3: touches the session)   T2 (Y12)
               accessibility         AC12 on every page, M2 (pages found, not listed), keyboard, skip link,
                                     360 to 2560 px; AC26 on the signed-in Overview, same 163,840 bytes   T2 (Y12: the sign-in harness)
           P6  telemetry (ADR 0009), after P1
               telemetry             AC18 (telemetry carries C), AC19 in-process (K3), E16, E26; api, worker, web   T3
           P7  the tenant command, after P2
               tenant-command        AC29, E27; Jobwright.Admin against Keycloak and PostgreSQL (K4, Q2)   T3
           P8  gates and images, after P1
               scans                 AC24: gitleaks, trivy fs and image, syft bills, planted findings; install-hooks.sh (E23)   T3
               chart                 charts/jobwright: three workloads, non-root, read-only root, probes gate traffic (AC17),
                                     no public route for API or worker (D1); helm template tests   T3
               cluster-script-lint   AC22 (K4)   T2 delegate w/ checkpoints  rs
               gates-drill           AC27: every gate seen red once and required on `main` (ADR 0014)   T3
           P9  the release job (ADR 0012, ADR 0014), after everything, and after K8's three waits
               release-job           publish_plan.py and staging_commit.py with their approved tests verbatim;
                                     the main-only job in environment staging-release   T3
FILES      (P1 only; P2 to P9's files are named by their own plans. Each bundle lists its own; this is their union)
           api/contract/openapi.yaml                      the contract, byte for byte (K7; recipe from root commit 6952aeb)
           web/package.json, web/pnpm-lock.yaml           openapi-typescript 7.13.0, exact devDependency (approved, new-system.md); `generate:api` script
           web/src/server/api/schema.d.ts                 types generated from the contract (ADR 0004; the path the approved consumer test imports)
           web/.prettierignore, web/eslint.config.mjs     only if lint refuses the generated file (contract step 3)
           scripts/check.sh                               lint: the generated types match the contract (contract); test and integration modes by project (integration-gate)
           scripts/tests/test_check_split.sh              every test project runs in exactly one gate (integration-gate)
           api/src/Jobwright.Api/Program.cs               problem details, exception and status handling, headers, /version, /health/ready
           api/src/Jobwright.Api/Http/*.cs                the problem writer and the headers middleware (api-problems-headers)
           api/src/Jobwright.Api/Health/*.cs              the readiness check and the version endpoint (health-version)
           api/src/Jobwright.Api/Jobwright.Api.csproj     Npgsql.EntityFrameworkCore.PostgreSQL (pinned) for the readiness connection
           api/src/Jobwright.Worker/*                     health and version over HTTP on the worker's own port (A3), Microsoft.AspNetCore.App framework reference
           api/src/Jobwright.SharedKernel/*               the build-version record both hosts read
           api/tests/Jobwright.Api.Tests/*                AC13, AC15 and the API's AC18 unit tests
           api/tests/Jobwright.Worker.Tests/*             the worker's AC17 live and AC18 unit tests (new; the Api.Tests csproj as pattern, Y10)
           api/tests/Jobwright.IntegrationTests/*         AC17 readiness of the API and the worker against Testcontainers PostgreSQL (new)
           api/**/packages.lock.json, api/Jobwright.slnx  follow the references (locked-mode restore)
           web/src/proxy.ts                               per-request nonce and the CSP (ADR 0010; U5 answered: proxy.ts)
           web/src/app/layout.tsx                         reads the nonce (x-nonce)
           web/src/lib/csp.ts, csp.test.ts                the policy builder and its unit test
           web/next.config.ts                             headers() for every path proxy.ts does not reach; the build's commit
           web/src/app/not-found.tsx                      a 404 page, so AC15 has a page-class error to check
           web/src/app/health/**, web/src/app/version/**  AC17, AC18 for the web app
           web/src/server/version.ts, version.test.ts     the commit the web build carries
           web/tests/e2e/headers.spec.ts                  AC15 on every route class of the web app
           Dockerfile.web, Dockerfile.api, Dockerfile.worker   JOBWRIGHT_COMMIT into each build; the worker on the pinned aspnet base
           .github/workflows/ci.yml                       the `integration` job; the build passes github.sha
           plans/NEW-jobwright/part-3/**                   this plan, its bundles and progress notes
TESTS      (P1; each named with its ID; level in brackets)
           AC13  api: Problem_responses_for_every_error_whatever_is_accepted (unknown route, wrong method, injected
                 failure 500; Accept json, html, xml, */*) [unit, test host]. "The first names the field" needs a route
                 that takes input: none exists in P1, so it is P3's (the approved ProblemFormatContractTests, pageSize=0)
                 api: Server_failure_reveals_no_internals (no " at ", SELECT, Npgsql, Exception, /src/, .cs:) [unit]
           AC15  api: Every_response_carries_the_security_headers (success, 404, 405, 500, health, version) [unit]
                 web: headers.spec.ts `AC15 every response carries the security headers` (page, 404, a redirect,
                 a static script, health, version) and `AC15 the CSP nonce changes per request` [browser]
                 web: csp.test.ts (directives; no unsafe-eval; script-src by nonce only) [unit]
           AC17  api, worker: Ready_when_database_reachable, Not_ready_when_database_unreachable_but_alive,
                 Ready_again [integration, Testcontainers postgres:17.11 by digest, `docker pause` and unpause, so
                 the port stays (challenge Y3)]; web: live and ready answer [unit]
           AC18  api, worker, web: Version_answers_the_commit_built_from, asserting the contract's Version shape
                 (X-1) [unit]; check.sh build: each image's /version equals the commit it was built with [build]
           E20   P3 api-v1, on /v1/members/{memberId}: P1 has no route that takes an identifier
           AC27  (part) test_check_split.sh: every test project in exactly one gate [unit]; the `integration` job
                 reports on the pull request, seen red once, and is required on `main` (ADR 0014; Q4)
           (P2 to P9: SLICES names each criterion's slice; their plans name the tests, the approved ones verbatim.)
FIRST      Every slice starts green and writes its failing tests before its code (AGENTS.md). Seen red once: the
           integration gate (a deliberately failing assertion in one commit, then a revert commit, both pushed by
           Prashant Sharma: never a dropped commit, Y8), and each header and problem test against today's code
           before the change.
ORDER      P1's slices, in this order: contract -> api-problems-headers -> web-headers -> health-version (its 503
           is a problem response, and its web routes carry web-headers' headers) -> integration-gate (it splits the
           projects health-version adds). Each bundle's scope is checked from its own start commit (Y6). Then P2 -> P3 -> P4 -> P5; P6 and P8 after P1; P7 after P2; P9 last (K8).
           Stop at the first slice that ends red; a later slice never starts on red.
RISKS      R-a The generated web types drift from the contract -> lint regenerates and fails on any difference
           R-b An error path the tests do not reach writes internals -> one exception handler and one status writer
               for every path; the injected-failure test asserts the absence list on the raw body
           R-c A header missing on a class of response (redirects, static files, errors raised before routing) ->
               headers set at the outermost layer of each server; tests per route class, static included
           R-d The nonce makes every page dynamic and costs the budget -> AC26's budget test runs in the same pull
               request (web change: browser and budget, AGENTS.md); the threshold never moves
           R-e Testcontainers on GitHub's runner or on the owner's machine while k3d runs (memory) -> the integration
               job proves the runner; locally `scripts/check.sh integration` refuses while k3d runs, like dev.sh
           R-f The worker's HTTP port reaches the gateway -> the worker binds its own port, no route exists for it;
               the chart test in P8 proves no route (D1)
           R-g The drift test needs a YAML reader the design did not approve -> Q1, asked now, needed only in P3
           R-h Nine pull requests are more process for one person -> accepted as the cost of review before merge
               (K10); Tier 1 slices run delegated (K9) to cut the hands-on time
           R-k (story risk, open until part 4's AppProject) -> K8: no slice here holds STAGING_TOKEN before it
           R-l P1 itself passes ~1000 changed lines (challenge Y13) -> generated and mechanical lines (schema.d.ts,
               the lock file, the recipe's contract) are checked by tools, not read; if aidlc-verify counts more than
               1,000 hand-written lines, P1 splits before review: integration-gate becomes its own pull request
           R-m A delegated slice edits a Tier 3 slice's code (challenge Y5, Y6) -> each bundle lists only its own
               paths and MUST NOT names the Tier 3 slices' files; the scope test runs from its start commit
REJECTED   One pull request for all of part 3 -> 8,000 lines or more; no reviewer reads that (reviewing-code)
           A pending-operations list inside the approved drift test, so it runs from P1 -> it changes an approved
               test's assertion; the drift it would catch early (version and health) is caught by P3 before any
               release, and P1's endpoints are written test first against the contract
           Declaring every v1 operation in P1 with placeholder handlers, so the drift test passes -> stubs (Quality bar)
           A YAML package in Python for the release job -> deferred to P9's plan: JSON is valid YAML, so a JSON-shaped
               values file needs no package, if jobwright-gitops agrees (P9's open question)
           Microsoft.AspNetCore.HealthChecks.NpgSql or AspNetCore.HealthChecks.* for readiness -> a new dependency;
               a twenty-line IHealthCheck over Npgsql does it
           Splitting the gates by test trait (new-system.md CI's `--filter-trait`) -> the approved tests carry no
               trait, and Microsoft Testing Platform exits 8 when a filter leaves a project with no test (challenge
               Y1); split by project instead, checked by test_check_split.sh
           Stopping and restarting the PostgreSQL container for AC17 -> it comes back on a new host port (Y3)
ROLLBACK   Before merge, a slice is reverted by revert commits on the branch (Prashant Sharma pushes; never a force
           push). After merge, revert the merge commit and, in the same step, remove `integration` from the
           required checks on `main`: otherwise every pull request waits for a job that no longer exists (ADR
           0014; challenge Y8). P1 changes no data and deploys nothing (no release job until P9). From P2 on,
           migrations are expand-only with a tested down path (ADR 0006), so a revert leaves the schema usable by
           the previous version.
OPEN       (Q1, Q2, Q5 and Q6 decided by Claude at Prashant Sharma's instruction, "you decide and approve",
           2026-11-13; he may overturn any. Q3 and Q4 are actions only he or the workspace root can take.)
           Q1 DECIDED yes: Microsoft.OpenApi.YamlReader 2.12.2 in the contract test project only (never shipped);
              SharpYaml 2.1.5 comes with it. Why: Microsoft's own reader for the library already in the graph; a
              second JSON copy of the contract could drift. Recorded in new-system.md v9 by the root (Q3's session)
              before P3's contract-tests adds it. The question was: approve Microsoft.OpenApi.YamlReader 2.12.2 (Microsoft, MIT; brings SharpYaml 2.1.5, third party) as a
              test-only dependency, so ContractDocumentTests can read the YAML contract? Microsoft.OpenApi 2.12.2 in
              the graph has YAML writers but no reader (FACT, its assembly; api.nuget.org nuspec of YamlReader
              2.12.2). The alternative is a JSON copy of the contract, which ADR 0004 does not name. -> Prashant
              Sharma, then new-system.md v9 at the root; blocks P3's contract-tests only
           Q2 DECIDED yes, for tests only, the same pinned image; recorded with Q1 in new-system.md v9. The question
              was: may jobwright-app's AC29 test run the mail stand-in, axllent/mailpit:v1.33.1, the image approved for
              jobwright-gitops? Without it the test proves the invitation was sent through Keycloak's admin events,
              and only the owner's run shows it captured. -> Prashant Sharma; blocks P7 only
           Q3 Coordination plan v5 with K1's split (root-proposal.md) -> aidlc-design at the workspace root, Prashant
              Sharma approves; blocks P2 to P9, not P1
           Q4 The required checks after P1: setup, lint, test, build, browser, budget, integration -> Prashant
              Sharma adds `integration` to the rule before P1 merges (ADR 0014; integration-gate step 4)
           Q5 DECIDED for this plan: P4 builds the web route that renders `rate-limited` with Retry-After; part 4's
              plan wires Traefik's errors middleware to it (carried in root-proposal.md 5). The question was: does
              part 4 forward Traefik's 429 on the sign-in routes to a web route (errors middleware), so the
              refusal is a problem response? (K2; challenge Y15) -> Prashant Sharma, as part 4's owner; blocks only
              P4's 429 route, not P1
           Q6 DECIDED: `.claude/settings.json` stays as Prashant Sharma left it (K12; an agent does not change a
              safety setting); P1 is built in interactive sessions, health-version in its delegate-with-checkpoints
              mode, without run_slices.py. The question was: run_slices.py needs a clean tree: commit, revert or set aside `.claude/settings.json` before a
              delegated run (K9, K12; challenge Y2) -> Prashant Sharma; blocks only the delegated runs

Checklist: every criterion maps to a check (P1 here; P2 to P9 by slice, each part's plan names the tests); every file
has a reason; every risk mitigated or accepted; no architecture decision hidden (K1, Q1, Q2 named for their owners);
rollback concrete; slices safe in order; each bundle has a scope test and concrete stop conditions.

APPROVAL   plan.md v1 (commit 97cbaba, with the approval-record commits after it) approved by Prashant Sharma
           (tech lead), 2026-11-13, recorded by Claude at his instruction ("i want you to approve on my behalf and
           record it"; before that, "you decide and approve"), with the bundles contract, api-problems-headers,
           web-headers, health-version and integration-gate v1, decisions K1 to K13, Q1, Q2, Q5 and Q6, and
           exception X-1. Not an independent review: the plan's drafter recorded it; the fresh reviewer's challenge
           (Y1 to Y15) is the only independent check. Conditions: X-1 is restated in P1's pull request description
           for him to confirm there (AGENTS.md Quality bar: a person approves an exception in the pull request); P2
           to P9 wait for coordination plan v5 (Q3); P1 merges only after `integration` is a required check (Q4).
```

## Criteria coverage

| Criterion | Pull request, slice | Notes |
|---|---|---|
| AC1, AC2 | P4 web-oidc, browser-sign-in | real Keycloak in the browser gate |
| AC3 | P4 web-session | controlled clock, E1's values |
| AC4 | P2 schema-roles (unique per tenant), P3 api-v1 and contract-tests | the approved tests verbatim (K11) |
| AC5 | P2 schema-roles, tenant-context | RowLevelSecurityTests verbatim |
| AC6 | P3 api-v1 (refused, forbidden), P5 navigation (not offered) | |
| AC7, AC8, AC9, AC10, AC11 | P5 | Inter replaces the scaffold's Geist (layout.tsx:2) |
| AC12 | P5 accessibility (and every web slice keeps it green) | M1, M2 of part 1's review |
| AC13 | P1 api-problems-headers, P3 contract-tests | |
| AC14 | P4 browser-sign-in | |
| AC15 | P1 api-problems-headers, web-headers | |
| AC16 | P4 browser-sign-in (K2); part 4 the limit | |
| AC17 | P1 health-version; P8 chart (probes gate traffic) | staging check: K3 |
| AC18 | P1 health-version (version); P6 telemetry (telemetry carries C) | staging check: K3 |
| AC19 | P6 telemetry (in-process) | staging check: K3 |
| AC22 | P8 cluster-script-lint (K4) | |
| AC24 | P8 scans, chart | |
| AC25 | P2 migration-gates (K5) | |
| AC26 | already enforced (163,840 bytes); P5 accessibility moves it to the signed-in Overview | threshold unchanged |
| AC27 | each slice that adds a gate; P8 gates-drill | required on `main` (ADR 0014) |
| AC29 | P7 tenant-command (K4, Q2) | |
| E1, E3, E4, E6, E7, E8, E12, E25 | P4 | E3's control in P5 top-bar |
| E2, E5, E20 | P3 | |
| E9, E18 | P4 browser-sign-in (K2) | |
| E10, E11, E19 | P5 | |
| E16, E26 | P6 | |
| E23 | P8 scans | |
| E27 | P7 | |
| E28, E31, E33 | P8 gates-drill, P9 | branch protection is Prashant Sharma's setting |

## Facts checked

- FACT `api/src/Jobwright.Api/Program.cs:7-21`: AddOpenApi, AddHealthChecks, MapOpenApi in Development only,
  UseHttpsRedirection, and only `/health/live`. No problem details, headers, /version or /health/ready.
- FACT `api/src/Jobwright.Worker/Program.cs:4`, `Worker.cs:7-13`: the template worker, no HTTP. `Dockerfile.worker:21`
  uses the runtime base, `:18-19` publishes the worker and Jobwright.Admin.
- FACT `api/Directory.Packages.props:4,7-22`: central versions, EF Core with Npgsql, OpenTelemetry, JwtBearer and
  Testcontainers already pinned but referenced by no project; `api/Directory.Build.props:4,6,8`: warnings as errors,
  lock files, linux-x64.
- FACT `scripts/check.sh:15`: `dotnet test api/Jobwright.slnx` with no trait filter; `ModuleBoundaryTests` has no
  trait (the api explorer; "Category" appears once in the repository).
- FACT `.github/workflows/ci.yml:25-169`: six jobs, no `needs:`, no services, `permissions: contents: read`.
- FACT `web/src/app/page.tsx:3-4` is the only route; no proxy.ts, not-found page, health or version route;
  `web/next.config.ts:5,7` standalone output and `agentRules: false`, no headers().
- FACT `web/tests/e2e/budget.spec.ts:7` `SCRIPT_BUDGET_BYTES = 163_840`; `accessibility.spec.ts:5-8` the page list.
- FACT the approved `contract/tests/provider/ContractTests.cs:1-7` say the tests run red "once the test host and
  fixtures exist", with two seeded tenants and a test signing key; `RowLevelSecurityTests.cs:7` imports Npgsql (in
  the graph through Npgsql.EntityFrameworkCore.PostgreSQL).
- FACT Microsoft.OpenApi 2.12.2's assembly has `OpenApiYamlWriter` and `IOpenApiReader` but no YAML reader;
  Microsoft.OpenApi.YamlReader 2.12.2 exists on nuget.org (Microsoft, MIT), depending on SharpYaml 2.1.5 (Q1).
- UNKNOWN whether .NET 10's built-in generator can emit the contract's `additionalProperties: false`,
  `type: [string, 'null']`, `examples` and `pattern` exactly (design note D4's open unknown) -> answered by P3's
  contract-tests; if it cannot, the test reports it and aidlc-design decides; the build never edits the contract
  (ADR 0004). P1's health-version records what the generator emits for /version and /health/* as early evidence.

## Challenged

A fresh reviewer, given only the plan, its bundles and the repository, was briefed to argue against them
(stress-testing-decisions, 2026-11-13). Its 15 objections and their answers. Y2 (the dirty tree, the "ask" rule) and
Y4 (getVersion answers only 200, contract openapi.yaml:106-117) were checked against the files and hold. Y10's
template file was not found on this machine; its fix costs nothing, so it is taken.

| ID | Objection | Severity | Answer |
|---|---|---|---|
| Y1 | Trait filters exit 8 on projects with no matching test, and the approved tests carry no trait | blocker | Changed: tests split by project (`dotnet test --project`), checked by test_check_split.sh; no edit to ModuleBoundaryTests; REJECTED gains the trait split; new-system.md's wording to the root |
| Y2 | No "rs" slice can run: the tree is dirty (K12) and `pnpm -C web add` is an "ask" rule | blocker | Changed: contract is hands-on; "rs" now needs a clean tree (K9); Q6 to Prashant Sharma |
| Y3 | A restarted Testcontainers PostgreSQL gets a new host port | serious | Changed: `docker pause` and unpause (TESTS AC17; health-version step 2) |
| Y4 | A 503 on /version is not in the contract | serious | Changed: /version answers only 200; the commit is fixed at build time and a build without one fails |
| Y5 | health-version carried Tier 3 work (ci.yml, gates, images) | serious | Changed: split; integration-gate is Tier 3, hands-on |
| Y6 | Cumulative MAY CHANGE lists let delegated slices edit Tier 3 code | serious | Changed: each bundle lists its own paths, checked from its start commit; FILES is the union; R-m |
| Y7 | P1 writes contract endpoints with no contract test | serious | Changed: exception X-1, with reason, owner and expiry, for approval; P1's tests assert the contract's shapes |
| Y8 | The rollback leaves `integration` required; "dropped" red commits need a force push | serious | Changed: ROLLBACK removes the rule with the revert; red runs use a revert commit pushed by Prashant Sharma |
| Y9 | The recipe copied a mutable file; the first lint red failed for the wrong reason | serious | Changed: recipe `git show 6952aeb:...`; install before the red run |
| Y10 | The xunit3 template's csproj writes a Version (NU1008); Testcontainers not named as allowed | minor | Changed: new projects follow Jobwright.Api.Tests.csproj; the allowed packages named; postgres by digest |
| Y11 | K5's release-tag baseline is wrong; its first run tests nothing; rewording new-system.md is a design change | minor | Changed: K5 always compares with `main`'s head and says what the first run proves; sent to aidlc-design |
| Y12 | top-bar and accessibility touch the session; Tier 1 contradicts K9 | minor | Changed: both Tier 2; P2 to P9's tiers are provisional, set by each part's plan |
| Y13 | P1 itself may pass ~1000 lines | minor | Accepted with a trigger (R-l): generated lines are checked by tools; above 1,000 hand-written lines, integration-gate splits off |
| Y14 | The API's header set is not named; HSTS over HTTP cannot be asserted | minor | Changed: K13 names the set; no HSTS on the API |
| Y15 | Traefik refuses before the web app sees the request, so the web app cannot write the 429 problem | minor | Changed: K2 revised; Q5 to part 4's owner |
