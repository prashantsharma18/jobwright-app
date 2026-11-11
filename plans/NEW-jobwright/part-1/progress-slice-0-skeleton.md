<!-- aidlc template: progress-note -->
# Progress · NEW-jobwright · slice-0-skeleton

Session state, not memory: it lets a fresh session resume from the record.
File: `plans/NEW-jobwright/part-1/progress-slice-0-skeleton.md`, committed on its own as the slice's first commit,
then with the slice; the compliance reviewer and the slice runner read it.

```text
STATUS      done (2026-11-11), on equivalent local evidence (D8): `scripts/check.sh` itself has not run end to end
            in an agent session; Prashant Sharma runs it once before pushing
MODE        hands-on
```

## Restatement (delegate modes)
- Not applicable: hands-on. The restatement was given in the session and confirmed by Prashant Sharma, 2026-11-11,
  with its five flagged points (see Assumptions)

## Pauses confirmed (by the person)
- checkpoint 3 confirmed by Prashant Sharma, 2026-11-11 — delegated, as checkpoint 2: Claude took D3 to D5 below
- checkpoint 2 confirmed by Prashant Sharma, 2026-11-11 — delegated: at his instruction ("take appropriate decision
  for me") Claude took decision D1 below; his review of the pull request before merge remains the human check

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
- [x] 3 Web pins — files: web/package.json, web/pnpm-lock.yaml — check: `pnpm install` exit 0 under strict builds
      ("Lockfile passes supply-chain policies"); importer `.` read: every entry at its pin, shadcn 4.23.0 under
      devDependencies; no react 19.3.0, react-dom 19.3.0, eslint 9 or @types/node 20 left in the lock; `pnpm build`
      exit 0 with Google Fonts reachable (D5) (d5a510d). CHECKPOINT: decisions D3 to D5
- [x] 3b Ports — files: web/package.json, launchSettings.json, Jobwright.Api.http (CRLF kept) — check: the bundle's
      `git grep` finds nothing (ac3037e)
- [x] 4 K2 — HealthLiveTests red first: "Assert.Equal() Failure: Expected: OK, Actual: NotFound"; then
      AddHealthChecks + MapHealthChecks("/health/live", Predicate = _ => false), the documented liveness pattern; green
      (cab909f). The in-process host runs under the generated Microsoft.NET.Sdk (the docs' Web SDK not needed)
- [x] 5 web — both cn tests red against a naive join put in utils.ts on purpose (received "px-2 py-1 px-4" and
      "flex false    items-center"), utils.ts restored with no diff; green (dbf9a7e). Minimal page, title "Jobwright",
      public/*.svg deleted (20c6a2b; see Deviations, slip 1). vitest.config.mts, not .ts (Deviations)
- [x] 6 U13 — ModuleBoundaryTests green, then red with a temporary Tenancy -> Identity reference and type (never
      committed), carrying ArchUnitNET's own message: "ArchUnitNET.xUnitV3.FailedArchRuleException : ... failed:
      Jobwright.Modules.Tenancy.TemporaryViolation does depend on "Jobwright.Modules.Identity.Class1"" (no binding
      exception, W4); lock files restored, locked restore passes (356ecb2). U13 ANSWERED: ArchUnitNET 0.13.5 runs on
      xunit.v3 4.0.2 under Microsoft Testing Platform v2; the Q8 fallback is not needed
- [x] 7 Placeholders removed (5 Class1.cs, 2 UnitTest1.cs; they landed in 8687793, see slip 2). With empty modules
      ArchUnitNET refused the rule ("The rule requires positive evaluation, not just absence of violations") -> D6.
      Re-proved red with empty modules: "TemporaryViolation does depend on Jobwright.Modules.Identity.TemporaryIdentity";
      and the C11 guard red without the Tenancy.Contracts reference: "Not found: Jobwright.Modules.Tenancy.Contracts"
- [x] 8 scripts/check.sh and the web scripts (25b34e1); formatting pass D7 (2b73ff0). Lint seen red once with a
      temporary file (never committed), `scripts/check.sh lint` exit 1: "8:5 error React Hook "useState" is called
      conditionally ... react-hooks/rules-of-hooks" and "10:10 warning img elements must have an alt prop ...
      jsx-a11y/alt-text" (D4 resolved: both plugins run under ESLint 10.14.0). Verified here: pnpm -C web lint,
      format:check, typecheck, test exit 0 (web: 1 file, 2 passed); `dotnet build api/Jobwright.slnx -c Release -m:1`
      0 warnings, 0 errors; both .NET test apps run directly: Api.Tests Total 1, ArchitectureTests Total 1, Failed 0,
      Skipped 0 (counts: web 2, .NET 2, as DONE WHEN expects). `dotnet test api/Jobwright.slnx` parses the positional
      solution like `--solution`. NOT RUN HERE: `scripts/check.sh test` and `lint` (dotnet test and dotnet format die on
      "SocketException (13): Permission denied") and `scripts/check.sh build` (next build needs fonts.googleapis.com,
      D5; dotnet build needs parallel nodes). Open: the full run
      Second session, 2026-11-11: AF_UNIX still refused ("Operation not permitted"); `scripts/check.sh lint` red in
      the sandbox only at `dotnet format` ("Restore operation failed"), web lint, format:check and typecheck green;
      the unsandboxed run was refused again by the auto-mode classifier. Re-verified in the sandbox, no code changed:
      web test 1 file, 2 passed; `dotnet build -m:1` 0 warnings, 0 errors; Api.Tests and ArchitectureTests each
      Total 1, Failed 0, Skipped 0; `pnpm -C web build` exit 0 (fonts hosts allowed, D5); Release build 0 warnings,
      0 errors. Step 9's checks repeated, all clean. `dotnet format --no-restore` fails the same way (Roslyn's
      BuildHost pipe, BuildHostProcessManager.GetBuildHostAsync); `dotnet format whitespace api --folder
      --verify-no-changes` exit 0. Closed under D8
- [x] 9 Boundary check done early: `git diff --name-only b94004d HEAD` has nothing outside MAY CHANGE and nothing in
      MUST NOT; DONE WHEN greps (placeholders with ':!plans', net8.0/TestingPlatformDotnetTestSupport, ports, 3000) find
      nothing; test projects reference only xunit.v3.mtp-v2 of xunit's packages; no suppression or skip; check.sh exports
      the three opt-outs. Self-review done (below). Repeated in the second session (step 8), all clean
- [x] 10 Report given in the session; index row marked; this note and the index committed together

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

## Self-review (step 9, reviewing-code)
- low, correctness: mutation `Predicate = _ => true` stays green (Total 1, Failed 0): no health check is registered
  yet, so "no dependency checks" has no test. Dismissed for this slice: K2's criterion is the 200; the first check
  arrives with part 3's /health/ready, whose slice should add `HealthLive_runs_no_dependency_check` (a failing check
  registered, /health/live still 200)
- low, security: `pnpm audit` on the committed lock: minimatch >=7 <11.0.1 (moderate, GHSA-g3hv-75wg-m249, via ESLint
  and @typescript-eslint, lint only; fixed in 11.0.1 but only through an override, a dependency change for the owner)
  and deepmerge <=4.3.1 (low, GHSA-gcqx-w48m-w2h4, via the shadcn CLI, no fix). Development tooling only, nothing the
  image ships, no untrusted input reaches them. Deferred, review at slice-0-ci (its trivy fs gate); owner Prashant Sharma
- question, architecture: the template's `app.UseHttpsRedirection()` stays in Program.cs; the API is internal-only
  (ADR 0001) and probes hit /health/live over http. If ASPNETCORE_HTTPS_PORT is ever set, probes get 307. For
  slice-0-ci or part 3 (Dockerfile.api, the chart); not changed here (no DO step names it)
- low, correctness: ModuleBoundaryTests indexes `forbidden[0]`; with no forbidden assembly it would throw. The hosts and
  the other module are always forbidden, so it cannot be empty today; left as is
- Reviewed and fine: no secret, no personal data, no new log line; telemetry opt-outs; ports 127.0.0.1 only; the
  restore's NuGet audit reported nothing; csproj and props changes are versions and references only

## Skills loaded
- aidlc:reviewing-code — plugin version 5.0.0
- aidlc:debugging-failures — plugin version 5.0.0
- aidlc:writing-tests — plugin version 5.0.0
- aidlc:checking-official-docs — plugin version 5.0.0
- aidlc:securing-code — plugin version 5.0.0
- aidlc:committing-changes — plugin version 5.0.0

## Deviations
- Sandbox, environment only, nothing in the repository: every local `dotnet` build or restore runs with `-m:1`. With
  MSBuild's default parallel nodes, the restore of ArchitectureTests (and so the solution) fails with "Build FAILED,
  0 Error(s)" in `_GenerateRestoreProjectPathWalk` of Jobwright.Api; `-m:1` passes, `-nr:false` or
  MSBUILDDISABLENODEREUSE=1 alone do not. Running outside the sandbox was refused by the permission classifier.
  Cause, FACT (MSBUILDDEBUGCOMM=1 trace, 90 of 90 node starts): each worker node fails creating its named pipe,
  `System.Net.Sockets.SocketException (13): Permission denied at Socket..ctor` from `NamedPipeServerStream` in
  `NodeEndpointOutOfProcBase.InternalConstruct`; on Linux the pipe is a Unix domain socket at /tmp/MSBuild<PID>, and
  the sandbox refuses the socket() call itself. Prashant Sharma, 2026-11-11: in favour of letting MSBuild's nodes
  through the sandbox (he sets it; agents never edit .claude/**); until then `-m:1` stays
- Sandbox, environment only: `EnableSourceControlManagerQueries=false` in the environment of local builds. The
  sandbox mounts a character device (/dev/null) at ./.gitmodules, and the SDK's Microsoft.Build.Tasks.Git fails
  reading it ("Access to the path '.../.gitmodules' is denied") in every project. A real checkout has no .gitmodules
- Slip 1: `git rm` staged the five public/*.svg deletions, and the next commit (dbf9a7e, the cn tests) took them, not
  the page commit (20c6a2b). Slip 2, same cause: step 7's seven placeholder deletions landed in the D6 commit 8687793,
  whose message wrongly says "next commit". Not rewritten (a person rewrites history); every commit builds. Prashant
  Sharma may split or reword them before pushing. Since then every commit checks `git diff --cached` first
- vitest.config.mts in place of the bundle's vitest.config.ts: Vite warned "ESM syntax in a file loaded as CommonJS";
  the other ways out were a suppression variable or "type": "module" for the whole package
- `dotnet test` and `dotnet format` cannot run in this sandbox (their SDK-to-host pipe is a Unix socket too); the .NET
  tests ran as the Testing Platform executables they are (bin/<config>/net10.0/<Project>), same tests and runner
- aidlc:debugging-failures loaded for the restore failure (aidlc-build names it for step 8's failures; used at step 2)

## Amended assertions seen red
- none (the bundle lists none)

## Decisions made while working (for the PR)
- D1 (checkpoint 2) TngTech.ArchUnitNET's five dependencies — KEEP: CycleDetection 2.0.0, JetBrains.Annotations
  2026.2.0, Mono.Cecil 0.11.6, Newtonsoft.Json 13.0.4, System.ValueTuple 4.6.2, as the approved
  TngTech.ArchUnitNET.xUnitV3 0.13.5's own graph. Why: ADR 0001 names a pinned library for the module rule and
  new-system.md approves this one; the five are test-only (ArchitectureTests; no image ships them); Newtonsoft.Json
  13.0.4 is past the 13.0.1 fix of GHSA-5crp-9r3c-p9vr; if U13 fails at step 6, Q8's fallback removes all six.
  Decided by Claude at Prashant Sharma's instruction, 2026-11-11. Follow-up for the workspace root (not edited here):
  new-system.md's v5 review list names System.Net.Http and System.Text.RegularExpressions for ArchUnitNET; the design
  approver records the five above in place of them (net10.0 prunes those two). Listed in the pull request
- D2 Sandbox: Prashant Sharma set `sandbox.network.allowAllUnixSockets: true` in .claude/settings.local.json
  (2026-11-11), which also opens the Docker socket that plan Q3 kept from the agent; the agent still never uses it
  (AGENTS.md). In this session it has no effect yet: `socket(AF_UNIX)` is still refused (Python: "Operation not
  permitted"; MSBuild: SocketException 13, 81 of 81 node starts), so `-m:1` stays. If it still fails after a session
  restart, the setting brings nothing and can be removed, which restores Q3's protection — confirm with Prashant Sharma

- D3 (checkpoint 3) build scripts: allowBuilds unchanged, sharp: false and unrs-resolver: false; no other package asked
  for one. Why: both ship prebuilt platform binaries as optional dependencies (@img/sharp-*, @unrs/resolver-binding-*),
  so their install scripts are only fallbacks; allowing a script runs third-party code at install. If lint (which
  loads unrs-resolver) or the build fails for want of it, that is a stop. Decided by Claude at Prashant Sharma's
  instruction, 2026-11-11
- D4 (checkpoint 3) `pnpm peers check`: eslint-plugin-import 2.32.0, eslint-plugin-jsx-a11y 6.10.2 and
  eslint-plugin-react 7.37.5 (from eslint-config-next 16.4.5) declare eslint peers up to ^9, not 10.14.0. Kept, as
  new-system.md pins eslint 10.14.0 ("Supported by eslint-config-next from 16.4.0"); step 8 sees lint red with a
  react-hooks and a jsx-a11y violation, and a plugin that crashes or reports nothing is a stop (R-c, V4). Decided by
  Claude at Prashant Sharma's instruction, 2026-11-11
- D5 (checkpoint 3, for Prashant Sharma) the generated web/src/app/layout.tsx loads Geist and Geist Mono through
  `next/font/google`, so `next build` downloads them from fonts.googleapis.com and fonts.gstatic.com. The sandbox
  denies both ("Failed to fetch Geist from Google Fonts"); the build passed with those two hosts allowed for that one
  command. Left as generated: no DO step names it, and the fonts are part 3's (requirements 9.3). Consequence for
  slice-0-ci: the CI runner and the Dockerfile.web build stage need egress to both hosts, or the fonts are
  self-hosted with `next/font/local` first. Confirm with Prashant Sharma (tech lead) before slice-0-ci

- D6 (step 7) ModuleBoundaryTests runs its rule `WithoutRequiringPositiveResults()`: with the placeholders gone, the
  module assemblies hold no types, and ArchUnitNET refuses a rule that matches none. The test's own guard against a
  vacuous pass is its first assertion (every module loaded, C11), which plan V7 accepted as the guard until part 3
  adds types; both guards proved red with empty modules (step 7). It relaxes a library default, so it is flagged:
  confirm with Prashant Sharma in the pull request. Decided by Claude at his instruction, 2026-11-11
- D7 (step 8) Prettier's defaults (S5 sets none) flag the 7 shadcn components, globals.css and utils.ts (shadcn writes
  without semicolons). Formatted by `prettier --write` in a commit of its own (2b73ff0) rather than excluding
  src/components/ui from the gate. This met STOP IF "a generated file would need editing outside what a DO step
  names", decided under his delegation. After each later `shadcn add`, run Prettier the same way. Decided by Claude
  at Prashant Sharma's instruction, 2026-11-11

- D8 (step 8) The slice closes on equivalent local evidence, because no agent session here can run
  `scripts/check.sh lint` and `test` end to end (Unix sockets refused; the unsandboxed run refused twice by the
  auto-mode classifier). Covered: every web step of check.sh as written; `dotnet test` by running both test
  applications directly (same tests, same runner, Total 2, Failed 0, Skipped 0); `dotnet format` by its whitespace
  check in folder mode (exit 0) and the build under TreatWarningsAsErrors (0 warnings). INFERENCE: with no
  .editorconfig, `dotnet format`'s style rules stay below warning severity and its analyzer rules already fail the
  build, so the whole command would report nothing more; not proved. Not lowered: no threshold, suppression or skip.
  Before pushing, Prashant Sharma runs `scripts/check.sh lint && scripts/check.sh test && scripts/check.sh build`;
  a red result reopens this slice. slice-0-ci's CI is the first trusted run. Decided by Claude at Prashant Sharma's
  instruction ("take appropriate decisions on my behalf"), 2026-11-11
- D9 (closing the open items, same instruction, 2026-11-11):
  D5 fonts: keep `next/font/google` for slice 0; slice-0-ci gives the web build job and Dockerfile.web's build stage
  egress to fonts.googleapis.com and fonts.gstatic.com (no new dependency), and part 3 revisits self-hosting with the
  requirements 9.3 tokens. For slice-0-ci's planner; its bundle is not edited here.
  D6 relaxed rule: kept; it is removed when part 3's first module type lands (the C11 guard stays).
  D2 `allowAllUnixSockets`: it brought nothing (sockets still refused) and opens the Docker socket Q3 kept from the
  agent: remove it from .claude/settings.local.json (Prashant Sharma; agents never edit .claude/**).
  Slips 1 and 2: history is not rewritten; every commit builds; listed in the pull request.
  Self-review: the pnpm audit deferral and the UseHttpsRedirection question go to slice-0-ci (trivy gate,
  Dockerfile.api); the /health/live no-dependency test goes to part 3's /health/ready slice.
  Commit hook "no ticket key": ignored; NEW-jobwright is the provisional key until the tracker is chosen (Q1)
  Each stays open to Prashant Sharma's review of the pull request

## Assumptions
- The pinned toolchain is used through `PATH=~/.local/opt/node-v26.13.0/bin:~/.local/opt/dotnet-10.0.403:$PATH` and
  `DOTNET_ROOT=~/.local/opt/dotnet-10.0.403` on every command, as in slice-0-scaffold — confirmed by Prashant Sharma,
  2026-11-11 (restatement)
- COMMANDS' `dotnet test api/Jobwright.slnx` — resolved: on SDK 10.0.403 the positional path evaluates the solution
  exactly as `--solution` does (step 8); check.sh keeps COMMANDS as written
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
