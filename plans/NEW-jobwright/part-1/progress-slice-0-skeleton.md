<!-- aidlc template: progress-note -->
# Progress · NEW-jobwright · slice-0-skeleton

Session state, not memory: it lets a fresh session resume from the record.
File: `plans/NEW-jobwright/part-1/progress-slice-0-skeleton.md`, committed on its own as the slice's first commit,
then with the slice; the compliance reviewer and the slice runner read it.

```text
STATUS      doing
MODE        hands-on
```

## Restatement (delegate modes)
- Not applicable: hands-on. The restatement was given in the session and confirmed by Prashant Sharma, 2026-11-11,
  with its five flagged points (see Assumptions)

## Pauses confirmed (by the person)
- (none yet)

## Session plan
- [x] 0 Q12 gate: ../stories/NEW-jobwright/new-system.md:137 APPROVED v5 names xunit.v3.mtp-v2 4.0.2; no version after
      v5 — check: read 2026-11-11. Restatement confirmed by Prashant Sharma, 2026-11-11. This note committed on its own
- [ ] 1 Root .gitignore; global.json gains the SDK pin (10.0.403, rollForward disable) beside the generated test runner
      — files: .gitignore, global.json — check: `dotnet --version` from the repository root reads 10.0.403;
      `git status` no longer lists bin/ or obj/
- [ ] 2 .NET pins — files: api/Directory.Packages.props, api/Directory.Build.props, api/**/*.csproj, api/Jobwright.slnx,
      api/**/packages.lock.json — check: `dotnet restore api/Jobwright.slnx` exit 0, no NU190x; lock files read against
      Pinned versions and the v5 review lists. CHECKPOINT (person reads the lock files)
- [ ] 3 Web pins — files: web/package.json, web/pnpm-lock.yaml, web/pnpm-workspace.yaml — check: `pnpm -C web install`
      exit 0 under strict builds; importer `.` read against Pinned versions. CHECKPOINT (person reads pnpm-lock and
      approves any build script)
- [ ] 3b Ports — files: web/package.json, api/src/Jobwright.Api/Properties/launchSettings.json,
      api/src/Jobwright.Api/Jobwright.Api.http — check: `git grep -n -E 'localhost:(5066|7131)|"next (dev|start)"' -- web api`
      finds nothing
- [ ] 4 K2 test first — files: api/tests/Jobwright.Api.Tests/HealthLiveTests.cs, then api/src/Jobwright.Api/Program.cs
      — check: red for the expected reason, then green
- [ ] 5 web tests first — files: web/vitest.config.ts, web/src/lib/utils.test.ts, then web/src/app/page.tsx, layout.tsx,
      web/public/*.svg (deleted) — check: each cn test seen red by breaking cn on purpose, then green
- [ ] 6 U13 test first — files: api/tests/Jobwright.ArchitectureTests/ModuleBoundaryTests.cs — check: red with a
      temporary Tenancy -> Identity reference carrying ArchUnitNET's own violation message (never committed), then green
- [ ] 7 Placeholders removed — files: api/**/Class1.cs, api/tests/**/UnitTest1.cs (deleted) — check: build green
- [ ] 8 scripts/check.sh and the web scripts — files: scripts/check.sh, web/package.json, web/.prettierrc.json,
      web/.prettierignore — check: lint seen red once (react-hooks and jsx-a11y, temporary file, never committed);
      `scripts/check.sh lint && scripts/check.sh test` green with web 2 and .NET 2; `scripts/check.sh build` green
- [ ] 9 Boundary and diff review (aidlc-build step 9), report, index row

## Skills loaded
- aidlc:writing-tests — plugin version 5.0.0
- aidlc:checking-official-docs — plugin version 5.0.0
- aidlc:securing-code — plugin version 5.0.0
- aidlc:committing-changes — plugin version 5.0.0

## Deviations
- (none yet)

## Amended assertions seen red
- none (the bundle lists none)

## Decisions made while working (for the PR)
- (none yet)

## Assumptions
- The pinned toolchain is used through `PATH=~/.local/opt/node-v26.13.0/bin:~/.local/opt/dotnet-10.0.403:$PATH` and
  `DOTNET_ROOT=~/.local/opt/dotnet-10.0.403` on every command, as in slice-0-scaffold — confirmed by Prashant Sharma,
  2026-11-11 (restatement)
- COMMANDS writes `dotnet test api/Jobwright.slnx`; on SDK 10 with global.json's Testing Platform runner the solution
  may need `--solution`. Checked against the official docs at step 8; a disagreement with COMMANDS is a stop for the
  design approver — flagged at the restatement
- DONE WHEN's `git grep -n -i -E "weatherforecast|Class1|UnitTest1"` always matches the plan documents; it is run with
  `-- ':!plans'`, as `plans/**` is exempt — confirmed by Prashant Sharma, 2026-11-11 (restatement)
- web/src/app/layout.tsx's "Create Next App" metadata is a generator placeholder; step 5 sets the title to "Jobwright"
  (plan FILES lists layout.tsx) — confirmed by Prashant Sharma, 2026-11-11 (restatement)
- The untracked sandbox dotfiles at the repository root (.bashrc, .bash_profile, .claude/agents and others) are never
  staged; every commit stages by name

## Context gaps noticed (B5)
- (none yet)
