#!/usr/bin/env bash
# Runs Jobwright locally: PostgreSQL and Keycloak in containers, then the API and the web app on the host.
# Every port is bound to 127.0.0.1. Stop with Ctrl+C: the containers and the credentials are removed.
# Refuses while a k3d cluster runs (memory, requirements 9.5), and fails closed when docker does not answer.
set -euo pipefail

# Tool telemetry off: these tools send usage data to their vendors by default (plan Q13).
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export TESTINGPLATFORM_TELEMETRY_OPTOUT=1
export NEXT_TELEMETRY_DISABLED=1

cd "$(dirname "$0")/.."

# new-system.md Pinned versions; digests resolved from the registries (progress-slice-0-ci.md, step 1).
postgres_image="postgres:17.11@sha256:ff87138949ad9a46f32ff23bd6852b52ce024a13dffe9b4087be98292cdd3b4f"
keycloak_image="quay.io/keycloak/keycloak:26.8.2@sha256:723b1d6e254c0fc96d5cffec860c7e0744d6a3277822b865bb538cf891575e41"
postgres_port=55432
keycloak_port=58080
api_port=55080
web_port=55300

fail() {
  echo "dev.sh: $*" >&2
  exit 1
}

if ! running="$(docker ps --format '{{.Names}}	{{.Labels}}' 2>/dev/null)"; then
  fail "docker does not answer, so a running k3d cluster cannot be ruled out; start Docker and try again"
fi
# k3d names its containers k3d-<cluster>-* and labels every one app=k3d and k3d.* (k3d v5.9.0, pkg/types).
if k3d="$(grep -E '^k3d-|[[:space:],]app=k3d(,|$)|[[:space:],]k3d\.' <<<"$running")"; then
  fail "a k3d cluster is running ($(cut -f1 <<<"$k3d" | paste -sd, -)); stop it first, the two do not fit in memory together"
fi

for port in "$postgres_port" "$keycloak_port" "$api_port" "$web_port"; do
  if (exec 3<>"/dev/tcp/127.0.0.1/$port") 2>/dev/null; then
    fail "port $port on 127.0.0.1 is taken; free it and try again"
  fi
done

started=()
process_groups=()
credentials="$(mktemp -d)"
cleanup() {
  trap - EXIT INT TERM
  local group
  # Each host process leads its own process group (setsid), so its children stop with it.
  for group in "${process_groups[@]}"; do kill -TERM -- "-$group" 2>/dev/null || true; done
  wait 2>/dev/null || true
  if [ "${#started[@]}" -gt 0 ]; then docker rm -f "${started[@]}" >/dev/null 2>&1 || true; fi
  rm -rf "$credentials"
}
trap cleanup EXIT
trap 'exit 130' INT TERM

# Throwaway credentials, new on every run, in files only this user can read; never in the repository.
chmod 700 "$credentials"
secret() { od -An -N24 -tx1 /dev/urandom | tr -d ' \n'; }
(
  umask 077
  printf 'POSTGRES_USER=jobwright\nPOSTGRES_DB=jobwright\nPOSTGRES_PASSWORD=%s\n' "$(secret)" >"$credentials/postgres.env"
  printf 'KC_BOOTSTRAP_ADMIN_USERNAME=admin\nKC_BOOTSTRAP_ADMIN_PASSWORD=%s\n' "$(secret)" >"$credentials/keycloak.env"
)

docker run -d --rm --name jobwright-dev-postgres --env-file "$credentials/postgres.env" \
  -p "127.0.0.1:$postgres_port:5432" "$postgres_image" >/dev/null
started+=(jobwright-dev-postgres)
docker run -d --rm --name jobwright-dev-keycloak --env-file "$credentials/keycloak.env" \
  -p "127.0.0.1:$keycloak_port:8080" "$keycloak_image" start-dev >/dev/null
started+=(jobwright-dev-keycloak)

for _ in $(seq 60); do
  if docker exec jobwright-dev-postgres pg_isready -q -h 127.0.0.1 -U jobwright 2>/dev/null; then break; fi
  sleep 1
done
docker exec jobwright-dev-postgres pg_isready -q -h 127.0.0.1 -U jobwright ||
  fail "PostgreSQL did not become ready within 60 seconds"

echo "dev.sh: PostgreSQL on 127.0.0.1:$postgres_port, Keycloak on http://127.0.0.1:$keycloak_port"
echo "dev.sh: this run's credentials are in $credentials (removed on exit)"

setsid dotnet run --project api/src/Jobwright.Api --launch-profile http &
process_groups+=($!)
setsid pnpm -C web dev &
process_groups+=($!)
echo "dev.sh: API on http://127.0.0.1:$api_port, web on http://127.0.0.1:$web_port; Ctrl+C stops everything"

# Stops everything as soon as either process ends.
wait -n
