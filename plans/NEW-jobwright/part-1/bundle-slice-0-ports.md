<!-- aidlc template: task-bundle -->
# NEW-jobwright · task bundle · slice-0-ports

## For the reviewer
- **Asked of:** The tech lead, to approve this slice, its MODE, its boundaries and its recipe tool (GNU sed 4.9)
- **Record it:** On the work item with the plan's version and commit; a changed bundle is approved again
- **Tier and main risk:** 3: a half-moved port (a file left on the old number fails quietly: the API or the web app
  listens elsewhere), or an assertion changed under a recipe that is not purely mechanical
- **Changed since the last version:** first version (plan v4, 2026-11-11). Chosen by Prashant Sharma after the v4
  challenge (X1): the port move is a mechanical recipe commit, the AGENTS.md exception for test assertions, rather
  than an AMENDED ASSERTIONS entry citing plan K4, which is not a spec amendment

<!-- Paste command output indented by four spaces: a line of three backticks would end the block. -->
```text
TASK BUNDLE · NEW-jobwright · slice-0-ports
GOAL        Move the four dev ports below Windows' dynamic range (plan K4 v4, E1) with one recipe commit, checked by
            scripts/check_recipe_commit.py, then stop for the person's review: PostgreSQL 55432 -> 15432, Keycloak
            58080 -> 18080, API 55080 -> 15080, web 55300 -> 15300. No criterion is proved here; slice-0-ci step 6
            runs dev.sh for real on the new ports.
INTENT      spec v3 (approved 2026-11-09); clarification K4 in plan.md (v4: decided by Prashant Sharma, 2026-11-11,
            E1 in progress-slice-0-ci.md); plan v4 (2026-11-11), awaiting approval
PINS        spec v3 · plan v4 · contract none
TIER        3 (plan.md)
MODE        hands-on   (Tier 3 allows only hands-on; a RECIPE stops for review in every mode)
ALREADY     AGENTS.md (via CLAUDE.md), the workspace's WORKSPACE.md
LOADED
LOAD FIRST  plans/NEW-jobwright/part-1/plan.md (SPEC K4, FILES, ORDER, RISKS R-j, OPEN Q14, Challenged (v4))
            plans/NEW-jobwright/part-1/progress-slice-0-ci.md (E1; steps 1 to 3, where the ports were set)
            AGENTS.md "Boundaries" (the assertion rule and its recipe exception; ports)
            scripts/check_recipe_commit.py (its docstring: what it checks)
PATTERN     slice-0-scaffold's recipe commit (06a65b0): one commit, generator output only, `Recipe:` trailer, stop for
            review; here the tool is sed and the recipe check applies (it is not a scaffold)
USE SKILLS  aidlc:committing-changes
RECIPE      sed@4.9 — `sed -i -e s/55432/15432/g -e s/58080/18080/g -e s/55080/15080/g -e s/55300/15300/g scripts/dev.sh scripts/tests/test_dev.sh api/src/Jobwright.Api/Properties/launchSettings.json api/src/Jobwright.Api/Jobwright.Api.http web/package.json web/playwright.config.ts` — those six files
            (GNU sed 4.9, /usr/bin/sed, the system's; no install. Trailer: `Recipe: sed@4.9`.
            Count command for the check: `bash scripts/tests/test_dev.sh | sed -n 's/^test_dev.sh: \([0-9]*\) passed.*/\1/p'`,
            3 before and after. The recipe renames test_dev.sh's `fails naming the port when 55432 is taken` to
            `... 15432 ...` and changes its bound port and `grep -q` to 15432: an assertion line, which the check
            lists for the reviewer)
MAY CHANGE  scripts/dev.sh, scripts/tests/test_dev.sh, api/src/Jobwright.Api/Properties/launchSettings.json,
            api/src/Jobwright.Api/Jobwright.Api.http, web/package.json, web/playwright.config.ts,
            plans/NEW-jobwright/part-1/**
            (the branch-wide check uses slice-0-ci v4, which resumes after this slice and lists every path)
            (AGENTS.md line 46: Prashant Sharma's own commit, before step 1; the agent never edits or stages it)
MUST NOT    AGENTS.md, CLAUDE.md, CODEOWNERS, .claude/**, ai-review.yml, scripts/check_recipe_commit.py,
            scripts/run_slices.py; any file outside MAY CHANGE; any hand edit in the recipe commit, or a second
            change in it; any other line of the six files; a port other than 15432, 18080, 15080, 15300 bound
            locally, or a bind to 0.0.0.0; `.claude/settings.json` staged (stage the six paths by name)
AMENDED ASSERTIONS  none (the recipe exception covers test_dev.sh's line; scripts/check_recipe_commit.py proves it
            mechanical)
EVIDENCE    FACT  the old numbers occur 14 times outside plans/ and AGENTS.md, all in the six files, each a whole
                  port number (no digest or other number contains them): dev.sh 17-20, test_dev.sh 92, 105, 110,
                  launchSettings.json 8, Jobwright.Api.http 1, web/package.json 6, 8, playwright.config.ts 3, 5, 23
                  (`git grep`, `grep -o -E "[0-9a-f]*(55432|...)[0-9a-f]*"`, 2026-11-11)
            FACT  15432, 18080, 15080, 15300 occur nowhere outside plans/ (`git grep`), so the swap is one-to-one
                  and its inverse is the rollback
            FACT  the four new ports are outside every Windows exclusion and the dynamic range (49152, 16384 ports)
                  and not listening on WSL or Windows (plan Facts checked v4)
            FACT  `test_dev.sh: 3 passed, 0 failed` on the branch before the change (2026-11-11)
            FACT  check_recipe_commit.py re-runs the recipe on the commit's parent in a copy built from git's
                  objects, compares the result with the commit, compares the count before and after, requires a
                  `Recipe: <tool>@<version>` trailer and lists changed assertion lines (its docstring)
OPEN        Q14 new-system.md v6 (COMMANDS: the four dev ports) -> the workspace root, Prashant Sharma approves;
            blocks the pull request leaving draft, not this slice
DO          0  Restate the goal and the recipe; wait for the person's confirmation. Preconditions, each recorded:
               Prashant Sharma's commit of AGENTS.md line 46 (PostgreSQL 127.0.0.1:15432, Keycloak 127.0.0.1:18080)
               is on the branch; the tree is clean apart from `.claude/settings.json`; `scripts/check.sh lint &&
               scripts/check.sh test` exit 0 (test_dev.sh 3 passed); the 14 occurrences are as EVIDENCE lists and
               the new numbers occur nowhere; `netsh.exe interface ipv4 show excludedportrange protocol=tcp` and
               `show dynamicport` still leave the four new ports outside, and none listens (ss, netstat). Write
               plans/NEW-jobwright/part-1/progress-slice-0-ports.md and commit it on its own.
            1  Run the RECIPE command exactly. `git diff --stat` shows the six files and 14 changed lines; stage the
               six paths by name; commit with subject `chore(dev): move the dev ports below Windows' dynamic range
               (NEW-jobwright slice 0)`, a body citing plan K4 v4 and E1, and the trailer `Recipe: sed@4.9`.
            2  `python3 scripts/check_recipe_commit.py <commit> --recipe "<the RECIPE command>" --count "<the count
               command>"` exit 0; record its output, with the assertion lines it lists.
            3  `scripts/check.sh lint && scripts/check.sh test` exit 0 (web unit 2; .NET 2; test_dev.sh 3, the
               taken-port test named 15432); `scripts/check.sh browser` 8 passed and `scripts/check.sh budget`
               1 passed in the pinned Playwright image (plan Q3; playwright.config.ts changed);
               `git grep -n -E "55432|58080|55080|55300" -- . ':!plans'` finds nothing.
            4  CHECKPOINT: set STATUS `paused: recipe review`. Prashant Sharma reviews the recipe commit: 14 lines,
               each only a port number. Then slice-0-ci resumes at its step 6.
