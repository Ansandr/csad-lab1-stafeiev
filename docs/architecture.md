# Архітектура агента build-engineer

## Яку проблему вирішує агент

Ручне створення навіть найпростішого проєкту з CI вимагає узгодити багато файлів:
код, тест, `pom.xml`, скрипти складання для різних ОС, workflow GitHub Actions,
`.gitignore` і документацію. Помилки (тест не запускається, build-каталог потрапив у Git,
CI вбудовує команди складання прямо в YAML, відсутня одна з ОС) легко пропустити.
Агент розбиває цю роботу на повторювані, перевірювані кроки і завжди завершує її
незалежною перевіркою `check`.

## Складові та відповідність файлів (VS Code + GitHub Copilot)

| Роль у методичці | Файл | Формат Copilot |
|---|---|---|
| Agent manifest | `.github/agents/build-engineer.agent.md` | custom agent (`*.agent.md`, YAML front matter) |
| Skill «створення проєкту» | `.github/skills/project-scaffold/SKILL.md` | agent skill (`SKILL.md`) |
| Skill «складання і тестування» | `.github/skills/build-and-test/SKILL.md` | agent skill |
| Skill «GitHub Actions» | `.github/skills/github-actions/SKILL.md` | agent skill |
| Commands | `.github/prompts/<name>.prompt.md` | prompt files, виклик `/<name>` у Copilot Chat |
| Orchestrator | `.github/prompts/init.prompt.md` | prompt file `/init` |
| Детермінована перевірка | `scripts/check.sh` | bash-скрипт, викликається з `/check` |

Методичка рекомендує `CMakeLists.txt` (варіант C++). Для варіанта Java його роль виконує
`pom.xml`, виконуваний файл `hello` — `dist/hello.jar` (+ запускачі `dist/hello`, `dist/hello.cmd`),
тест `BasicAddition` — клас `tests/ua/lpnu/csad/hello/BasicAdditionTest.java`.

## Схема взаємодії

```text
 Користувач ──/init──► init.prompt.md (orchestrator)
                         │ 1 /git-init ──────────► git status, .gitignore
                         │ 2 /create-project ────► skill project-scaffold ──► src/, README, docs/usage.md
                         │ 3 /create-build ──────► skill build-and-test ───► pom.xml, tests/, ci.sh, ci.cmd
                         │ 4 /create-actions ────► skill github-actions ───► .github/workflows/ci.yml
                         │ 5 /check (read-only) ─► scripts/check.sh ────────► CHECK RESULT: PASS/FAIL
                         ▼
                 підсумковий звіт (таблиця кроків, статус, наступні дії)
```

## Дані, що передаються між етапами

| Етап | Вхід | Вихід (передається далі) |
|---|---|---|
| git-init | корінь репозиторію | підтвердження Git-репозиторію, поточна гілка, `.gitignore` |
| create-project | `language=java`, `project_name=hello`, `java_package` | шлях до `src/.../App.java`, головний клас `ua.lpnu.csad.hello.App` |
| create-build | головний клас, пакет, `java_release` | `pom.xml`, тест, команди `./ci.sh` / `ci.cmd`, шлях артефакту `dist/hello.jar` |
| create-actions | команди CI-скриптів, список ОС, гілки | `.github/workflows/ci.yml`, імена артефактів `hello-<os>` |
| check | усі попередні файли | звіт `PASS`/`FAIL` з переліком перевірок |

## Обробка помилок оркестратором

- Перед кожним кроком перевіряються передумови (наприклад, `create-build` вимагає `App.java`).
- Кожен крок завершується перевіркою свого skill; при невдачі крок повертає `FAIL: <причина>`.
- Оркестратор **зупиняється на першому FAIL**, не запускає наступні кроки і не оголошує успіх.
- `check` ніколи не змінює файли проєкту; він лише читає їх, складає у тимчасовому `target/`
  і повертає ненульовий код виходу при будь-якій невдалій перевірці.
- Повторний запуск `/init` безпечний: skills перевіряють, чи файл уже існує і відповідає
  шаблону, і пропускають такий крок (`SKIP: already up to date`).
