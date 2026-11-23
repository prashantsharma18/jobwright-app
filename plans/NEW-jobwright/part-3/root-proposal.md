# NEW-jobwright · part 3 · proposal for the workspace root

```text
FROM        jobwright-app, plans/NEW-jobwright/part-3/plan.md v1 (K1, Q1, Q2), 2026-11-13
FOR         aidlc-design at the workspace root (coordination plan v5, new-system.md v9); Prashant Sharma approves
WHY HERE    this session writes only in jobwright-app (AGENTS.md Boundaries); the root writes stories/
```

## 1. Split part 3 into nine pull requests (plan K1)

Part 3 as one pull request would run to 8,000 changed lines or more. reviewing-code splits anything near 1,000, and
Prashant Sharma's rule for part 3, aidlc-review before every merge, needs merges per group of slices. aidlc-plan step 5
sends a split to aidlc-design. Proposed: part 3 keeps the first pull request; the rest become parts of their own in
jobwright-app, each with its branch, part index and plan, merged in this order.

| Proposed | Branch | What | Criteria | Waits for |
|---|---|---|---|---|
| part 3 (P1) | feat/NEW-jobwright-part-3 | contract, errors, headers, health, version | AC13, AC15, AC17, AC18 (version) | parts 1, 2 |
| P2 | feat/NEW-jobwright-<n> | isolation in the database | AC4 (keys), AC5, AC25, NFR-DATA-02 | P1 |
| P3 | feat/NEW-jobwright-<n> | API authorization and the v1 operations | AC4, AC6 (API), AC13, E2, E5, E20 | P2; Q1 |
| P4 | feat/NEW-jobwright-<n> | sign-in and sessions | AC1 to AC3, AC14, AC16 (app share), E1, E3, E4, E6 to E8, E12, E25 | P3 |
| P5 | feat/NEW-jobwright-<n> | the shell and accessibility | AC6 (offered), AC7 to AC12, AC26 on the Overview, E10, E11, E19 | P4 |
| P6 | feat/NEW-jobwright-<n> | telemetry | AC18 (telemetry), AC19, E16, E26 | P1 |
| P7 | feat/NEW-jobwright-<n> | the tenant command | AC29, E27 | P2; Q2 |
| P8 | feat/NEW-jobwright-<n> | gates, images, chart | AC22, AC24, AC27, AC17 (probes) | P1 |
| P9 | feat/NEW-jobwright-<n> | the release job (STAGING_TOKEN) | Released versions v2 | everything above; jobwright-gitops M1 to M3 and its security gate; part 4's AppProject (C5, R-k) |

`<n>` is the root's choice. Numbering them 5 to 12 keeps parts 1 to 4 as they are. Part 4's "part 3 first image"
wait then reads "P9's first release". The coordination plan's line "Part 3 proves AC1 to AC19, AC22, AC24 to AC27
and AC29" moves to the rows above. `scripts/story_status.py` then reads one part index per row.

The cost: nine pull requests and nine reviews for one person (plan R-h). It is lowered by running the Tier 1 shell
slices delegated (plan K9).

Rejected: one plan with a pull request per slice on stacked branches. The coordination plan's TRACKING gives one
branch per part, and the status script reads one index per part.

## 2. Q1: a YAML reader for the contract's drift test (new-system.md v9): decided yes (plan Q1), to record

ADR 0004's ContractDocumentTests compares the API's generated document with `api/contract/openapi.yaml`.
Microsoft.OpenApi 2.12.2, already in the graph through Microsoft.AspNetCore.OpenApi, has YAML writers but no reader
(FACT: its assembly). Proposed: **Microsoft.OpenApi.YamlReader 2.12.2** (Microsoft, MIT; api.nuget.org), in the
contract test project only, so it never ships. It brings **SharpYaml 2.1.5** (third party). The alternative is a JSON
copy of the contract beside the YAML file: ADR 0004 names only the YAML, and two copies can drift. It is needed by P3,
not before.

## 3. Q2: the mail stand-in in jobwright-app's tests: decided yes (plan Q2), to record

AC29's verification reads the invitation from the mail stand-in. `axllent/mailpit:v1.33.1` is approved in
jobwright-gitops's DEPENDENCIES only. Proposed: the same pinned image may run as a test container in jobwright-app's
AC29 integration test (P7). Without it, the test proves the invitation was sent through Keycloak's admin events, and
only the owner's run on the cluster shows it captured.

## 4. Two design changes to new-system.md CI (v9), from the plan's challenge

- **AC25's baseline** (plan K5, challenge Y11). new-system.md CI says "AC25 from the second release". Proposed:
  AC25's job always runs `main`'s integration tests against the branch's schema. `main`'s head is what staging runs
  once the release job exists (ADR 0012), and the release tag is not. The job starts with P2's first migration, which
  proves only the mechanism; from the second migration on it tests something.
- **Gates by project, not by trait** (plan challenge Y1). new-system.md CI says `dotnet test --filter-trait
  "Category=Unit"` and `"Category=Integration"`. The approved provider tests carry no trait. Microsoft Testing
  Platform also exits 8 when a filter leaves a project with no test. Proposed: unit and integration gates by project:
  `*.IntegrationTests` and `*.ContractTests` run in the integration and contract gates, every other test project in
  the unit gate. scripts/tests/test_check_split.sh checks that each project is in exactly one gate.

## 5. A question for part 4 (plan Q5)

Traefik refuses an eleventh sign-in attempt before the web app sees it, so its 429 body is Traefik's own. AC16 asks
for a problem response saying when to retry. Will part 4 forward the refusal to a web route with Traefik's errors
middleware? If so, P4 adds the route that renders `rate-limited` with Retry-After.

## 6. A note, no decision needed

The contract stays `1.0.0-draft.1` until aidlc-release tags the first release as 1.0.0 (plan K7).
