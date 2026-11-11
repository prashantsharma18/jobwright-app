#!/usr/bin/env bash
# The repository's checks, as new-system.md COMMANDS writes them: scripts/check.sh test | lint | build,
# and CI's browser and budget gates: scripts/check.sh browser | budget (both build the web app first)
set -euo pipefail

# Tool telemetry off: these tools send usage data to their vendors by default (plan Q13).
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export TESTINGPLATFORM_TELEMETRY_OPTOUT=1
export NEXT_TELEMETRY_DISABLED=1

cd "$(dirname "$0")/.."

case "${1:-}" in
  test)
    pnpm -C web test && dotnet test api/Jobwright.slnx && scripts/tests/test_dev.sh
    ;;
  lint)
    pnpm -C web lint && pnpm -C web format:check && pnpm -C web typecheck &&
      dotnet format api/Jobwright.slnx --verify-no-changes
    ;;
  build)
    pnpm -C web build && dotnet build api/Jobwright.slnx -c Release &&
      docker build -f Dockerfile.web -t jobwright-web:local . &&
      docker build -f Dockerfile.api -t jobwright-api:local . &&
      docker build -f Dockerfile.worker -t jobwright-worker:local .
    ;;
  browser)
    # The page check and the AC12 axe scan: 360 and 1440 px, light and dark.
    pnpm -C web build &&
      pnpm -C web exec playwright test --project=360-light --project=360-dark --project=1440-light --project=1440-dark
    ;;
  budget)
    # AC26: the first load's script bytes against the budget.
    pnpm -C web build && pnpm -C web exec playwright test --project=budget
    ;;
  *)
    echo "usage: scripts/check.sh test|lint|build|browser|budget" >&2
    exit 2
    ;;
esac
