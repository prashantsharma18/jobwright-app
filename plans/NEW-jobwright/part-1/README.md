<!-- aidlc template: story-index -->
# NEW-jobwright · Jobwright: the new system and its foundations · part 1: slice 0

```text
SOURCE     ../stories/NEW-jobwright/README.md (provisional key until the tracker is chosen, requirements Q1)
KIND       new system
ROUTE      G
LEVEL      part 1 of 4 in jobwright-app
PINS       (aidlc-plan copies it from slice 0's bundle)
```

Each stage marks its own row when it ends: done, or `stopped: <reason>`. The build row reads doing while slices remain.
Once the code owner approves, the person marks the merged row done in the pull request's final commit, so it reaches
the default branch only through the merge. A re-plan or a revision resets the later rows to "to do".

| Stage | Runs in | Status |
|---|---|---|
| aidlc-onboard (prepare) | jobwright-app | done (2026-11-09, branch feat/NEW-jobwright-onboard-prepare) |
| slice 0 | jobwright-app | to do |
| aidlc-onboard (confirm) | jobwright-app | to do |
