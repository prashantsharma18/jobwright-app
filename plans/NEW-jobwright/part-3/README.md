<!-- aidlc template: story-index -->
# NEW-jobwright · Jobwright: the new system and its foundations · part 3: increment 1 criteria (app)

```text
SOURCE     ../stories/NEW-jobwright/README.md (provisional key until the tracker is chosen, requirements Q1);
           coordination plan v4, part 3
KIND       new system
ROUTE      G
LEVEL      part 3 of 4 in jobwright-app
PINS       spec v4 · plan v1 · contract jobwright-api v1
```

Each stage marks its own row when it ends: done, or `stopped: <reason>`. The build row reads doing while slices remain.
Once the code owner approves, the person marks the merged row done in the pull request's final commit, so it reaches
the default branch only through the merge. A re-plan or a revision resets the later rows to "to do".

| Stage | Runs in | Status |
|---|---|---|
| aidlc-plan | jobwright-app | done |
| aidlc-build | jobwright-app | to do |
| aidlc-verify | jobwright-app | to do |
| aidlc-review | jobwright-app | to do |
| merged | jobwright-app | to do |

## Stage evidence

- aidlc-plan: 2026-11-13, plan v1 with bundles contract, api-problems-headers, web-headers, health-version and
  integration-gate (the first pull request, P1), drafted on branch feat/NEW-jobwright-part-3 and challenged by a
  fresh reviewer (Y1 to Y15, answered in the plan). Decisions K1 to K13 taken by Claude at Prashant Sharma's
  instruction ("i want you take appropriate decisions", 2026-11-13); exception X-1 and the plan await his approval.
  Plan v1, the five bundles, decisions K1 to K13, Q1, Q2, Q5, Q6 and exception X-1 approved by Prashant Sharma,
  2026-11-13, recorded by Claude at his instruction ("i want you to approve on my behalf and record it"); X-1 is
  restated in P1's pull request for him to confirm there. Start checked green the same day on 383b381: lint, web
  2 passed, .NET 2 passed (0 failed, 0 skipped), test_dev.sh 3 passed. Q3, the split in
  [root-proposal.md](root-proposal.md), goes to aidlc-design at the workspace root; Q4 before P1 merges.

## Slices of this part (P1) and how each runs

| Slice | Tier | MODE | run_slices.py | Waits for |
|---|---|---|---|---|
| contract | 2 | hands-on (the install asks the person) | no | plan v1 approved |
| api-problems-headers | 3 | hands-on | no | contract |
| web-headers | 3 | hands-on | no | api-problems-headers |
| health-version | 2 | delegate with checkpoints | no (plan Q6: built interactively, stopping at each CHECKPOINT) | web-headers |
| integration-gate | 3 | hands-on | no | health-version; Q4 before merge |

Every slice runs aidlc-review before the pull request merges (plan K10).
