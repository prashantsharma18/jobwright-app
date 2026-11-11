<!-- aidlc template: progress-note -->
# Progress · NEW-jobwright · slice-0-ports

Session state, not memory: it lets a fresh session resume from the record.
File: `plans/NEW-jobwright/part-1/progress-slice-0-ports.md`, committed on its own as the slice's first commit, then
with the slice; the compliance reviewer and the slice runner read it.

```text
STATUS      doing
MODE        hands-on
```

## Restatement (delegate modes)
- Not applicable: hands-on. The restatement was given in the session and confirmed by Prashant Sharma, 2026-11-11.

## Pauses confirmed (by the person)
- (none yet)

## Session plan
- [x] 0 Restate goal, recipe, MAY CHANGE and STOP IF; wait for confirmation — check: confirmed by Prashant Sharma,
      2026-11-11. Preconditions, each seen 2026-11-11:
      AGENTS.md line 46 names 127.0.0.1:15432 and 127.0.0.1:18080 (Prashant Sharma's commit c54c922);
      tree clean apart from `.claude/settings.json`;
      `git grep` finds the old numbers 14 times outside plans/ and AGENTS.md, exactly EVIDENCE's lines (dev.sh 17-20,
      test_dev.sh 92, 105, 110, launchSettings.json 8, Jobwright.Api.http 1, web/package.json 6, 8,
      playwright.config.ts 3, 5, 23), each a whole port number, and 15432, 18080, 15080, 15300 nowhere;
      `netsh.exe interface ipv4 show dynamicport protocol=tcp`: start 49152, 16384 ports;
      `show excludedportrange protocol=tcp`: lowest range 49730-49829, none holds a new port;
      no listener on the four new ports (`ss -ltn` on WSL, `netstat.exe -ano -p tcp` on Windows);
      `scripts/check.sh lint && scripts/check.sh test` exit 0: web 2 passed; .NET 2 passed, 0 skipped;
      `test_dev.sh: 3 passed, 0 failed`; the count command prints 3; /usr/bin/sed is GNU sed 4.9
- [x] 0b Commit this note on its own — files: plans/NEW-jobwright/part-1/progress-slice-0-ports.md — check: clean
      tree after, apart from `.claude/settings.json`
- [ ] 1 Run the RECIPE exactly — files: the six — check: `git diff --stat` 6 files, 14 lines; stage the six by name;
      commit `chore(dev): move the dev ports below Windows' dynamic range (NEW-jobwright slice 0)`, trailer
      `Recipe: sed@4.9`
- [ ] 2 Recipe check — check: `python3 scripts/check_recipe_commit.py <commit> --recipe … --count …` exit 0, count 3
      before and after; record the assertion lines it lists
- [ ] 3 Full local checks — check: `scripts/check.sh lint && scripts/check.sh test` exit 0 (web 2, .NET 2,
      test_dev.sh 3 with the taken-port test named 15432); lint again in a clean worktree (E12); `scripts/check.sh
      browser` 8 passed and `budget` 1 passed in the pinned Playwright image; `git grep -n -E
      "55432|58080|55080|55300" -- . ':!plans'` finds nothing
- [ ] 4 CHECKPOINT: STATUS `paused: recipe review`; Prashant Sharma reviews the recipe commit

## Skills loaded
- aidlc:committing-changes — plugin version 5.0.0

## Deviations
- none

## Amended assertions seen red
- none (the bundle lists no AMENDED ASSERTIONS; test_dev.sh's port assertion changes only under the recipe)

## Decisions made while working (for the PR)
- none

## Assumptions
- The pinned toolchain through `PATH=~/.local/opt/node-v26.13.0/bin:~/.local/opt/dotnet-10.0.403:$PATH` and
  `DOTNET_ROOT=~/.local/opt/dotnet-10.0.403`, as in slice-0-skeleton and slice-0-ci — the session's default PATH has
  no pnpm (the first baseline attempt exited 127 before any check ran)
- Browser and budget run with the local Playwright command recorded in progress-slice-0-ci.md, with Docker up and the
  k3d cluster stopped
- `.claude/settings.json` (sandbox disabled, Prashant Sharma's change) is never staged; every commit stages by name

## Context gaps noticed (B5)
- gap: the bundle does not say that the pinned toolchain's PATH must be set; the session's default PATH has no pnpm
