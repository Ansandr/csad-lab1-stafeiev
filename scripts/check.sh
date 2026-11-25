#!/usr/bin/env bash
# Read-only verification used by the /check command of the build-engineer agent.
# Prints one line per check and "CHECK RESULT: PASS|FAIL" at the end; exit code 0 = all passed.
# It never edits tracked files; it only builds into the git-ignored target/ and dist/ folders.
set -u
cd "$(dirname "$0")/.." || exit 2

pass=0; fail=0
ok()  { echo "  [PASS] $1"; pass=$((pass + 1)); }
bad() { echo "  [FAIL] $1"; fail=$((fail + 1)); }
has() { grep -q -- "$2" "$1" 2>/dev/null; }

REQUIRED_FILES=(
  .github/agents/build-engineer.agent.md
  .github/skills/project-scaffold/SKILL.md
  .github/skills/build-and-test/SKILL.md
  .github/skills/github-actions/SKILL.md
  .github/prompts/git-init.prompt.md
  .github/prompts/create-project.prompt.md
  .github/prompts/create-build.prompt.md
  .github/prompts/create-actions.prompt.md
  .github/prompts/check.prompt.md
  .github/prompts/init.prompt.md
  .github/workflows/ci.yml
  src/ua/lpnu/csad/hello/App.java
  tests/ua/lpnu/csad/hello/BasicAdditionTest.java
  pom.xml ci.sh ci.cmd
  docs/architecture.md docs/usage.md docs/ai-log.md
  README.md .gitignore
)

status_before=$(git status --porcelain 2>/dev/null)

echo "== 1. Structure"
for f in "${REQUIRED_FILES[@]}"; do
  [ -f "$f" ] && ok "exists: $f" || bad "missing: $f"
done

echo "== 2. Agent manifest"
m=.github/agents/build-engineer.agent.md
for s in "## Роль" "## Область відповідальності" "## Заборонені дії" "## Критерії успішного завершення"; do
  has "$m" "$s" && ok "manifest has '$s'" || bad "manifest lacks '$s'"
done

echo "== 3. Skills"
for sk in project-scaffold build-and-test github-actions; do
  f=.github/skills/$sk/SKILL.md
  for s in "## Призначення" "## Вхідні дані" "## Вихідні файли" "## Validation" "## Приклад" "## Обробка помилок"; do
    has "$f" "$s" || { bad "$sk lacks '$s'"; continue 2; }
  done
  ok "$sk has purpose/inputs/outputs/validation/example/errors"
done

echo "== 4. Commands"
for c in git-init create-project create-build create-actions check; do
  f=.github/prompts/$c.prompt.md
  for s in "## Передумови" "## Дії" "## Очікувані файли" "## Повідомлення"; do
    has "$f" "$s" || { bad "/$c lacks '$s'"; continue 2; }
  done
  ok "/$c has prerequisites/actions/files/messages"
done
i=.github/prompts/init.prompt.md
order=$(grep -o -E '/(git-init|create-project|create-build|create-actions|check)`' "$i" 2>/dev/null | head -5 | tr -d '`' | tr '\n' ' ')
[ "$order" = "/git-init /create-project /create-build /create-actions /check " ] \
  && ok "init order: $order" || bad "init order wrong: '$order'"
has "$i" "Зупинись на першому" && ok "init stops on first FAIL" || bad "init has no stop-on-error rule"

echo "== 5. Workflow"
w=.github/workflows/ci.yml
for s in ubuntu-latest windows-latest macos-latest push pull_request develop master "ci.sh" "ci.cmd" upload-artifact matrix; do
  has "$w" "$s" && ok "ci.yml contains '$s'" || bad "ci.yml lacks '$s'"
done
grep -q -E '(^|[^a-z])mvn ' "$w" 2>/dev/null && bad "ci.yml calls Maven directly (must delegate to scripts)" || ok "ci.yml delegates build to scripts"

echo "== 6. Build and tests (bash ci.sh)"
if [ -f ci.sh ]; then
  log=$(bash ci.sh 2>&1); rc=$?
  echo "$log" | grep -E 'Tests run:|BasicAddition|Hello, World!|BUILD|\[ci\]' | sed 's/^/      /'
  [ $rc -eq 0 ] && ok "ci.sh exit code 0" || bad "ci.sh exit code $rc"
  echo "$log" | grep -q 'BasicAdditionTest' && ok "BasicAddition test executed" || bad "BasicAddition test not executed"
  echo "$log" | grep -q -E 'Tests run: [1-9][0-9]*, Failures: 0, Errors: 0' && ok "tests passed" || bad "tests failed or none ran"
  [ -f dist/hello.jar ] && ok "artifact dist/hello.jar" || bad "artifact dist/hello.jar missing"
  echo "$log" | grep -qx 'Hello, World!' && ok "hello prints 'Hello, World!'" || bad "hello output mismatch"
else
  bad "ci.sh missing, build not run"
fi

echo "== 7. Git hygiene"
tracked=$(git ls-files 2>/dev/null)
echo "$tracked" | grep -q -E '^(target|build|dist)/' && bad "build output tracked by Git" || ok "no target/build/dist in Git"
echo "$tracked" | grep -q -E '(^|/)\.env$|\.pem$|\.key$' && bad "secret-like file tracked" || ok "no secret files tracked"
grep -r -I -l -E 'ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}' -- $tracked 2>/dev/null | grep -q . \
  && bad "token-like string found in tracked files" || ok "no GitHub tokens in tracked files"
[ "$(git status --porcelain 2>/dev/null)" = "$status_before" ] && ok "check did not modify tracked files" || bad "working tree changed during check"

total=$((pass + fail))
echo
if [ $fail -eq 0 ]; then
  echo "CHECK RESULT: PASS ($total checks)"; exit 0
else
  echo "CHECK RESULT: FAIL ($fail of $total checks failed)"; exit 1
fi
