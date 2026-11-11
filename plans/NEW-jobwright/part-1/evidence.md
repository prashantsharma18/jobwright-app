<!-- aidlc template: evidence-table -->
# NEW-jobwright · part 1 of 4 (slice 0) · evidence

From the trusted run, never the agent's summary. Drafted by aidlc-verify, 2026-11-11, for the people who approve the
merge; nothing here is an approval.

**Trusted run:** pull request #1, CI run
[42999475010](https://github.com/prashantsharma18/jobwright-app/actions/runs/42999475010), event `pull_request`,
head **9f05a3d**, 2026-11-11 09:57-09:59 UTC, all six jobs `success`. Later commits on the branch change `plans/`
only (`git diff --stat 9f05a3d HEAD -- . ':!plans'` is empty); the run on the pull request's final head must be green
too before the merge.

**Verdict:** every DONE WHEN check of the four slice-0 bundles holds: the CI-checkable ones in the trusted run, the rest
locally on a tree identical to 9f05a3d outside `plans/`. Route G, slice 0: no spec criterion is proved here (AC12,
AC26 and AC27 get their harness only), so the rows are the bundles' DONE WHEN checks. Three things need a person's
decision before the merge (see **For the approver**): D6's loosened architecture rule, the scaffold recipe review
that was delegated, and the scans that slice 0 does not run.

## CI gates (AC27, part)
| Gate | What it runs | Local (tree of 9f05a3d) | Trusted CI (42999475010) | Seen red once |
|---|---|---|---|---|
| setup | `pnpm -C web install --frozen-lockfile`, `dotnet restore --locked-mode` | - | success 0:34 | drill 1 [42966349758](https://github.com/prashantsharma18/jobwright-app/actions/runs/42966349758): `ERR_PNPM_OUTDATED_LOCKFILE` |
| lint | `scripts/check.sh lint`; actionlint 1.7.12 (checksum); the SHA rule | exit 0, also on a clean worktree (E12) | success 0:58; actionlint "OK"; "every uses is a 40-character SHA" success | first run [42964529734](https://github.com/prashantsharma18/jobwright-app/actions/runs/42964529734) (real fault, E12); drill 2 (prettier) |
| test | `scripts/check.sh test` | web 2, .NET 2 (0 skipped), dev.sh 3 | success 0:50, same counts | drill 2 [42966685123](https://github.com/prashantsharma18/jobwright-app/actions/runs/42966685123): HealthLive "Expected: OK Actual: NotFound" |
| build | `scripts/check.sh build` (web, .NET Release, three images, never pushed) | exit 0, 0 warnings | success 1:52 | drill 2: `drill-missing.props: not found` |
| browser | `scripts/check.sh browser` in the pinned Playwright image | 8 passed | success 1:07, 8 passed | drill 2: AC12 color-contrast in 4 projects |
| budget | `scripts/check.sh budget` | 1 passed, 135,165 B | success 1:06, 1 passed, "135165 in 5 responses (budget 163840)" | drill 2: "Expected: <= 1 Received: 135165" |

Every gate green, red for its own reason, then green again (revert 9e6c1dc, run
[42967216637](https://github.com/prashantsharma18/jobwright-app/actions/runs/42967216637)); the new ports' first CI
run is the trusted one above.

## Tests
| Item | Test | Local | Trusted CI |
|---|---|---|---|
| AC12 (harness) | web/tests/e2e/accessibility.spec.ts `AC12 every page has no WCAG 2.2 AA violation` × 360/1440, light/dark | pass ×4 | pass ×4 |
| AC26 (harness) | web/tests/e2e/budget.spec.ts `AC26 first load stays within the script budget` (163,840 B = 135,165 × 1.2, next 10 KiB; E5) | pass | pass |
| page | web/tests/e2e/skeleton.spec.ts `home page answers with the Jobwright heading` (also: no console error, E4) × 4 projects | pass ×4 | pass ×4 |
| K2 | api/tests/Jobwright.Api.Tests/HealthLiveTests.cs `HealthLive_answers_200_without_authentication` | pass | pass |
| U13, ADR 0001 | api/tests/Jobwright.ArchitectureTests/ModuleBoundaryTests.cs (ArchUnitNET) | pass | pass |
| web | web/src/lib/utils.test.ts (cn, 2 tests) | pass ×2 | pass ×2 |
| dev.sh | scripts/tests/test_dev.sh `refuses while a k3d cluster runs` (name and label), `refuses when docker does not answer`, `fails naming the port when 15432 is taken` | pass ×3 | pass ×3 |

Total in CI: 16 test executions (16 passed, 0 failed, 0 skipped): web unit 2, .NET 2 (total 2, failed 0, skipped 0),
dev.sh 3, browser 8 (2 tests × 4 projects), budget 1. Read from the run's logs.

## Other DONE WHEN checks (not a CI gate)
Deterministic checks over the tested tree; run for this table on 2026-11-11 unless a step is named.

| Check | Result | Where |
|---|---|---|
| Health check: dev.sh's real run on the new ports | API `/health/live` 200 "Healthy" on 127.0.0.1:15080; web 200 with the heading on 15300; Keycloak 302 on 18080; PostgreSQL accepting on 15432; 127.0.0.1 only; clean stop (no container, credentials, listener or process) | local only: progress-slice-0-ci.md step 6, two runs (before and after eb0cece) |
| Images run as non-root and answer | web uid 1000 `/` 200; API uid 1654 `/health/live` 200; worker uid 1654 up | local only: progress-slice-0-ci.md step 3 |
| Windows ports (R-j) | dynamic range from 49152; none of the four ports in the 20 exclusion ranges or listening | local only: step 6 |
| Direct dependencies at their pins | 35 of 35 exact and at new-system.md v6's Pinned versions (21 npm, 14 NuGet); lock files agree (CI's frozen and locked restores) | this table |
| No placeholder | `git grep -i -E "weatherforecast\|Class1\|UnitTest1"` none | this table |
| .NET target and test platform | no `net8.0` or `TestingPlatformDotnetTestSupport` in api/; both test projects reference only xunit.v3.mtp-v2 (4.0.2) | this table |
| Telemetry off (Q13) | check.sh exports all three; ci.yml and dev.sh all three; Dockerfile.web NEXT_TELEMETRY_DISABLED; Dockerfile.api and .worker both .NET names | this table and step 6 |
| shadcn | devDependencies 4.23.0, not in dependencies | this table |
| Ports | web `dev`/`start` `-H 127.0.0.1 -p 15300`; API profile `http://127.0.0.1:15080`; no reserved port (3000, 3001, 4318, 4444, 9090, 9091); no old dev port outside plans/; the only `0.0.0.0` is Dockerfile.web's in-container HOSTNAME | this table and step 6 |
| Workflow | no `secrets.` in .github; 24 `uses:`, each a 40-character SHA with `# vX.Y.Z`; actionlint 1.7.12 exit 0 | step 6, and CI's lint job |
| Images | every FROM (2 per Dockerfile) carries a digest | step 6 |
| Recipe commit 06a65b0 (scaffold) | generator output only; trailers `Recipe: create-next-app@16.4.5`, `shadcn@4.23.0`, `dotnet-sdk@10.0.403` (scaffold) | progress-slice-0-scaffold.md; review delegated (see For the approver) |
| Recipe commit 366edc2 (ports) | `check_recipe_commit.py` exit 0: "reproduces, the test count is unchanged" (rerun for this table); reviewed and approved by Prashant Sharma, 2026-11-11 | progress-slice-0-ports.md |

## Integrity and scans

```text
                                                            LOCAL                    TRUSTED CI
INTEGRITY  scope: every changed path inside MAY CHANGE      ok (1)                   - (no scope job in slice 0)
           (plans/<KEY>/** exempt)
           protected tests: no existing line changed        ok (2), one flag (3)     -
           skips: tests that did not run                    0                        0
SCANS      dependency, secrets, SAST                        not run (4)              not run (4)
```

1. `git diff --name-only main...9f05a3d`: 90 files, all inside slice-0-ci v4's MAY CHANGE except AGENTS.md, changed
   only in Prashant Sharma's own commit c54c922 (DONE WHEN allows it); nothing on any MUST NOT list.
2. main holds no test file, so no existing test was changed. Within the branch: utils.test.ts reflowed by Prettier
   (2b73ff0, same assertion); budget.spec.ts changed by drill 2 and reverted (no net change since a03108a);
   test_dev.sh:92 and :105 moved to 15432 by the approved recipe commit 366edc2 (the check lists 0 assertion lines,
   because its pattern does not match bash; read by eye at the recipe review).
3. **D6, 8687793:** ModuleBoundaryTests' rule gained `.WithoutRequiringPositiveResults()`, one commit after the test
   was written (356ecb2), because the modules hold no types until part 3 and ArchUnitNET refuses a rule that matches
   none. The test's first assertion (every module loaded) guards against a vacuous pass, and both failure cases were
   seen red (a temporary Tenancy -> Identity type; a dropped Contracts reference). It does loosen what the rule
   checks: approved as an exception by Prashant Sharma, 2026-11-11, expiring in part 3 (see For the approver).
4. Slice 0 has no scan gate: gitleaks, trivy and syft are part 3 (bundle NOT INCLUDED). Done instead: before the
   repository went public, a `git log --all -p` scan found no token, key or password (E11, progress-slice-0-ci.md);
   the pnpm audit findings stay deferred to part 3's trivy (carried assumption).

## AI review
- Not run yet: no AI review has run on pull request #1 (0 reviews, 0 comments; ci.yml is the only workflow).
  aidlc-review, the next stage, runs the reviewer agents. The build sessions' own reviews (reviewing-code at
  aidlc-build step 9) are the author's and are not counted here.

## Unproved
- **Spec criteria:** none is proved by slice 0. AC12, AC26 and AC27 get their harness and gates; their proof is the
  later parts' (route G). Accepted by Prashant Sharma with plan v4 (6936a41).
- **Scans** (dependency, secrets, SAST): not run in CI until part 3. Accepted by Prashant Sharma with bundle
  slice-0-ci v4 (NOT INCLUDED).
- **dev.sh's real run and the image checks:** local only by design; CI runs test_dev.sh, never dev.sh, and builds the
  images without running them. Accepted in bundle slice-0-ci v4's DONE WHEN (step 6), approved by Prashant Sharma.

## For the approver (Prashant Sharma; decisions, not findings)
- **D6 and the Quality bar.** AGENTS.md's floor forbids a weakened assertion unless the exception carries a reason, an
  owner and an expiry date and a person approves it in the pull request. D6 has its reason in a code comment, but no
  owner or expiry. Either approve it in the pull request with an owner and an expiry (for example: part 3, when the
  first module gets a type, removes `.WithoutRequiringPositiveResults()`), or rule that it is not an exception because
  the test was new on this branch and the vacuity guard moved to the first assertion. Either way, record it.
  DECIDED by Prashant Sharma, 2026-11-11: approved as an exception. Reason: increment 1's modules hold no types
  until part 3, and ArchUnitNET refuses a rule that matches none. Owner: Prashant Sharma. Expiry: part 3, when the
  first module gets a type, removes `.WithoutRequiringPositiveResults()`. Recorded at his instruction; the approval
  in the pull request, with points 2 and 3 below, is the comment
  https://github.com/prashantsharma18/jobwright-app/pull/1#issuecomment-6793457315 (2026-11-11), posted by Claude
  under his account at his instruction
- **The scaffold review was delegated.** You asked Claude to review recipe commit 06a65b0 and take decisions R1 to R9
  on your behalf (progress-slice-0-scaffold.md). You have not read that generated diff yourself, so your review of
  this pull request is the human check of it.
- **Size.** 90 files, 13,186 lines added: the scaffold's 8,655 generated lines (06a65b0) and the lock files account
  for most of it; the hand-written change after the scaffold, outside plans/ and the lock files, is 1,068 lines added
  and 337 removed, above the ~1,000-line guide. The plan keeps slice 0 in one pull request (K1).
- **Decisions to read:** skeleton D1 to D9; slice-0-ci E1 to E13 (E13: `agentRules: false`, eb0cece);
  slice-0-ports' decisions (the recipe trailer layout, kept).
