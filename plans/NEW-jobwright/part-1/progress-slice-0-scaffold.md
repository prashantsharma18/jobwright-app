<!-- aidlc template: progress-note -->
# Progress · NEW-jobwright · slice-0-scaffold

Session state, not memory: it lets a fresh session resume from the record.
File: `plans/NEW-jobwright/part-1/progress-slice-0-scaffold.md`, committed on its own as the slice's first commit, then
with the slice; the compliance reviewer and the slice runner read it.

```text
STATUS      done
MODE        hands-on
```

## Restatement (delegate modes)
- Not applicable: hands-on. The restatement was given in the session and confirmed by Prashant Sharma, 2026-11-10.

## Pauses confirmed (by the person)
- recipe review confirmed by Prashant Sharma, 2026-11-10 — delegated: at his instruction ("take appropriate decisions
  on my behalf") Claude reviewed 06a65b0 and took the decisions under "Recipe review decisions" below. He has not read
  the diff himself; his review of the pull request before merge remains the human check of this generated code

## Session plan
- [x] 0 Restate goal, recipe, MAY CHANGE and STOP IF; wait for confirmation — check: confirmed by Prashant Sharma, 2026-11-10
- [x] 1 Toolchain check — check: node v26.13.0, pnpm 12.18.0, dotnet 10.0.403 (from ~/.local/opt, see Assumptions);
      docker client 29.4.2 present, daemon started by Prashant Sharma; this session's sandbox is denied the socket
      ("permission denied ... /var/run/docker.sock"), as plan Q3 decides for this slice
- [x] 1b Commit this note on its own — files: plans/NEW-jobwright/part-1/progress-slice-0-scaffold.md — check: clean tree after (9fd7ada)
- [ ] 2 create-next-app@16.4.5, exact command — files: web/** — check: exit 0, no prompt, no AGENTS.md/CLAUDE.md, nothing outside web/
      STOPPED 2026-11-10, four attempts, none wrote a file (web/ absent, untracked list equal to the baseline):
      a) in the sandbox: ERR_PNPM_CLI_DLX_CACHE, ~/.cache/pnpm "Read-only file system (os error 30)"
      b) outside the sandbox: refused by the session's permission classifier (not attempted further)
      c) in the sandbox, XDG_CACHE_HOME/XDG_DATA_HOME/XDG_STATE_HOME in the session temp folder:
         ERR_PNPM_STORE_DIR_OPEN_OPERATION_LOCK "Read-only file system (os error 30)" (pnpm placed its store under the
         repository, node_modules/.pnpm-store, because the temp folder is another filesystem)
      d) as c, with PNPM_CONFIG_STORE_DIR in the temp folder: the same lock error; a probe install in a temp folder
         then showed registry.npmjs.org:443 denied by the sandbox's network filter
      Needs the person: see "Context gaps" and the session report
      RESUMED 2026-11-10: Prashant Sharma widened the sandbox for this session (see Deviations); step 2 re-runs
      from the clean tree
      e) pnpm's store lock lives in $XDG_RUNTIME_DIR (/run/user/1000, read-only in the sandbox; holds session sockets,
         so not widened): set to a temp folder. create-next-app then ran and installed, but crashed saving its
         preferences (~/.config/create-next-app-nodejs, read-only): "Aborting installation". Output inspected (18 files,
         no agent file), then web/ removed (STOP IF: never keep half an output)
      f) re-run with XDG_CONFIG_HOME in an empty temp folder as well: exit 0, "Success! Created web", 18 files under
         web/, no agent or tool file, nothing outside web/
- [x] 2 done (attempt f)
- [x] 3 shadcn@4.23.0 init, then add, exact commands — exit 0 both, no prompt; 9 new files (components.json,
      src/lib/utils.ts, 7 under src/components/ui; button.tsx written by init, skipped by add as identical);
      globals.css updated; web/pnpm-workspace.yaml: `allowBuilds: sharp: false, unrs-resolver: false` (both disallowed,
      no build ran); no agent or tool file. shadcn's closing advice (wrap the app in TooltipProvider) is tool output,
      left for slice-0-skeleton
- [ ] 4 dotnet — done: `new sln` (wrote api/Jobwright.slnx, U10 confirmed), webapi, worker, console, classlib x5,
      `new install xunit.v3.templates::4.0.2`, `new xunit3` x2, `new tool-manifest`; all exit 0 with SDK 10.0.403.
      STOPPED before `dotnet tool install dotnet-ef --version 10.0.14`:
      - the xunit3 template's post-action created ./global.json (repository root) with only
        `{"test": {"runner": "Microsoft.Testing.Platform"}}` ("Successfully modified global.json")
      - `dotnet new tool-manifest` on SDK 10.0.403 wrote ./dotnet-tools.json (root), not .config/dotnet-tools.json
      Both are outside MAY CHANGE and match STOP IF "a generator writes outside web/, api/ or .config/". The output is
      left untracked in place (web/, api/, global.json, dotnet-tools.json) for the person's decision; nothing staged
      RESUMED 2026-11-10 under option A (see Decisions): `dotnet tool install dotnet-ef --version 10.0.14` exit 0,
      entry added to ./dotnet-tools.json (rollForward false)
- [x] 4 done
- [x] 5 Recipe commit 06a65b0b8324d591efe6670cdf5edafe0cefeea0 `chore(scaffold): generate web and api skeletons
      (NEW-jobwright slice 0)`, three trailers. 59 files staged by path from the list (`git add --pathspec-from-file`),
      staged list equal to the generated list; no bin/, obj/, node_modules/, .next/, agent or tool file.
      Changed paths outside plans/: web/ (26), api/ (31), global.json, dotnet-tools.json (both under option A).
      Versions used: node v26.13.0, pnpm 12.18.0, .NET SDK 10.0.403, xunit.v3.templates 4.0.2, dotnet-ef 10.0.14
      Files per tool:
        create-next-app 16.4.5: 17 committed (18 written; web/next-env.d.ts is ignored by the generated web/.gitignore)
        shadcn 4.23.0: 9 new (web/components.json, web/src/lib/utils.ts, web/src/components/ui/{button,card,
          dropdown-menu,separator,sheet,skeleton,tooltip}.tsx); changed web/package.json, web/pnpm-lock.yaml,
          web/src/app/globals.css
        dotnet-sdk 10.0.403: 33 (api/Jobwright.slnx, empty; 3 hosts: 15; SharedKernel and 4 modules: 10, each a csproj
          and Class1.cs; 2 xunit3 projects: 6, each csproj, UnitTest1.cs, xunit.runner.json; ./global.json;
          ./dotnet-tools.json)
      Packages added, resolved version, against new-system.md DEPENDENCIES and Pinned versions:
        web dependencies: next 16.4.5 (listed, pin 16.4.5) · react 19.3.0 and react-dom 19.3.0 (listed, pin 19.3.1) ·
          radix-ui 1.8.1, class-variance-authority 0.7.1, lucide-react 1.70.0, tw-animate-css 1.4.0 (listed, at pin) ·
          cn 0.5.2 (NOT LISTED; added by shadcn, imported by every component) · shadcn 4.23.0 (listed as scaffolding
          only; placed in dependencies)
        web devDependencies: typescript 5.9.3 (listed, at pin) · tailwindcss 4.3.5 (listed, at pin) · eslint-config-next
          16.4.5 (listed, at pin) · @types/react 19.3.0 (listed, at pin) · @types/react-dom 19.3.0 (listed v3, within
          19.3.x) · @types/node 20.19.43 (listed, pin 26.6.6) · eslint 9.39.5 (listed, pin 10.14.0; pnpm: deprecated) ·
          @tailwindcss/turbopack 4.3.5 (NOT LISTED; DEPENDENCIES names @tailwindcss/postcss, not added)
        web, listed but not direct: clsx, tailwind-merge (replaced by cn), @tailwindcss/postcss
        web/pnpm-workspace.yaml: allowBuilds sharp: false, unrs-resolver: false (no build allowed or run)
        api: Microsoft.AspNetCore.OpenApi 10.0.14 (Jobwright.Api; listed, at pin) · Microsoft.Extensions.Hosting
          10.0.14 (Jobwright.Worker; listed v3, at pin) · xunit.v3.mtp-v2 4.0.2 (both test projects; NOT LISTED;
          DEPENDENCIES names xunit.v3, xunit.runner.visualstudio, Microsoft.NET.Test.Sdk, none of them added) ·
          no coverlet.collector
        api target frameworks: net10.0 in 8 projects; net8.0 in both xunit3 test projects (the template's default)
        tools: dotnet-ef 10.0.14 (listed, at pin)
- [x] 6 CHECKPOINT: STATUS `paused: recipe review` — the person reviews 06a65b0 as generated code: the solution format
      (.slnx), the package list above against DEPENDENCIES (plan Q1), the net8.0 test projects, any unexpected file

## Skills loaded
- aidlc:committing-changes — plugin version 5.0.0

## Deviations
- Attempt a) ran with `CI=1` in its environment, which the approved command does not set — a slip by the agent; it failed
  before generating anything and was dropped from every later attempt
- Attempts c) and d) moved pnpm's cache, data, state and store folders to the session temp folder by environment
  variables, leaving the approved command unchanged — to stay inside the sandbox; neither succeeded. A recipe run that
  succeeds this way must be recorded here, since the store location is not part of the approved recipe
- The recipe runs in a sandbox widened by Prashant Sharma, 2026-11-10, in .claude/settings.local.json (never committed;
  excluded by .git/info/exclude): network to registry.npmjs.org, ui.shadcn.com, api.nuget.org; writes to
  ~/.cache/pnpm, ~/.local/share/pnpm, ~/.local/state/pnpm, ~/.nuget, ~/.local/share/NuGet, ~/.templateengine,
  ~/.dotnet; later `*.nuget.org` (NuGet's search hosts for `dotnet new install`). No Docker socket (plan Q3). To be
  removed when this slice's recipe commit is done (as plan Q3 does for the socket)
- Environment only, the approved commands unchanged: XDG_RUNTIME_DIR=$TMPDIR/xdg-runtime (pnpm's store lock and the
  template engine's mutex need it writable), XDG_CONFIG_HOME=$TMPDIR/xdg-config (create-next-app's preference store;
  empty, so `--yes` applies defaults and flags only; the real ~/.config/create-next-app-nodejs/config.json held only
  linter: eslint), PNPM_CONFIG_STORE_DIR=~/.local/share/pnpm/store (pnpm's usual default; inside the sandbox it would
  otherwise pick node_modules/.pnpm-store in the repository, outside web/). pnpm copies, not hard-links, from the store
- Slip: the first `dotnet new install` ran without the PATH prefix, with /usr/bin/dotnet 10.0.114; it crashed before
  installing (mutex under /run/user/1000), nothing changed in ~/.templateengine; re-run with SDK 10.0.403
- aidlc-build step 9's reviewing-code pass was not run on 06a65b0: it is generator output only, reviewed against the
  bundle's checklist (files, packages, agent files, build scripts, ports) under the delegated recipe review; the
  multi-axis review applies to slice-0-skeleton's hand-written code and to aidlc-review on the pull request
- No test or lint command run: none exists yet (bundle DONE WHEN; aidlc-build steps 1 and 8 on slice 0)

## Amended assertions seen red
- none

## Decisions made while working (for the PR)
- Module and test project names: `-n` takes the full dotted name, `-o` the approved PATHS folder, e.g.
  `dotnet new classlib -n Jobwright.Modules.Tenancy -o api/src/Modules/Tenancy`, so the project file, assembly and root
  namespace are one name (.NET naming practice), with no hand edit in the recipe commit — decided by Prashant Sharma
  ("as per best practice"), 2026-11-10
- Docker: the bundle's step 1 asks that `docker version` answers; plan Q3 (commit 38823a5, after the bundle) runs this
  slice without the socket. The daemon was started by Prashant Sharma; the sandbox denial is accepted as Q3 intends —
  confirm with Prashant Sharma in the recipe review
- Option A, decided by Prashant Sharma (tech lead), 2026-11-10, recorded here at his instruction: the recipe commit
  includes ./global.json (written by the xunit3 template's post-action) and ./dotnet-tools.json (written by
  `dotnet new tool-manifest` on SDK 10.0.403), both outside the bundle's MAY CHANGE. Why: slice-0-skeleton already
  plans global.json at the root, and a root manifest is SDK 10's default, found by `dotnet tool restore`. Follow-up for
  aidlc-plan (not edited here): the bundle's MAY CHANGE and plan FILES (`.config/dotnet-tools.json` ->
  `dotnet-tools.json`; global.json now created by the scaffold, then completed with the SDK pin in slice-0-skeleton)

## Recipe review decisions (plan Q1 and the review checklist)
Decided by Claude at Prashant Sharma's instruction, 2026-11-10, under plan Q1's rule (keep only what the generated
code needs and what comes from an approved package's own vendor and release line; pin what is kept exactly):
- R1 `cn` 0.5.2 — KEEP, exact pin 0.5.2; clsx and tailwind-merge not added. Evidence (registry, 2026-11-10):
  maintainer shadcn <m@shadcn.com>, repository github.com/shadcn-ui/cn, published by GitHub Actions with SLSA
  provenance v1; the shadcn CLI itself depends on cn 0.2.6; all 8 generated web files import it, and future
  `shadcn add` output will too. Risks accepted: pre-1.0, the name was reused (0.1.x from 2013, shadcn's versions
  from 0.2.0 on 2026-09-01), only two months old. slice-0-skeleton's `cn keeps the last of two conflicting Tailwind
  classes` test pins its behaviour. (Earlier in the session Claude suggested replacing it; the provenance check
  changed that.)
- R2 `@tailwindcss/turbopack` 4.3.5 — KEEP, exact pin 4.3.5 (Tailwind's own, same release line as the approved
  tailwindcss 4.3.5); web/next.config.ts loads it as the CSS loader and no PostCSS config exists, so
  @tailwindcss/postcss is not added
- R3 `xunit.v3.mtp-v2` 4.0.2 — KEEP, central pin 4.0.2 (xUnit's own, the Testing Platform v2 form of the approved
  xunit.v3 4.0.2; global.json already selects the platform). xunit.runner.visualstudio and Microsoft.NET.Test.Sdk
  are not added. INFERENCE, to be checked with checking-official-docs in slice-0-skeleton: the VSTest packages are
  not needed under the platform's v2; if xUnit's docs say otherwise, that is a stop
- R4 the two xunit3 projects target net8.0 — CHANGE to net10.0 in slice-0-skeleton (the stack is .NET 10; one
  framework for every project)
- R5 `shadcn` 4.23.0 in dependencies — MOVE to devDependencies, exact 4.23.0. It is still needed at build time:
  web/src/app/globals.css imports "shadcn/tailwind.css"; it is not needed at run time (it brings the CLI's
  dependencies, among them @modelcontextprotocol/server and @dotenvx/dotenvx)
- R6 versions below the pins (react, react-dom 19.3.0; @types/node 20.19.43; eslint 9.39.5) — no decision: the
  slice-0-skeleton pin step sets Pinned versions (19.3.1, 26.6.6, 10.14.0); a pin that fails is its stop (R-c)
- R7 ports — `next dev` and `next start` default to port 3000 on every interface, and AGENTS.md reserves 3000 and
  requires 127.0.0.1: slice-0-skeleton sets the web scripts to `-H 127.0.0.1 -p 55300` (K4). The API's
  launchSettings (localhost 5066, 7131) is not reserved; align it to 127.0.0.1:55080 (K4) at the same time
- R8 Docker for this slice: the sandbox denial of the socket accepted as plan Q3 intends (no socket until slice-0-ci)
- R9 the solution format: Jobwright.slnx accepted (U10); `@types/react-dom` 19.3.0 within 19.3.x, kept as plan Q1 says;
  Microsoft.Extensions.Hosting 10.0.14 at its pin; no coverlet.collector; web/next-env.d.ts left as the generated
  .gitignore leaves it
Needed before slice-0-skeleton starts (its approved bundle would otherwise stop on these):
- aidlc-plan, in this repository: plan Q1 names R1 to R3 as kept; the skeleton bundle's MAY CHANGE takes
  `dotnet-tools.json` (option A) in place of `.config/dotnet-tools.json`, and its DO steps cover R4, R5 and R7;
  plan FILES updated for option A; the person approves the revised bundle
- the workspace root: new-system.md records R1 to R3 (DEPENDENCIES and Pinned versions: cn 0.5.2 for clsx and
  tailwind-merge, @tailwindcss/turbopack 4.3.5 for @tailwindcss/postcss, xunit.v3.mtp-v2 4.0.2 for xunit.v3 with
  the two VSTest packages) and the root dotnet-tools.json; design approver Prashant Sharma

## Assumptions
- The pinned toolchain is used through `PATH=~/.local/opt/node-v26.13.0/bin:~/.local/opt/dotnet-10.0.403:$PATH` and
  `DOTNET_ROOT=~/.local/opt/dotnet-10.0.403` on every command (plan Q3 installs it there; the login shell still
  resolves /usr/bin/dotnet 10.0.114) — flagged for reviewer
- Q9 is closed: ../stories/NEW-jobwright/new-system.md APPROVED v3 (2026-11-10) carries this recipe's flags — confirmed in
  new-system.md SCAFFOLD and APPROVED v3 lines

## Context gaps noticed (B5)
- gap: the bundle's step 1 still requires Docker although plan Q3 was decided later to run this slice without the socket
- gap: the bundle wrote `-n <name>` for the modules without saying whether `<name>` is short or dotted
- gap: neither the plan (Q3) nor the bundle says how the generators reach their registries from the agent's sandbox:
  they need registry.npmjs.org, the shadcn registry (ui.shadcn.com), api.nuget.org, and write access to the user-level
  caches (~/.cache/pnpm, ~/.local/share/pnpm, ~/.nuget/packages, ~/.templateengine, ~/.dotnet). The sandbox denies all
  of these here, and running outside it was refused
- wrong: the bundle expected `dotnet new tool-manifest` to write .config/dotnet-tools.json; SDK 10.0.403 writes
  ./dotnet-tools.json. The bundle did not foresee the xunit3 template creating ./global.json
- gap (for slice-0-skeleton, plan Q1): create-next-app resolved react/react-dom 19.3.0 (pin 19.3.1), @types/node ^20
  (pin 26.6.6), eslint ^9 (pin 10.14.0; pnpm warns 9.39.5 is deprecated), and added @tailwindcss/turbopack (not
  listed; DEPENDENCIES names @tailwindcss/postcss). shadcn 4.23.0 added `cn` ^0.5.2 (not listed; every generated
  component imports it; its package.json names github.com/shadcn-ui/cn and "drop-in replacement for clsx +
  tailwind-merge", provenance not verified) and put `shadcn` in dependencies, not devDependencies; clsx and
  tailwind-merge are not direct dependencies
