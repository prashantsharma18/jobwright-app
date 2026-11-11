<!-- aidlc template: progress-note -->
# Progress · NEW-jobwright · slice-0-skeleton

Session state, not memory: it lets a fresh session resume from the record.
File: `plans/NEW-jobwright/part-1/progress-slice-0-skeleton.md`, committed on its own as the slice's first commit,
then with the slice; the compliance reviewer and the slice runner read it.

```text
STATUS      paused: checkpoint 2
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
- [x] 1 Root .gitignore; global.json gains the SDK pin (10.0.403, rollForward disable) beside the generated test runner
      — files: .gitignore, global.json — check: pinned SDK reads 10.0.403; /usr/bin/dotnet (10.0.114) now refuses to
      load; `git status` no longer lists bin/ or obj/ (b0ec074)
- [x] 2 .NET pins — files: api/Directory.Packages.props, api/Directory.Build.props, api/**/*.csproj, api/Jobwright.slnx,
      api/**/packages.lock.json — check: `dotnet restore api/Jobwright.slnx -m:1` exit 0, no warning, no NU190x;
      `--locked-mode` restore exit 0; `dotnet build api/Jobwright.slnx -m:1` "Build succeeded" under
      TreatWarningsAsErrors (5c3af0d). CHECKPOINT: see "Checkpoint 2: lock files" below
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

## Checkpoint 2: lock files (for Prashant Sharma)
Read from the ten api/**/packages.lock.json (net10.0 and net10.0/linux-x64), commit 5c3af0d.
- Direct, each at its pin: Microsoft.AspNetCore.OpenApi 10.0.14 (Api) · Microsoft.Extensions.Hosting 10.0.14 (Worker)
  · Microsoft.AspNetCore.Mvc.Testing 10.0.14 (Api.Tests) · xunit.v3.mtp-v2 4.0.2 (both test projects) ·
  TngTech.ArchUnitNET.xUnitV3 0.13.5 (ArchitectureTests). No xunit.v3, xunit.runner.visualstudio,
  Microsoft.NET.Test.Sdk or coverlet anywhere. The six class libraries and Admin have no package
- Q1 keeps, for the pull request: Microsoft.Extensions.Hosting 10.0.14; xunit.v3.mtp-v2 4.0.2
- Q11, as expected: xunit.v3.core.mtp-v2 4.0.2 and xunit.v3.assert 4.0.2 exactly; xunit.v3.common,
  extensibility.core, runner.common, runner.inproc.console 4.0.2; xunit.analyzers 2.2.0; Microsoft.Testing.Platform,
  .MSBuild, .Extensions.TrxReport.Abstractions, .Extensions.Telemetry 2.5.1; Microsoft.ApplicationInsights 2.23.0;
  Microsoft.Bcl.AsyncInterfaces 6.0.0; linux-x64 only: Microsoft.Win32.Registry 5.0.0, System.Security.AccessControl
  6.0.1, System.Diagnostics.EventLog 10.0.14. Pruned on net10.0 (W6): System.Diagnostics.DiagnosticSource,
  System.Security.Principal.Windows
- Microsoft's own, from approved packages: Microsoft.AspNetCore.TestHost and Microsoft.Extensions.DependencyModel
  10.0.14 (Mvc.Testing); Microsoft.OpenApi 2.12.2 (AspNetCore.OpenApi); Microsoft.Extensions.* 10.0.14 (Hosting)
- **NOT NAMED ANYWHERE (decision needed).** TngTech.ArchUnitNET 0.13.5 (the library behind the approved xUnitV3
  package) depends on five third-party packages, one version each in its nuspec (.NETStandard2.0 group):
  CycleDetection 2.0.0 · JetBrains.Annotations 2026.2.0 · Mono.Cecil 0.11.6 · Newtonsoft.Json 13.0.4 ·
  System.ValueTuple 4.6.2. Only ArchitectureTests has them (test-only; no image ships them). The bundle's EVIDENCE and
  new-system.md's v5 review list give ArchUnitNET's graph as System.Net.Http 4.3.4 and System.Text.RegularExpressions
  4.3.1; neither is in the net10.0 graph (pruned), and the five above were missed (they read the xUnitV3 nuspec, not
  the core library's). Options: (a) accept them as ArchUnitNET's graph and have the design approver record them in
  new-system.md (v6, review list); (b) the Q8 fallback (a reflection test over project references, no library),
  which removes all six packages; Q8 pre-approved it only for "ArchUnitNET does not load or run", so choosing it here
  is a new decision

- aidlc:writing-tests — plugin version 5.0.0
- aidlc:checking-official-docs — plugin version 5.0.0
- aidlc:securing-code — plugin version 5.0.0
- aidlc:committing-changes — plugin version 5.0.0

## Deviations
- Sandbox, environment only, nothing in the repository: every local `dotnet` build or restore runs with `-m:1`. With
  MSBuild's default parallel nodes, the restore of ArchitectureTests (and so the solution) fails with "Build FAILED,
  0 Error(s)" in `_GenerateRestoreProjectPathWalk` of Jobwright.Api; `-m:1` passes, `-nr:false` or
  MSBUILDDISABLENODEREUSE=1 alone do not. Running outside the sandbox to confirm the cause was refused by the
  permission classifier, so the exact cause (worker nodes not starting or not connecting in the sandbox) is UNKNOWN;
  CI will show whether the default works there
- Sandbox, environment only: `EnableSourceControlManagerQueries=false` in the environment of local builds. The
  sandbox mounts a character device (/dev/null) at ./.gitmodules, and the SDK's Microsoft.Build.Tasks.Git fails
  reading it ("Access to the path '.../.gitmodules' is denied") in every project. A real checkout has no .gitmodules
- aidlc:debugging-failures loaded for the restore failure (aidlc-build names it for step 8's failures; used at step 2)

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
- wrong: bundle EVIDENCE and new-system.md v5 review list: TngTech.ArchUnitNET's transitive packages are CycleDetection,
  JetBrains.Annotations, Mono.Cecil, Newtonsoft.Json and System.ValueTuple, not System.Net.Http and
  System.Text.RegularExpressions (Checkpoint 2)
- gap: neither the plan nor the bundle says the agent's sandbox breaks MSBuild's parallel nodes and Source Link's git
  read (Deviations)
- gap: learn.microsoft.com (aspnet/core/test/integration-tests, aspnetcore-10.0) says the test project should use
  `Microsoft.NET.Sdk.Web`; the generated Api.Tests uses `Microsoft.NET.Sdk` and the bundle names no Sdk change. Step 4
  shows whether the in-process host runs under it; the result goes to Decisions. FACT for step 4: .NET 10 generates
  `public partial class Program` (aspnetcore-10.0 release notes, "Better support for testing apps with top-level
  statements"), so Program.cs needs no declaration