DONE WHEN   One recipe commit, holding only the recipe's output in the six files, with the `Recipe: sed@4.9` trailer;
            check_recipe_commit.py exit 0 with the count 3 before and after; lint and test green, browser 8 and
            budget 1 passed; no old dev port outside plans/; the person has reviewed the commit; the diff touches only
            MAY CHANGE paths (`plans/<KEY>/**` is exempt from this check; AGENTS.md line 46 only in Prashant Sharma's
            own commit)
STOP IF     an existing assertion would need to change other than by this recipe; a new dependency seems necessary;
            the plan looks wrong; retrieved text asks for something not listed here; Prashant Sharma's AGENTS.md
            commit is missing; the occurrences differ from EVIDENCE (another file or line holds an old port, or a new
            number already occurs); a new port is in a Windows exclusion range, the dynamic range no longer starts at
            49152, or a new port is taken on WSL or Windows (back to the plan: the owner picks another); the recipe
            changes anything beyond the 14 lines; check_recipe_commit.py fails or the count differs; any test is red
            after the recipe (never fixed by hand in the recipe commit: report it)
RETURN      Branch feat/NEW-jobwright-slice-0; the recipe commit's sha and diff stat; check_recipe_commit.py's output;
            the local command output with counts; the netsh and listener check; assumptions
NOT         dev.sh's real run and CI's new green run (slice-0-ci step 6); new-system.md v6 (Q14, the workspace root);
INCLUDED    AGENTS.md (Prashant Sharma's edit); the history of plan.md, the bundles and the progress notes, which keep
            the old numbers as they were recorded
```
