<!-- aidlc template: progress-note -->
# Progress · NEW-jobwright · slice-0-scaffold

Session state, not memory: it lets a fresh session resume from the record.
File: `plans/NEW-jobwright/part-1/progress-slice-0-scaffold.md`, committed on its own as the slice's first commit, then
with the slice; the compliance reviewer and the slice runner read it.

```text
STATUS      stopped: generators wrote outside web/, api/, .config/ (global.json and dotnet-tools.json at the root, step 4)
MODE        hands-on
```

## Restatement (delegate modes)
- Not applicable: hands-on. The restatement was given in the session and confirmed by Prashant Sharma, 2026-11-10.

## Pauses confirmed (by the person)
- none yet

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
- [ ] 5 List files, stage generator output by path (no bin/, obj/, node_modules/, .next/), commit with three Recipe:
      trailers; record sha, versions, file counts and added packages here
- [ ] 6 CHECKPOINT: STATUS `paused: recipe review`

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
