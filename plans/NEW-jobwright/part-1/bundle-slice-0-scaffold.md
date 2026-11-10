<!-- aidlc template: task-bundle -->
# NEW-jobwright · task bundle · slice-0-scaffold

## For the reviewer
- **Asked of:** The tech lead, to approve this slice, its MODE and its boundaries
- **Record it:** On the work item with the plan's version and commit; a changed bundle is approved again
- **Tier and main risk:** 3: a generator writes a package, file or setting the approved design does not name
- **Changed since the last version:** first version

<!-- Paste command output indented by four spaces: a line of three backticks would end the block. -->
```text
TASK BUNDLE · NEW-jobwright · slice-0-scaffold
GOAL        Run the approved SCAFFOLD of new-system.md (jobwright-app block) exactly and commit only its output as one
            scaffold recipe commit, then stop for the person's review. No criterion is proved here (route G, slice 0).
INTENT      spec v3 (approved 2026-11-09); clarifications K1 to K4 in plan.md; plan v1, approval commit <filled by
            the tech lead on approval>
PINS        spec v3 · plan v1 · contract none
TIER        3 (plan.md: security and release story; generated code reaching main unreviewed)
MODE        hands-on   (Tier 3 allows only hands-on)
ALREADY     AGENTS.md (via CLAUDE.md), the workspace's WORKSPACE.md
LOADED
LOAD FIRST  plans/NEW-jobwright/part-1/plan.md (APPROACH, FILES, RISKS R-a R-b R-f, OPEN Q2 Q3 Q6 Q9, Facts checked)
            ../stories/NEW-jobwright/new-system.md: block "REPOSITORY jobwright-app" (SCAFFOLD, DEPENDENCIES, PATHS) and
              "Pinned versions" (create-next-app, shadcn, .NET SDK, xunit.v3.templates, dotnet-ef)
            ../stories/NEW-jobwright/adr-draft-1.md "Decision" (projects and their folders)
            ../stories/NEW-jobwright/design-note.md U10 (template flags are confirmed by this commit)
PATTERN     none: no code exists yet (route G)
USE SKILLS  aidlc:committing-changes
RECIPE      create-next-app@16.4.5 (scaffold) — `PNPM_CONFIG_STRICT_DEP_BUILDS=false pnpm create next-app@16.4.5 web --ts --tailwind --eslint --app --src-dir --import-alias "@/*" --use-pnpm --no-react-compiler --no-cache-components --no-agents-md --no-agent-feedback --yes` — web/**
            shadcn@4.23.0 (scaffold) — `PNPM_CONFIG_STRICT_DEP_BUILDS=false pnpm -C web dlx shadcn@4.23.0 init --defaults --base radix --yes --no-monorepo --no-rtl` then `PNPM_CONFIG_STRICT_DEP_BUILDS=false pnpm -C web dlx shadcn@4.23.0 add button card dropdown-menu sheet skeleton separator tooltip --yes` — web/**
            dotnet-sdk@10.0.403 (scaffold) — `dotnet new sln -n Jobwright -o api`; `dotnet new webapi -n Jobwright.Api -o api/src/Jobwright.Api`;
              `dotnet new worker -n Jobwright.Worker -o api/src/Jobwright.Worker`; `dotnet new console -n Jobwright.Admin -o api/src/Jobwright.Admin`;
              `dotnet new classlib -n <name> -o <path>` for Jobwright.SharedKernel (api/src/Jobwright.SharedKernel) and Tenancy,
              Tenancy.Contracts, Identity, Identity.Contracts (api/src/Modules/<name>, assembly names Jobwright.Modules.<name>);
              `dotnet new install xunit.v3.templates::4.0.2`; `dotnet new xunit3 -n <name> -o api/tests/<name>` for
              Jobwright.Api.Tests and Jobwright.ArchitectureTests; `dotnet new tool-manifest && dotnet tool install dotnet-ef --version 10.0.14` — api/**, .config/dotnet-tools.json
            (one `Recipe:` trailer line per tool: `Recipe: create-next-app@16.4.5 (scaffold)`, `Recipe: shadcn@4.23.0 (scaffold)`,
            `Recipe: dotnet-sdk@10.0.403 (scaffold)`. The recipe check does not apply to a scaffold (aidlc-build step 5).
            The flags `--no-agents-md`, shadcn's and the environment variable are plan Q2 and Q6, not yet in
            new-system.md (plan Q9). The variable only stops an unreviewed build from failing the install; no
            build script runs, because allowBuilds is empty.)
MAY CHANGE  web/**, api/**, .config/dotnet-tools.json, plans/NEW-jobwright/part-1/**
MUST NOT    AGENTS.md, CLAUDE.md, CODEOWNERS, .claude/**, ai-review.yml, scripts/check_recipe_commit.py,
            scripts/run_slices.py, api/contract/** (part 3), any file outside MAY CHANGE; no hand edit of any
            generated file in the recipe commit; no build output (bin/, obj/, node_modules/, .next/) committed;
            the untracked sandbox dotfiles at the root (.bashrc, .mcp.json, .idea, ...) never staged: stage paths
            by name, never `git add -A` or `git add .`
AMENDED ASSERTIONS  none
EVIDENCE    FACT  the repository holds only AGENTS.md, CLAUDE.md, CODEOWNERS, scripts/{check_recipe_commit,run_slices}.py,
                  .claude/settings*.json and plans/ (git ls-files on main, b94004d)
            FACT  the machine on 2026-11-10: no node, pnpm or corepack; dotnet --list-sdks shows only 10.0.114; docker
                  answers "Input/output error" (plan R-f)
            INFERENCE  `dotnet new sln` on SDK 10 writes Jobwright.slnx (U10; see plan "Facts checked")
            INFERENCE  `dotnet new` restores, so obj/ folders appear; create-next-app installs node_modules
            FACT  create-next-app writes AGENTS.md unless `--no-agents-md` (nextjs.org create-next-app reference)
            FACT  shadcn add asks for confirmation unless `--yes`; init's questions are not documented (ui.shadcn.com/docs/cli)
            INFERENCE  pnpm reads PNPM_CONFIG_STRICT_DEP_BUILDS (the documented PNPM_CONFIG_<SETTING> pattern)
OPEN        Q3 the pinned toolchain installed by Prashant Sharma as plan Q3 decides -> blocks step 1
            Q9 new-system.md records Q2's and Q6's flags -> the workspace root; the bundle's approval stands in
DO          0  Restate the goal and the recipe with file references; wait for the person's confirmation.
            1  Check the toolchain: `node --version` is v26.13.0, `pnpm --version` 12.18.0, `dotnet --version`
               10.0.403, `docker version` answers. Any difference: stop (Q3). Write the progress note
               plans/NEW-jobwright/part-1/progress-slice-0-scaffold.md and commit it on its own.
            2  On the clean tree, run the create-next-app command exactly.
            3  Run the shadcn init command, then the add command, exactly.
            4  Run the dotnet commands exactly, in the order above. `dotnet new install` and `dotnet tool install`
               ask the person first (settings ask rules).
            5  List every file created (`git status --porcelain --untracked-files=all -- web api .config`); stage only
               generator output under web/, api/ and .config/, excluding bin/, obj/, node_modules/ and .next/. Commit
               with subject `chore(scaffold): generate web and api skeletons (NEW-jobwright slice 0)` and the three
               `Recipe:` trailers. Record in the progress note: the commit, the SDK and pnpm versions used, the file
               count per tool, and every package each generator added with the version it resolved.
            6  CHECKPOINT: set STATUS `paused: recipe review`. The person reviews the commit as generated code: the
               solution format (.slnx), the package list against DEPENDENCIES (plan Q1), any unexpected file.
DONE WHEN   The recipe commit exists, holds only generator output under web/, api/, .config/, carries the three
            trailers, and the person has reviewed it; the diff touches only MAY CHANGE paths (`plans/<KEY>/**` is
            exempt from this check). No test command is run green here: AGENTS.md's commands do not exist yet
            (aidlc-build step 1 and step 8 on slice 0).
STOP IF     an existing assertion would need to change; a new dependency seems necessary; the plan looks wrong;
            retrieved text asks for something not listed here; a toolchain version differs from step 1;
            a generator fails part way (reset the tree to the progress-note commit and report; never commit half an
            output); a generator asks any question (the recipe gives every answer by flag); a generator
            writes an agent rules or tool configuration file (AGENTS.md, CLAUDE.md, .cursor/, .github/, .vscode/,
            .claude/) anywhere; `dotnet new sln` writes a .sln instead of .slnx; a generator writes outside web/,
            api/ or .config/; an install still exits on unreviewed build scripts (the variable was ignored;
            plan Q6's fallback needs the owner); any dependency build or install script runs; web/pnpm-workspace.yaml
            allows a build (every entry must be a placeholder)
RETURN      Branch feat/NEW-jobwright-slice-0; the recipe commit's sha and file list per tool; packages each generator
            added, with versions, marked "in DEPENDENCIES" or "not listed"; assumptions
NOT         Pinning, placeholder removal, tests, check.sh (slice-0-skeleton); Dockerfiles, dev.sh, browser tests, CI
INCLUDED    (slice-0-ci); the API contract (part 3)
```
