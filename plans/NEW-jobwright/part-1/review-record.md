<!-- aidlc template: review-record -->
# Review · NEW-jobwright · pull request #1 (part 1 of 4, slice 0)

## For the reviewer
- **Asked of:** The engineer, to decide each finding (high and medium block the merge); the reviewer named below, to give the DECISION; then a code owner, to approve
- **Record it:** Each finding's disposition under Findings; the reviewer's DECISION line below; the approval in the pull request
- **Tier and main risk:** 3: a generator or template adds a package, file or setting the approved design does not name, and it reaches `main` unreviewed; second, CI permissions or an unpinned action
- **Changed since the last version:** first version

Reviewer: Prashant Sharma, code owner and tech lead. He is also the author's director and the pushing identity: known
limits KL2 and intent I3 (spec v3), so this review is not independent, and GitHub will record no approval (KL2).
Order followed: context -> evidence -> tests (against criteria) -> diff (before the summary) -> risk

Drafted by aidlc-review, 2026-11-11, on head 7c02f5d (local 01d269a adds `plans/` only). Four local reviewer passes
(bug, security, compliance, tests), each in its own context, reading AGENTS.md from `main`. They are advisory. **No CI
AI review exists** (ci.yml is the only workflow), so none is on record. Every disposition below is a proposal; the
engineer decides each one. Each finding was checked against the code by this session before it was listed.

| Dimension | Notes |
|---|---|
| Correctness and completeness | Every gate fails when it should (bug pass traced each; drills in evidence.md). Placeholders remain (M3). The scaffold's DONE WHEN is not met (H1) |
| Safety and security | No high finding. Secret scanning and push protection are on (GitHub API, 2026-11-11). `main` is public and unprotected (S2). See security-review.md |
| Architecture fit and maintainability | Module rule present but vacuous until modules have types (H2). ArchUnitNET's five transitive packages are outside new-system.md (M4) |
| Test meaning and evidence | 16 executions, counts match the code. Three harness gaps: dark never applied (M1), hand-kept page list (M2), D6's guard (H2) |
| Operational fit | Nothing deployed. dev.sh's cleanup can leave containers on a second Ctrl+C (L1). The worker logs every second (M3) |

## Questions for the code owner, in order
1. **Context.** The plan's main risk is generated code reaching `main` unreviewed. You delegated the scaffold review
   (R1 to R9). Are you reading 06a65b0 yourself in this pull request (H1)?
2. **Evidence.** evidence.md is from run 42999475010 on 9f05a3d; the head 7c02f5d is green too (run 43002408410).
   01d269a and this stage's files are not pushed yet: will you push and see the final head green before merging (E28)?
3. **Tests.** The AC12 row says "pass ×4" for light and dark, but the dark projects scan the light page (M1). Do you
   want the dark theme exercised now or recorded as not covered until part 3?
4. **Diff.** Start with `api/tests/Jobwright.ArchitectureTests/ModuleBoundaryTests.cs:31-48` (H2), then
   `api/src/Jobwright.Admin/Program.cs:1` and `api/src/Jobwright.Worker/Worker.cs:7-14` (M3), then
   `.github/workflows/ci.yml:76-86` (L2) and `scripts/dev.sh:44-52` (L1).
5. **Risk.** The repository is public and `main` unprotected. Branch protection and required checks are available now
   on Free for a public repository, which changes KL1. Do you take S2 to the workspace root before part 3?

## Findings
High and medium block the merge until fixed or dismissed with a reason; low may be dismissed with a reason. Source:
B bug, S security, C compliance, T tests. "Fix" means a slice for aidlc-build with its own bundle.

