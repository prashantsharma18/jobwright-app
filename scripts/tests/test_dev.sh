#!/usr/bin/env bash
# Tests of scripts/dev.sh's refusals, with fake docker, dotnet and pnpm on PATH, so no container or process starts.
# Run: scripts/tests/test_dev.sh
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
dev_sh="$repo/scripts/dev.sh"
passed=0
failed=0

# A fresh fake bin directory per test. The fake docker logs every call to $work/calls and answers `ps` from
# $work/ps_output; FAKE_DOCKER_DOWN=1 makes every call fail, as a stopped daemon does.
setup() {
  work="$(mktemp -d)"
  mkdir "$work/bin"
  : >"$work/calls"
  : >"$work/ps_output"
  cat >"$work/bin/docker" <<EOF
#!/usr/bin/env bash
echo "docker \$*" >>"$work/calls"
if [ "\${FAKE_DOCKER_DOWN:-0}" = 1 ]; then
  echo "Cannot connect to the Docker daemon at unix:///var/run/docker.sock" >&2
  exit 1
fi
case "\$1" in
  ps) cat "$work/ps_output" ;;
esac
exit 0
EOF
  for tool in dotnet pnpm; do
    printf '#!/usr/bin/env bash\necho "%s $*" >>"%s/calls"\n' "$tool" "$work" >"$work/bin/$tool"
  done
  chmod +x "$work/bin/"*
}

teardown() {
  rm -rf "$work"
}

# Runs dev.sh with only the fake tools and the system's own directories on PATH; sets $status and $output.
run_dev() {
  set +e
  output="$(PATH="$work/bin:/usr/bin:/bin" "$@" "$dev_sh" 2>&1)"
  status=$?
  set -e
}

check() {
  local name="$1"
  shift
  if "$@"; then
    passed=$((passed + 1))
    echo "ok   $name"
  else
    failed=$((failed + 1))
    echo "FAIL $name"
    echo "     exit status: $status"
    echo "     output: $output"
    echo "     calls: $(tr '\n' ';' <"$work/calls")"
  fi
}

started_nothing() {
  ! grep -q -E '^docker (run|create|start)|^dotnet |^pnpm ' "$work/calls"
}

refuses_k3d() {
  local case_ok=0
  # By name: a k3d server container, no labels shown
  echo "k3d-jobwright-server-0	" >"$work/ps_output"
  run_dev env
  [ "$status" -ne 0 ] && grep -q -i k3d <<<"$output" && started_nothing || case_ok=1
  # By label only: a renamed cluster still carries k3d's runtime label
  : >"$work/calls"
  echo "renamed-node	app=k3d,k3d.cluster=jobwright,k3d.role=server" >"$work/ps_output"
  run_dev env
  [ "$status" -ne 0 ] && grep -q -i k3d <<<"$output" && started_nothing || case_ok=1
  return "$case_ok"
}

refuses_silent_docker() {
  run_dev env FAKE_DOCKER_DOWN=1
  [ "$status" -ne 0 ] && grep -q -i docker <<<"$output" && started_nothing
}

names_taken_port() {
  local listener ready=1
  python3 -c '
import socket, sys, time
s = socket.socket()
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind(("127.0.0.1", 15432))
s.listen()
open(sys.argv[1], "w").close()
time.sleep(30)
' "$work/listening" &
  listener=$!
  for _ in $(seq 50); do
    if [ -e "$work/listening" ]; then ready=0; break; fi
    sleep 0.1
  done
  run_dev env
  kill "$listener" 2>/dev/null || true
  wait "$listener" 2>/dev/null || true
  [ "$ready" -eq 0 ] && [ "$status" -ne 0 ] && grep -q 15432 <<<"$output" && started_nothing
}

for test in "refuses while a k3d cluster runs:refuses_k3d" \
  "refuses when docker does not answer:refuses_silent_docker" \
  "fails naming the port when 15432 is taken:names_taken_port"; do
  setup
  status=0
  output=""
  check "${test%%:*}" "${test##*:}"
  teardown
done

echo "test_dev.sh: $passed passed, $failed failed"
[ "$failed" -eq 0 ]
