#!/usr/bin/env bash
# The repository's checks, as new-system.md COMMANDS writes them: scripts/check.sh test | lint | build
set -euo pipefail

# Tool telemetry off: these tools send usage data to their vendors by default (plan Q13).
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export TESTINGPLATFORM_TELEMETRY_OPTOUT=1
export NEXT_TELEMETRY_DISABLED=1

cd "$(dirname "$0")/.."

case "${1:-}" in
  test)
    pnpm -C web test && dotnet test api/Jobwright.slnx
    ;;
  lint)
    pnpm -C web lint && pnpm -C web format:check && pnpm -C web typecheck &&
      dotnet format api/Jobwright.slnx --verify-no-changes
    ;;
  build)
    # The three docker builds join in slice-0-ci.
    pnpm -C web build && dotnet build api/Jobwright.slnx -c Release
    ;;
  *)
    echo "usage: scripts/check.sh test|lint|build" >&2
    exit 2
    ;;
esac
