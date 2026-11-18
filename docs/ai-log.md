# Журнал взаємодії з AI

Формат запису: дата · інструмент · запит (скорочено) · важлива відповідь/зміна · перевірка · рішення.
Секрети, токени й особисті дані в журнал не записуються.

> Примітка про чесність: чернетку агента в цьому репозиторії підготовлено за допомогою
> AI-асистента Claude Code (Anthropic). Методичка вимагає інструмент, визначений викладачем
> (GitHub Copilot). Тому студент повинен відтворити результат запуском `/init` у Copilot Chat
> на гілці, створеній від `develop`, і додати до журналу розділ «Сесія GitHub Copilot» нижче.

## Сесія 1 — проєктування агента (гілка develop)

| # | Запит | Результат | Перевірка / рішення |
|---|---|---|---|
| 1 | «Перетвори вимоги task1.pdf для варіанта Java/Maven/JUnit на структуру агента для VS Code Copilot» | Таблиця відповідності: manifest `.agent.md`, skills `SKILL.md`, commands `.prompt.md`, orchestrator `init` | Звірено з розділом 5 методички; відповідність записано в `docs/architecture.md` |
| 2 | «Напиши manifest build-engineer: роль, обмеження, заборонені дії, критерії завершення» | `.github/agents/build-engineer.agent.md` | Додано явну заборону `push --force`, створення PR і зміни тестів «щоб пройшли» |
| 3 | «Створи три skills з purpose/inputs/outputs/validation/example/failure handling» | `project-scaffold`, `build-and-test`, `github-actions` | Кожен skill містить типовий сценарій помилки |
| 4 | «Створи commands і оркестратор init, що зупиняється на першій помилці; check — лише читає» | 6 prompt files + `scripts/check.sh` | `check` порівнює `git status` до і після запуску, щоб довести, що нічого не змінює |

## Сесія `/init` — 2026-11-18

| Крок | Статус | Перевірка / рішення |
|---|---|---|
| `/git-init` | PASS | Git-репозиторій і `.gitignore` відповідали вимогам; змін не потрібно |
| `/create-project` | PASS | Створено `App.java`, `docs/usage.md` доповнено командою запуску |
| `/create-build` | PASS | Maven/JUnit: 3 тести без помилок; `ci.sh` і `ci.cmd` створили `dist/hello.jar`; smoke-тест вивів `Hello, World!` |
| `/create-actions` | PASS | Додано workflow з матрицею Ubuntu/Windows/macOS і делегуванням скриптам |
| `/check` | PASS | `bash scripts/check.sh` повернув `CHECK RESULT: PASS (56 checks)` |

Під час локальної перевірки Git Bash не приймав Windows-формат `JAVA_HOME` через Unix-обгортку
`mvn`; `ci.sh` обирає `mvn.cmd` через `cmd.exe` на Windows і нормалізує CRLF у smoke-виводі.

## Рев'ю артефактів CI — 2026-11-18

Виправлено `ci.sh` і `ci.cmd`: після копіювання JAR вони також створюють
`dist/hello` та `dist/hello.cmd`. Unix launcher визначає шлях до JAR відносно власного
каталогу й підтримує Windows path conversion через `wslpath`/`cygpath`; Windows launcher
використовує `%~dp0`.

Перевірка: `ci.sh`, `ci.cmd`, `dist/hello` і `dist/hello.cmd` завершилися з кодом 0;
тести `BasicAdditionTest` — 3/3 без помилок; усі launchers вивели `Hello, World!`.
