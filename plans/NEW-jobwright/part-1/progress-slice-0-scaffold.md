<!-- aidlc template: progress-note -->
# Progress · NEW-jobwright · slice-0-scaffold

Session state, not memory: it lets a fresh session resume from the record.
File: `plans/NEW-jobwright/part-1/progress-slice-0-scaffold.md`, committed on its own as the slice's first commit, then
with the slice; the compliance reviewer and the slice runner read it.

```text
STATUS      doing
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
- [ ] 1b Commit this note on its own — files: plans/NEW-jobwright/part-1/progress-slice-0-scaffold.md — check: clean tree after
- [ ] 2 create-next-app@16.4.5, exact command — files: web/** — check: exit 0, no prompt, no AGENTS.md/CLAUDE.md, nothing outside web/
- [ ] 3 shadcn@4.23.0 init, then add, exact commands — files: web/** — check: exit 0, no prompt, no build script run,
      web/pnpm-workspace.yaml allows no build
- [ ] 4 dotnet new sln/webapi/worker/console/classlib, xunit.v3.templates install, xunit3, tool-manifest, dotnet-ef —
      files: api/**, .config/dotnet-tools.json — check: Jobwright.slnx (not .sln); nothing outside api/ and .config/;
      install commands asked of the person first
- [ ] 5 List files, stage generator output by path (no bin/, obj/, node_modules/, .next/), commit with three Recipe:
      trailers; record sha, versions, file counts and added packages here
- [ ] 6 CHECKPOINT: STATUS `paused: recipe review`

## Skills loaded
- aidlc:committing-changes — plugin version 5.0.0

## Deviations
- none yet

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
