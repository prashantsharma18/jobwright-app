<!-- aidlc template: progress-note -->
# Progress · NEW-jobwright · slice-0-ci

Session state, not memory: it lets a fresh session resume from the record.
File: `plans/NEW-jobwright/part-1/progress-slice-0-ci.md`, committed on its own as the slice's first commit,
then with the slice; the compliance reviewer and the slice runner read it.

```text
STATUS      doing
MODE        hands-on
```

## Restatement (delegate modes)
- Not applicable: hands-on. The restatement was given in the session and confirmed by Prashant Sharma, 2026-11-11,
  with its ten flagged points (see Assumptions)

## Pauses confirmed (by the person)
- none yet

## Session plan
- [x] 0 Baseline before any change: `scripts/check.sh lint && scripts/check.sh test` exit 0 (web 1 file, 2 passed;
      .NET total 2, failed 0, skipped 0). Docker answers (server 29.4.2); no container named k3d-* or labelled
      app=k3d; 55432, 58080, 55080, 55300 free; actionlint 1.7.12 in ~/.local/bin. Restatement confirmed. This note
      committed on its own
- [ ] 1 dev.sh, tests first — files: scripts/tests/test_dev.sh, scripts/dev.sh, scripts/check.sh — check:
      test_dev.sh red (dev.sh missing), then green; refuses k3d by name and by label, refuses a silent docker,
      names 55432 when taken; no container started in any refusal case; `scripts/check.sh test` runs it
- [ ] 2 Browser harness, tests first — files: web/package.json, web/pnpm-lock.yaml, web/playwright.config.ts,
      web/tests/e2e/{skeleton,accessibility,budget}.spec.ts, web/.gitignore, web/vitest.config.mts (exclude e2e if
      needed), web/eslint.config.mjs or web/.prettierignore (only if the new files need it), scripts/check.sh —
      check: the page already exists, so the skeleton test is proved able to fail by breaking the heading once
      (not committed); axe red with a deliberate contrast fault, then green; budget measured three times (spread <= 5%),
      red at 1 byte, then green. CHECKPOINT: four screenshots, measured bytes and the number
- [ ] 3 Images — files: Dockerfile.web, Dockerfile.api, Dockerfile.worker, .dockerignore, web/next.config.ts,
      scripts/check.sh — check: digests resolved from the registries (command and output recorded); `scripts/check.sh
      build` exit 0; each image runs as non-root; web answers its home page, the API /health/live, the worker stays up
- [ ] 4 CI — files: .github/workflows/ci.yml — check: actionlint clean; every `uses:` a 40-character SHA matching its
      tag by `git ls-remote`; `git grep -n "secrets\." .github` empty. CHECKPOINT: permissions and every `uses:` line
      read by the person before commit
- [ ] 5 Draft pull request (Prashant Sharma pushes): one drill commit breaking all six gates, then its revert; each
      gate's failing line and the run links recorded here; minutes of one full run (U15)
- [ ] 6 Every AGENTS.md command run locally, counts read; boundary check and self-review (aidlc-build steps 8, 9);
      report; index row; this note and the index committed together

## Skills loaded
- aidlc:building-ci-pipelines — plugin version 5.0.0
- aidlc:testing-in-browser — plugin version 5.0.0
- aidlc:writing-tests — plugin version 5.0.0
- aidlc:securing-code — plugin version 5.0.0
- aidlc:checking-official-docs — plugin version 5.0.0
- aidlc:committing-changes — plugin version 5.0.0

## Deviations
- none yet

## Amended assertions seen red
- none (the bundle lists none)

## Decisions made while working (for the PR)
- none yet

## Assumptions
Confirmed by Prashant Sharma, 2026-11-11 (restatement):
- test_dev.sh holds three tests (k3d by name and by label in one, docker silent, port taken), so the dev.sh count is
  3, not DONE WHEN's 2
- The local browser is the cached Playwright Chromium if its revision matches @playwright/test 1.65.0; otherwise
  Prashant Sharma runs `playwright install chromium`, or the local run uses the pinned Playwright image (agents never
  install tools)
- Chromium only: the four projects (360/1440 × light/dark) and a separate budget project (1 test)
- Light and dark render the same until part 3's theme (ADR 0010); the dark projects emulate `colorScheme: 'dark'`
- Playwright's webServer stays `next start` if the docs confirm it serves standalone builds; otherwise the standalone
  server.js with public/ and .next/static copied
- ci.yml repeats the setup steps per job (a composite action is outside MAY CHANGE); the budget job runs in the same
  pinned Playwright image; plain `docker build` through check.sh, no buildx action, no layer cache
- Dockerfile.web uses node:26.13.0 for both stages (as named); the worker image publishes Worker and Admin to separate
  folders
- dev.sh writes its per-run credentials to a mode-600 file in a mktemp directory outside the repository, prints only
  the path, and removes its containers on exit
- Carried over: D9's Google Fonts egress for the web build (CI and Dockerfile.web); the pnpm audit findings stay
  deferred to part 3 (trivy); UseHttpsRedirection unchanged (the API image serves http)
- Docker is used with the k3d cluster stopped (plan Q3); only containers named jobwright-dev-* and images this slice
  builds are touched, never the owner's ai-lab-* containers
- The pinned toolchain through `PATH=~/.local/opt/node-v26.13.0/bin:~/.local/opt/dotnet-10.0.403:$PATH` and
  `DOTNET_ROOT=~/.local/opt/dotnet-10.0.403`, as in slice-0-skeleton
- `.claude/settings.json` (sandbox disabled, Prashant Sharma's change) is never staged; every commit stages by name

## Context gaps noticed (B5)
- wrong: bundle DONE WHEN says "dev.sh 2" while TESTS and DO 1 name three tests
