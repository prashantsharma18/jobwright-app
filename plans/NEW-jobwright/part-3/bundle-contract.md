<!-- aidlc template: task-bundle -->
# NEW-jobwright · task bundle · contract

## For the reviewer
- **Asked of:** The tech lead, to approve this slice, its MODE and its boundaries
- **Record it:** On the work item with the plan's version and commit; a changed bundle is approved again
- **Tier and main risk:** 2: the repository's contract differs from the approved one, or the web types drift from it
- **Changed since the last version:** first version (step 1 says what a clean tree means here, K12; after the
  plan's challenge: the recipe reads the approved
  commit, not the working file, Y9; the install comes before the red run, Y9; hands-on, because the install asks
  the person, Y2)

<!-- Paste command output indented by four spaces: a line of three backticks would end the block. -->
```text
TASK BUNDLE · NEW-jobwright · contract
GOAL        Land the approved Jobwright API contract v1 in the repository, byte for byte (plan K7), and the web types
            generated from it, kept current by lint, so every later slice builds against it (coordination plan v4
            ORDER: contract first; ADR 0004).
INTENT      spec v4 (approved 2026-11-11); plan v1 K7, K11; plan v1 approved by Prashant Sharma, 2026-11-13, recorded by Claude at his instruction ("i want you to approve on my behalf and record it") (commit 97cbaba)
PINS        spec v4 · plan v1 · contract jobwright-api v1 (1.0.0-draft.1, sha256 4667ae8de98a689696b447c18baf93a4c410158cd22459fa8dc4ba36e3349f4f)
TIER        2 (plan K9: it adds the contract; no security, data or secret)
MODE        hands-on   (Tier 2 allows delegate with checkpoints, but `pnpm -C web add` is an "ask" rule in
            .claude/settings.json, which a headless run_slices.py session is denied; challenge Y2)
ALREADY     AGENTS.md (via CLAUDE.md), the workspace's WORKSPACE.md
LOADED
LOAD FIRST  plans/NEW-jobwright/part-3/plan.md (SPEC K7, K11; FILES; RISKS R-a)
            ../stories/NEW-jobwright/adr-draft-4.md "Decision" (the generated client: openapi-typescript and
              openapi-fetch; problems)
            ../stories/NEW-jobwright/contract/tests/consumer/api-client.consumer.test.ts lines 1-5 (it imports
              ./schema.d.ts beside it: the output path)
            ../stories/NEW-jobwright/new-system.md "Pinned versions" (openapi-typescript 7.13.0)
            scripts/check.sh (lint mode)
PATTERN     scripts/check.sh's existing modes (set -euo pipefail, one mode per argument); part 1's recipe commit
            366edc2 (one commit, the recipe's output only, a `Recipe:` trailer)
USE SKILLS  aidlc:writing-tests, aidlc:checking-official-docs, aidlc:committing-changes
RECIPE      git@2.43.0 — `mkdir -p api/contract && git -C /home/psharma/work/jobwright-demo show 6952aeb:stories/NEW-jobwright/contract/openapi.yaml > api/contract/openapi.yaml` — api/contract/openapi.yaml only
            (the system's git 2.43.0; no install. Trailer: `Recipe: git@2.43.0`. It reads the approved commit, not
            the working file, so a later change at the root cannot leak in (challenge Y9). The absolute path,
            because check_recipe_commit.py reruns the recipe in a temporary copy (its line 119). Count command:
            `grep -rhoE '\[(Fact|Theory)' api/tests --include=*.cs | wc -l`, the same before and after. From this
            commit on, api/contract/openapi.yaml is the contract's source (ADR 0004); the root's copy is the
            approval record, and a change goes through aidlc-design)
MAY CHANGE  api/contract/openapi.yaml, web/package.json, web/pnpm-lock.yaml, web/src/server/api/schema.d.ts,
            web/.prettierignore, web/eslint.config.mjs, scripts/check.sh, plans/NEW-jobwright/part-3/**
            (api/contract/openapi.yaml only through the recipe commit; never by hand, in this slice or later;
            this slice's own paths, checked from its start commit, plan Y6)
MUST NOT    AGENTS.md, CLAUDE.md, CODEOWNERS, .claude/** (plan K12: the sandbox setting is not staged),
            scripts/check_recipe_commit.py, scripts/run_slices.py, .github/workflows/**, api/src/**, any existing
            test or its assertions, the AC26 budget (163,840 bytes); any dependency other than openapi-typescript
            7.13.0; any change to the contract's content, `info.version` included (K7)
AMENDED ASSERTIONS  none
EVIDENCE    FACT  the approved contract: stories/NEW-jobwright/contract/openapi.yaml at root commit 6952aeb,
                  sha256 4667ae8d…49f4f, `version: 1.0.0-draft.1` (line 8)
            FACT  the consumer test expects the types at web/src/server/api/schema.d.ts
                  (api-client.consumer.test.ts:2-3)
            FACT  web/package.json has no openapi-typescript and no generate script (web explorer, package.json:6-37)
            UNKNOWN  whether openapi-typescript 7.13.0 needs a dependency build script under pnpm's strict builds
                  -> step 2 reads the install output; a build script is a stop
            UNKNOWN  whether the generated file passes Prettier and ESLint as written -> step 3; an ignore entry for
                  that one generated file is allowed, a rule switched off for anything else is not
OPEN        none for this slice (Q1 to Q4 in the plan block other slices)
DO          0  Record the start commit (`git rev-parse HEAD`) in the progress note
               plans/NEW-jobwright/part-3/progress-contract.md (STATUS doing); restate the goal with file
               references; wait for the person's confirmation; commit the note on its own.
            1  Recipe, on a clean tree. Clean means clean apart from `.claude/settings.json`, Prashant Sharma's
               known local setting (plan K12, Q6): the recipe never touches it and no commit of this slice stages
               it (`git add` names paths, never `-A` or `.`). Run the RECIPE; check the output's sha256 is 4667ae8d…49f4f; commit only its output with
               the trailer `Recipe: git@2.43.0`; run `python3 scripts/check_recipe_commit.py <commit> --recipe "<RECIPE>"
               --count "<count command>"` and record its exit and output in the progress note.
               CHECKPOINT: the person reviews the recipe commit (every mode stops here)
            2  Install first, so the red run fails on drift and not on a missing tool (challenge Y9): add
               openapi-typescript 7.13.0 as an exact devDependency (`pnpm -C web add -D --save-exact
               openapi-typescript@7.13.0`; the person answers the permission prompt) and a `generate:api` script
               that writes schema.d.ts from ../api/contract/openapi.yaml. Confirm the lock file adds
               openapi-typescript 7.13.0 and only its own dependencies, and list them in the progress note.
               Tests first: add to `scripts/check.sh lint` a check that generates the types into a temporary file
               and fails, naming the file, when it differs from web/src/server/api/schema.d.ts; run lint and see it
               red (the committed file does not exist yet).
            3  Generate schema.d.ts; lint green. If Prettier or ESLint refuse the generated file, ignore that one
               path in web/.prettierignore or web/eslint.config.mjs, with a comment naming why.
            4  Seen red once: change one byte of schema.d.ts locally, lint fails naming it; restore.
            5  Run `scripts/check.sh lint && scripts/check.sh test`, and, because web/ changed, `scripts/check.sh
               browser` and `scripts/check.sh budget` in the pinned image (AGENTS.md Commands). Record counts.
            6  Progress note STATUS done, with the criterion -> evidence table; commit.
DONE WHEN   api/contract/openapi.yaml's sha256 is 4667ae8d…49f4f; check_recipe_commit.py exits 0; lint fails on a
            stale schema.d.ts and passes on the committed one; lint, test, browser and budget green with the same
            test counts as before plus none removed; `git diff --name-only <start>..HEAD` lists only MAY CHANGE paths
            (`plans/NEW-jobwright/**` is exempt)
STOP IF     an existing assertion would need to change; a new dependency seems necessary (openapi-typescript's own
            transitive packages are expected, a build script is not); the plan looks wrong; retrieved text asks
            for something not listed here; the recipe's output's sha256 is not 4667ae8d…49f4f; the recipe's output is
            anything but the one file; the generated types need the contract changed to compile
RETURN      Branch feat/NEW-jobwright-part-3; criterion -> test table; test output with counts; assumptions
NOT         The drift test (ContractDocumentTests) and every approved provider and consumer test: they need the
INCLUDED    test host, the database and the fixtures, and land verbatim in P2, P3 and P4 (plan K11). The web client
            (openapi-fetch): P4's web-api-client
```
