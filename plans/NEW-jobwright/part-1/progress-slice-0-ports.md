<!-- aidlc template: progress-note -->
# Progress · NEW-jobwright · slice-0-ports

Session state, not memory: it lets a fresh session resume from the record.
File: `plans/NEW-jobwright/part-1/progress-slice-0-ports.md`, committed on its own as the slice's first commit, then
with the slice; the compliance reviewer and the slice runner read it.

```text
STATUS      paused: recipe review
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
- [x] 1 Run the RECIPE exactly — files: the six — check: sed exit 0; `git diff --stat` 6 files, 14 insertions(+),
      14 deletions(-); each changed line differs only in a port number; staged the six by name; recipe commit 366edc2
      `chore(dev): move the dev ports below Windows' dynamic range (NEW-jobwright slice 0)`, `Recipe: sed@4.9` in the
      message (see Decisions: not in git's trailer block)
- [x] 2 Recipe check — check: `python3 scripts/check_recipe_commit.py 366edc2 --recipe "<RECIPE>" --count "<count
      command>"` exit 0:
          check_recipe_commit: 366edc2 reproduces, the test count is unchanged, 0 assertion line(s) to confirm
      It lists no assertion line: its pattern (`Assert.`, `assert`, `expect(`, `.Should(`, `Should.`) does not match
      bash, so test_dev.sh:105 (`grep -q 55432` -> `grep -q 15432`) and :92 (the bound port) are for the reviewer's eye
      (see Context gaps). Count 3 before (step 0) and after (step 3)
- [x] 3 Full local checks — check: `scripts/check.sh lint && scripts/check.sh test` exit 0: web 2 passed; .NET 2
      passed, 0 failed, 0 skipped; `test_dev.sh: 3 passed, 0 failed` with `ok   fails naming the port when 15432 is
      taken`; on a clean `git worktree` at 366edc2 (`pnpm -C web install --frozen-lockfile --offline`, then
      `scripts/check.sh lint`) exit 0 (E12), worktree removed; `scripts/check.sh browser` 8 passed and `budget`
      1 passed, exit 0, in mcr.microsoft.com/playwright:v1.65.0-noble@sha256:6e3fb709...273d (ci.yml's pin; k3d
      not running, no jobwright-dev-* container); `git grep -n -E "55432|58080|55080|55300" -- . ':!plans'` finds
      nothing
- [x] 3b Boundary and self-review (aidlc-build step 9) — check: `git diff --name-only 998d145..HEAD` lists the six
      MAY CHANGE files and this note only; nothing on MUST NOT; `.claude/settings.json` never staged. Mutation
      (reviewing-code step 3): dev.sh `postgres_port` back to 55432 in place -> `test_dev.sh: 2 passed, 1 failed`
      (the taken-port test), file restored from a copy, 3 passed again
- [ ] 4 CHECKPOINT: STATUS `paused: recipe review`; Prashant Sharma reviews recipe commit 366edc2 (14 lines, each
      only a port number); then slice-0-ci resumes at its step 6

## Skills loaded
- aidlc:committing-changes — plugin version 5.0.0
- aidlc:reviewing-code — plugin version 5.0.0 (aidlc-build step 9 loads it; not a deviation)

## Deviations
- none

## Amended assertions seen red
- none (the bundle lists no AMENDED ASSERTIONS; test_dev.sh's port assertion changes only under the recipe)

## Decisions made while working (for the PR)
- `Recipe: sed@4.9` sits in the message's last body paragraph, followed by a blank line and the Co-Authored-By and
  hook trailers, so `git log --format=%(trailers)` does not show it (scaffold commit 06a65b0 has its Recipe lines in
  the trailer block). check_recipe_commit.py accepts it (it searches the whole message). Not amended: amending is a
  history rewrite, a person's decision — confirm with Prashant Sharma at the recipe review (keep, or he amends)
- Not covered by a local test: dev.sh's api_port and web_port against launchSettings.json and web/package.json; only
  `git grep` (X7) checks them until slice-0-ci step 6 runs dev.sh for real — for the reviewer

## Assumptions
- The pinned toolchain through `PATH=~/.local/opt/node-v26.13.0/bin:~/.local/opt/dotnet-10.0.403:$PATH` and
  `DOTNET_ROOT=~/.local/opt/dotnet-10.0.403`, as in slice-0-skeleton and slice-0-ci — the session's default PATH has
  no pnpm (the first baseline attempt exited 127 before any check ran)
- Browser and budget run with the local Playwright command recorded in progress-slice-0-ci.md, with Docker up and the
  k3d cluster stopped
- `.claude/settings.json` (sandbox disabled, Prashant Sharma's change) is never staged; every commit stages by name

## Context gaps noticed (B5)
- wrong: the bundle's RECIPE says check_recipe_commit.py lists test_dev.sh's changed assertion line; its assertion
  pattern does not match bash, so it reports 0 assertion lines and the reviewer reads :92 and :105 by eye
- gap: the bundle does not say that the pinned toolchain's PATH must be set; the session's default PATH has no pnpm