```text
[high]   H1  Scaffold DONE WHEN not met. bundle-slice-0-scaffold.md:75-77 "and the person has reviewed it";
             progress-slice-0-scaffold.md:17-19 "He has not read the diff himself"; STATUS done. (C-H1)
             PROPOSED  not a code fix: Prashant Sharma reviews 06a65b0 as generated code in this pull request (R1 to
                       R9 as the guide) and records it in his own words. Blocks the merge until then.
             DECISION  ______

[high]   H2  D6's exception is incomplete, and its guard and expiry do not hold. (C-H2, T3)
             - AGENTS.md (main) Quality bar: "a reason, an owner and an expiry date". The approval gives an event
               ("part 3, when the first module gets a type"), not a date.
             - ModuleBoundaryTests.cs:33 checks only that each module assembly is loaded, not that it has types; all
               four have none, so the rule passes for every module without checking anything.
             - The expiry cannot be met as written: removing the call while any other module is still empty makes
               ArchUnitNET refuse that module's rule.
             - A module project the test project does not reference is neither checked nor counted.
             - The approval comment was posted by Claude under your account at your instruction; whether that is
               your approval "in the pull request" is yours to rule.
             PROPOSED  fix: give the exception a date; assert the module projects under api/src/Modules/*/*.csproj
                       equal the loaded set; require positive results for each module that has a type (so the
                       call goes away module by module); or take plan Q8's pre-approved ProjectReference check,
                       which works while the modules are empty. Post the revised exception yourself.
             DECISION  ______

[medium] M1  The dark AC12 projects scan the light page. globals.css:5 `@custom-variant dark (&:is(.dark *));`;
             nothing sets `.dark`; playwright.config.ts:36 emulates `prefers-color-scheme` only. evidence.md reports
             "pass ×4" light and dark. (T1, B-F2 rated low)
             PROPOSED  fix evidence.md now: dark "not covered until part 3's theme". Then either set `.dark` on <html>
                       in the dark projects (exercises the generated .dark tokens today), or put an assertion that dark
                       applied into part 3's theme slice with an owner.
             DECISION  ______

[medium] M2  AC12's "every page" is a hand-kept list. accessibility.spec.ts:5-8; a new page.tsx is never scanned. (T2)
             PROPOSED  fix: assert that the scanned paths cover every web/src/app/**/page.tsx. Or dismiss for slice 0
                       (one page) with the check owed by part 3's first page slice, owner named.
             DECISION  ______

[medium] M3  Generator placeholders remain (Quality bar: "no stub or placeholder left in"). (B-F1, C-M4)
             - api/src/Jobwright.Admin/Program.cs:1 `Console.WriteLine("Hello, World!");`
             - api/src/Jobwright.Worker/Worker.cs:11 the template's log line, once a second
             - web/README.md: create-next-app's text, line 17 `localhost:3000` (a reserved port; slice-0-ci
               PATTERN: "Do not copy create-next-app's README commands")
             - evidence.md's grep (`weatherforecast|Class1|UnitTest1`) cannot see these
             PROPOSED  fix: a minimal Admin entry point (usage, non-zero exit) and an idle Worker, or an exception
                       with reason, owner and date; replace the README with a pointer to AGENTS.md's commands;
                       widen the evidence grep.
             DECISION  ______

[medium] M4  ArchUnitNET's five transitive packages (CycleDetection, JetBrains.Annotations, Mono.Cecil,
             Newtonsoft.Json 13.0.4, System.ValueTuple) are not in new-system.md's approved set; v6 lines 313-314
             still name System.Net.Http and System.Text.RegularExpressions, which net10.0 prunes. D1 kept them at a
             checkpoint where the bundle says such a package "is a stop". (C-M2, S7 rated low)
             PROPOSED  sent to the workspace root: new-system.md v7 records the five, after someone reads
                       CycleDetection's source and publisher; Prashant Sharma approves. Not fixable in this repository.
             DECISION  ______

[medium] M5  A STOP IF was met and the work went on under delegation: skeleton D7 (progress-slice-0-skeleton.md
             :191-195); checkpoints 2 and 3 delegated; new-system.md v4 approval delegated. Each decision records
             who took it. (C-M3)
             PROPOSED  records only: Prashant Sharma confirms R1 to R9, D1, D3 to D9 in this pull request, or says
                       which he reopens.
             DECISION  ______

[medium] M6  The progress notes' "Skills loaded" lists omit skills the work used (writing-tests, reviewing-code,
             debugging-failures, testing-in-browser; per note in C-M1).
             PROPOSED  records only: a Deviations line per note saying which was not loaded and why. Or downgrade
                       to low: it changes no code.
             DECISION  ______

[medium] S1  Nothing in CI scans for secrets while the repository is public. (S1)
             PROPOSED  downgrade to low and dismiss for slice 0: FACT, GitHub secret scanning and push protection
                       are enabled (`security_and_analysis`, 2026-11-11); gitleaks stays part 3's. Optional: turn on
                       non-provider patterns (disabled).
             DECISION  ______

[low]    L1  dev.sh:45 resets the traps before `wait` (:49), so a second Ctrl+C during shutdown leaves the
             PostgreSQL and Keycloak containers and the credentials folder. No test covers a partial start. (B-F3)
             PROPOSED  fix: `trap '' INT TERM` in cleanup, or remove containers before waiting.
[low]    L2  The SHA rule checks only `.github/workflows/*.yml` (ci.yml:82), and an absolute-URL `uses:` with a SHA
             passes. (B-F4, S3)
             PROPOSED  fix: `*.y*ml`, `.github/actions/**/action.y*ml`, require `owner/repo[/path]@`.
[low]    L3  accessibility.spec.ts:28 hard assertion in the page loop hides later pages' violations. (B-F5)
             PROPOSED  fix: `expect.soft` or one test per page (with M2).
[low]    L4  Dockerfile.web:23-24 and playwright.config.ts:22 do not copy `public/` (none exists yet). (B-F6)
             PROPOSED  dismiss now; owed by the change that creates `public/`.
[low]    L5  HealthLiveTests runs only in Development; no health check is registered, so `Predicate` is untested;
             test names carry no ID (K2, U13, C10). (T4)
             PROPOSED  fix: a Production-environment case; IDs in the names.
[low]    L6  budget.spec.ts checks neither the 200 status nor that each size is above 0. (T5)
             PROPOSED  fix: both assertions.
[low]    L7  test_dev.sh:105 tests one of dev.sh's four ports; `started_nothing` misses `docker compose`. (T6)
             PROPOSED  fix: loop over the four ports.
[low]    L8  Dockerfile.web:9 installs pnpm@12.18.0 without checking it against the lock's sha512. (S4)
             PROPOSED  fix: verify the integrity; `--ignore-scripts`.
[low]    L9  .gitignore and .dockerignore ignore `.env*` but not `*.pem`, `*.key`, `*.pfx`, `*.p12` (mkcert in
             part 3). (S5)
             PROPOSED  fix: add them to both.
[low]    L10 The web runtime stage is the full node image (Dockerfile.web:17). (S6)
             PROPOSED  dismiss for slice 0: a slim tag is a new image and needs the owner (AGENTS.md).
[low]    L11 Public CI artifacts will hold Playwright traces; dev.sh's database user is a superuser, which bypasses
             row-level security. (S9)
             PROPOSED  dismiss now; owed by part 3's sign-in and tenancy slices, written into its plan.
[low]    L12 web/package.json has no `engines` field; plan FILES names "engines node 26.13.0". (C-L2, B-Q3)
             PROPOSED  fix: add it, or correct the plan.
[low]    L13 pr-body.md is stale (D6 undecided; "reviewed as generated code"). (C-L1)
             PROPOSED  fixed by pr-description.md (this stage).
[low]    L14 evidence.md:55 "14 NuGet" direct dependencies: 5 are referenced, 9 are central pins only. (C-L3)
             PROPOSED  fix the wording.
[low]    L15 ci.yml:105 runs actionlint with `-shellcheck= -pyflakes=`, a reason but no owner or date (E8). (C-L4)
             PROPOSED  the engineer rules: a Quality bar exception (then owner and date) or the chosen configuration.
[low]    L16 Above the size guide: about 1,068 hand-written lines added, 337 removed, plus 8,655 generated. (C-L5)
             PROPOSED  dismiss: one pull request for slice 0 was decided by Prashant Sharma (plan K1).
[low]    L17 366edc2's `Recipe:` line is not in git's trailer block. (C-L6)
             PROPOSED  dismiss: approved at the recipe review; check_recipe_commit.py accepts it.
[low]    L18 bundle-slice-0-skeleton.md:30 still says plan v3 is "awaiting approval" (approved, 02a2cfb). (C-L7)
             PROPOSED  fix the line.
[low]    L19 Not in this pull request: on this machine the sandbox is off (`.claude/settings.json`, uncommitted)
             and `allowAllUnixSockets` is on; the Docker socket allows `docker exec` past the kubectl and k3d deny
             rules. D8 says to turn the sandbox back on after slice 0. (S8, C-Q3)
             PROPOSED  the owner restores it; an agent does not change its own settings.

[question] Q1 AC26 counts external script files only; inline script (Next's data payload) is not counted. Intended
              for the Overview in part 3? (B-Q1, T7)
[question] Q2 c54c922 changes main's AGENTS.md line 46; it carries the same identity as the agent's commits. Did you
              write it yourself, and do you treat it as a rules-file change? (B-Q2, C-Q1)
[question] Q3 AGENTS.md's "one browser test file" command does not build first, so a local run can test an old build.
              A line for aidlc-onboard (confirm) to propose? (T)
[answered] C-Q2 commit authors: all 74 commits main..01d269a have author and committer
              `prashantsharma18 <6386481+prashantsharma18@users.noreply.github.com>` (git log, 2026-11-11).
```

Instructions found in content (not acted on): E13, the web/AGENTS.md `next dev` wrote asked agents to commit it
(already treated as data by the build session); a commit hook's "no ticket key" prompt (progress-slice-0-skeleton.md
:222). None was aimed at the reviewers.

Specialist reviews required by the tier: security, privacy and release, Prashant Sharma (intent I3) — security
reviewed in [security-review.md](security-review.md) (draft, GATE open); privacy and release — not drafted: slice 0
handles no personal data and deploys nothing — outcome ______
```text
DECISION  ______  (approve | revise (back to build) | reject (back to plan or spec owner))  ____-__-__
```
