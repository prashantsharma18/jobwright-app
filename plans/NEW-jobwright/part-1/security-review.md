<!-- aidlc template: security-review -->
# Security review · NEW-jobwright · pull request #1 (part 1 of 4, slice 0)

## For the reviewer
- **Asked of:** The security champion (the required specialist), to clear or block the change; a code owner approves
- **Record it:** On the GATE line below, and in the pull request
- **Tier and main risk:** 3: a generator or template adds a package, file or setting the approved design does not name, and it reaches `main` unreviewed; second, CI permissions or an unpinned action
- **Changed since the last version:** first version

Drafted by aidlc-review, 2026-11-11, from the local security pass (its own context, AGENTS.md from `main`) and this
session's checks. A draft: the GATE line is the security champion's.

```text
Security review record · NEW-jobwright · pull request #1
SCOPE      Slice 0 (no spec criterion proved; harness for AC12, AC26, AC27; K2, U13). Bundles slice-0-scaffold
           (plan v1), slice-0-skeleton v3 (02a2cfb), slice-0-ci v4 and slice-0-ports v1 (6936a41). Plan v4.
           Sessions: the four build sessions of progress-slice-0-*.md. Head reviewed 7c02f5d.
REVIEWER   Prashant Sharma, security champion, also the author's director, tech lead and pusher (intent I3, KL2).
           Code owner approves; branch protection is not on (`main`: "Branch not protected"), so nothing enforces it.

1 INTENT   Matches plan v4. Decisions recorded with who took them (R1-R9, D1-D9, E1-E13); the delegated ones await
           confirmation (review-record M5). D6 approved in the pull request, reopened (review-record H2).
2 DIFF     90 files; every changed path inside slice-0-ci v4's MAY CHANGE (compliance pass, FACT); AGENTS.md line 46
           only, in c54c922. No MUST NOT file touched (CLAUDE.md, CODEOWNERS, .claude/**, the two aidlc scripts,
           api/contract/**). Side effects: the repository was made public (E11).
3 TOOLS    NOT REVIEWED: the sessions' tool-call logs were not supplied. From the progress notes only: the sandbox
           denied the Docker socket (scaffold step 1); Prashant Sharma disabled the sandbox for check.sh (skeleton D8)
           and it is still off on this machine; npm left pnpm's install scripts unrun (E6). Needs the log from the
           person before this row can read ok.
4 TESTS    Trusted CI 42999475010: 16 executions, 16 passed, 0 skipped. No existing assertion changed (main had no
           tests). Diff inside MAY CHANGE. One loosened rule: D6 (review-record H2).
  SCANS    Secret: GitHub secret scanning and push protection enabled (API, 2026-11-11; non-provider patterns off);
           a manual `git log --all -p` scan before going public found nothing (E11). Dependency and SAST: not run
           (part 3: trivy, syft, gitleaks), accepted by Prashant Sharma. pnpm audit: minimatch moderate, deepmerge low,
           both development-only, deferred to part 3 with no review date.

SECRETS AND DATA        No secret in the diff; appsettings and launchSettings hold none; dev.sh's credentials
                        are random per run, mode 600 in a mode 700 temp folder, removed on exit. Gaps: *.pem,
                        *.key, *.pfx, *.p12 not ignored (L9); public CI traces later (L11)              finding (low)
PERMISSION BOUNDARIES   ci.yml `permissions: contents: read` at the top, inherited; no secrets; no
                        pull_request_target; persist-credentials: false; caches keyed by lock files and
                        scoped to the ref. Repository public and `main` unprotected: KL1 and KL4 (stored
                        token readable by any workflow) can now be closed on Free, before STAGING_TOKEN
                        exists (S2, below)                                                              finding (question)
TOOL CALLS              actionlint downloaded and checked by sha256; pnpm in Dockerfile.web installed
                        without an integrity check (L8); no `${{ }}` in any run:                         finding (low)
FILE CHANGES            Rollback: revert the merge; nothing deployed. No rule text weakened. Local agent
                        controls loosened outside the pull request: sandbox off, allowAllUnixSockets on,
                        `docker exec` reaches a k3d node past the kubectl deny (L19)                    finding (low, machine)
PACKAGE SUPPLY CHAIN    Every npm and NuGet direct dependency exact and at new-system.md v6's pins; every
                        `uses:` a 40-character SHA; every FROM by digest; build scripts blocked except the
                        allowlist. ArchUnitNET's five transitive packages outside the approved set (M4);
                        the SHA rule misses `.yaml` and absolute URLs (L2)                              finding (medium)
PROMPT AND CONTEXT      No instruction in the diff. E13 (`next dev` wrote an AGENTS.md asking agents to
                        commit it) treated as data and closed by `agentRules: false`                    ok
APPLICATION SECURITY    One production route, `/health/live`, answers "Healthy" with no detail; OpenAPI
                        only in Development; every host bind 127.0.0.1 on 15432, 18080, 15080, 15300.
                        Security headers, `poweredByHeader: false`, AllowedHosts are part 3's (AC14,
                        AC15, plan.md:521)                                                              ok (slice 0)

S2 (question, medium for part 3): ADR 0011 line 75 defers branch protection and a `main`-only environment for
   STAGING_TOKEN to GitHub Pro. On a public repository both are on Free now (docs.github.com, FACT per the security
   pass). Changing it changes ADR 0011 and spec KL1, KL4: it goes to aidlc-design (amendment) at the workspace root,
   not to this repository. E11 already raised it there. The setting "require approval for all outside
   collaborators" on fork runs is UNKNOWN.

5 GATE     ______  (reviewed, no open findings | revise | reject). Open before it can clear: TOOLS (log), M4,
           and the champion's ruling on S2.
```
