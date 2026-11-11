<!-- aidlc template: pr-description -->
# [NEW-jobwright] part 1 of 4: slice 0 (skeleton, commands, CI)

## For the reviewer
- **Asked of:** A code owner who neither wrote nor pushed the change, to approve the merge; a required specialist can
  block. Here both are Prashant Sharma, who also directed the agent and pushes: known limits KL2 and intent I3 (spec
  v3), recorded in `stories/NEW-jobwright/coordination-plan.md` (workspace root) APPROVALS
- **Record it:** In the pull request
- **Tier and main risk:** 3: a generator or template adds a package, file or setting the approved design does not name,
  and it reaches `main` unreviewed; second, CI permissions or an unpinned action (plan v4)
- **Changed since the last version:** replaces [pr-body.md](pr-body.md) (aidlc-verify's draft): D6 now decided, the
  review's findings and their proposed dispositions linked ([review-record.md](review-record.md)), the security review
  added ([security-review.md](security-review.md))

## Summary
Slice 0 of route G for jobwright-app: the skeleton of the web app, the API and the worker, the repository's commands
(`scripts/check.sh`, `scripts/dev.sh`) and the six CI gates every pull request reports. It proves no spec criterion on
its own; it lays the harness that AC12, AC26 and AC27 are proved with in part 3.

## What changed
Read the tests first: [evidence.md, Tests](evidence.md#tests).
- `.github/workflows/ci.yml`, six gates (setup, lint, test, build, browser, budget), each seen green, red for its own
  reason and green again: AC27 (part)
- `web/tests/e2e/accessibility.spec.ts`, the axe scan at 360 and 1440 px, light and dark: AC12 (harness; dark is not
  yet exercised, review-record M1)
- `web/tests/e2e/budget.spec.ts`, the first-load script budget, 163,840 B: AC26 (harness, E5)
- `api/src/Jobwright.Api/Program.cs` `/health/live` and `HealthLiveTests.cs`: K2
- `api/tests/Jobwright.ArchitectureTests/ModuleBoundaryTests.cs`, ADR 0001's module rule with ArchUnitNET: U13
- `scripts/check.sh` (test, lint, build, browser, budget), `scripts/dev.sh` and `scripts/tests/test_dev.sh`: AGENTS.md
  Commands; requirements 9.5 (127.0.0.1, the reserved ports, the k3d refusal)
- `Dockerfile.web`, `Dockerfile.api`, `Dockerfile.worker`: the three images, built and never pushed (ADR 0012 later)
- The scaffold, recipe commit 06a65b0 (generator output only), and the dev-port move, recipe commit 366edc2: plan K4 v4
- `AGENTS.md` line 46, the run command's ports, in Prashant Sharma's own commit c54c922 (new-system.md v6)

## Not changed
- No publishing, no `packages: write`, no `STAGING_TOKEN` (part 3, ADR 0012); no contract, integration or scan gates
  (part 3); no Helm chart; no security headers yet (AC14, AC15, part 3)
- AGENTS.md's "not yet run" lines: aidlc-onboard (confirm) writes them after the merge
- The sandbox setting in `.claude/settings.json` (uncommitted on this machine, not in the pull request)

## Questions for the reviewers
- **Code owner (Prashant Sharma):** the scaffold's DONE WHEN reads "the person has reviewed it" and that review was
  delegated (review-record H1). Have you now read 06a65b0 as generated code yourself, starting from R1 to R9 in
  [progress-slice-0-scaffold.md](progress-slice-0-scaffold.md), and will you record that in this pull request in your
  own words?
- **Security specialist (Prashant Sharma, I3):** the repository is public and `main` has no branch protection
  (`gh api .../branches/main/protection`: "Branch not protected"), although Free offers it on public repositories. Do
  you send KL1 and KL4 to aidlc-design at the workspace root before part 3 adds `STAGING_TOKEN`
  ([security-review.md](security-review.md), S2)?
- **Release specialist (Prashant Sharma, I3):** nothing is deployed; is "revert the merge commit" the whole rollback
  for you, given that the ports cannot move back (plan ROLLBACK v4)?

## Decisions made while building
Each is recorded with who took it in its progress note; the delegated ones need your confirmation (review-record M5).
- Scaffold R1 to R9: taken by Claude at your instruction; confirm with Prashant Sharma
- Skeleton D1 to D9 (D1 kept ArchUnitNET's five transitive packages; D7 met a STOP IF and continued): confirm with
  Prashant Sharma
- Slice-0-ci E1 to E13 (E1 the dev ports, E8 the ci.yml choices, E13 `agentRules: false`): confirm with Prashant Sharma
- D6, `.WithoutRequiringPositiveResults()`: approved as a Quality bar exception by Prashant Sharma, 2026-11-11
  ([comment](https://github.com/prashantsharma18/jobwright-app/pull/1#issuecomment-6793457315)); its expiry and guard
  are reopened by review-record H2
- Scans deferred to part 3: accepted by Prashant Sharma, 2026-11-11 (same comment)

## Traceability
- **Work item:** NEW-jobwright, Jobwright: the new system and its foundations (provisional key, requirements Q1) · Tier 3
- **Spec:** v3 (`stories/NEW-jobwright/spec.md`, workspace root), clarifications K1 to K4 in plan.md
- **Plan:** [plan.md](plan.md) v4 (6936a41), approved by Prashant Sharma on 2026-11-11
- **Bundle or brief:** [bundle-slice-0-scaffold.md](bundle-slice-0-scaffold.md) (plan v1),
  [bundle-slice-0-skeleton.md](bundle-slice-0-skeleton.md) v3 (02a2cfb), [bundle-slice-0-ci.md](bundle-slice-0-ci.md) v4
  and [bundle-slice-0-ports.md](bundle-slice-0-ports.md) v1 (6936a41)
- **Recipe:** 06a65b0, `create-next-app@16.4.5`, `shadcn@4.23.0`, `dotnet-sdk@10.0.403` (no recipe check: it predates
  the script; review delegated, H1); 366edc2, `sed@4.9`, `check_recipe_commit.py` exit 0, "reproduces, the test count
  is unchanged"
- **Evidence:** [evidence.md](evidence.md), from trusted run
  [42999475010](https://github.com/prashantsharma18/jobwright-app/actions/runs/42999475010) on 9f05a3d: six gates green,
  16 test executions, 0 skipped. The pull request's head 7c02f5d is green too (run
  [43002408410](https://github.com/prashantsharma18/jobwright-app/actions/runs/43002408410)); later commits change
  `plans/` only, and the final head must be green before the merge. Proved only locally: dev.sh's real run and the
  images running
- **Assumptions:** no CI AI review exists yet (ci.yml is the only workflow), so the local reviewer passes in
  review-record.md are the only AI review, and they are advisory

## Rollback
Nothing is deployed or published. Before the merge: drop the branch, or revert a slice's commits. After the merge:
revert the merge commit on `main`. The old dev ports cannot be used again on this machine (plan ROLLBACK v4).

🤖 Generated with [Claude Code](https://claude.com/claude-code)
