<!-- aidlc template: story-index -->
# NEW-jobwright · Jobwright: the new system and its foundations · part 1: slice 0

```text
SOURCE     ../stories/NEW-jobwright/README.md (provisional key until the tracker is chosen, requirements Q1)
KIND       new system
ROUTE      G
LEVEL      part 1 of 4 in jobwright-app
PINS       spec v3 · plan v2 · contract none
```

Each stage marks its own row when it ends: done, or `stopped: <reason>`. The build row reads doing while slices remain.
Once the code owner approves, the person marks the merged row done in the pull request's final commit, so it reaches
the default branch only through the merge. A re-plan or a revision resets the later rows to "to do".

| Stage | Runs in | Status |
|---|---|---|
| aidlc-onboard (prepare) | jobwright-app | done (2026-11-09, branch feat/NEW-jobwright-onboard-prepare) |
| slice 0 | jobwright-app | doing: aidlc-plan drafted plan v1 and bundles slice-0-scaffold, slice-0-skeleton, slice-0-ci (2026-11-10), plan v1 approved by Prashant Sharma 2026-11-10 (recorded at his instruction); toolchain installed (Q3); aidlc-build slice-0-scaffold done (2026-11-10): recipe commit 06a65b0, root global.json and dotnet-tools.json under option A, recipe review delegated to Claude by Prashant Sharma (decisions R1 to R9 in progress-slice-0-scaffold.md); aidlc-plan drafted plan v2 (2026-11-10): Q1 and the bundles slice-0-skeleton and slice-0-ci revised for R1 to R9 and option A, new Q10 blocks slice-0-skeleton until new-system.md v4 is approved; next: Prashant Sharma approves plan v2 and the two bundles, the workspace root drafts new-system.md v4 (Q10) and he approves it, then aidlc-build slice-0-skeleton |
| aidlc-onboard (confirm) | jobwright-app | to do |
