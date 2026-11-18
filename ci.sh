#!/usr/bin/env bash
set -euo pipefail

echo "[ci] building and testing"
if command -v mvn.cmd >/dev/null 2>&1; then
  cmd.exe /d /c mvn -B -ntp clean test package
else
  mvn -B -ntp clean test package
fi

mkdir -p dist
cp target/hello.jar dist/hello.jar
cat > dist/hello <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
java_command=java
jar_path="$script_dir/hello.jar"
if command -v java.exe >/dev/null 2>&1; then
  java_command=java.exe
  if command -v wslpath >/dev/null 2>&1; then
    jar_path="$(wslpath -w "$jar_path")"
  elif command -v cygpath >/dev/null 2>&1; then
    jar_path="$(cygpath -w "$jar_path")"
  fi
fi
exec "$java_command" -jar "$jar_path" "$@"
EOF
chmod +x dist/hello
echo "[ci] artifact: dist/hello.jar"

java_command=java
if command -v java.exe >/dev/null 2>&1; then
  java_command=java.exe
fi
output="$("$java_command" -jar dist/hello.jar)"
output="${output%$'\r'}"
printf '%s\n' "$output"
if [[ "$output" != "Hello, World!" ]]; then
  echo "[ci] smoke test output mismatch" >&2
  exit 1
fi

echo "[ci] SUCCESS"
