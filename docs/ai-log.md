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

## Повторний `/init` — 2026-11-18

| Крок | Статус | Перевірка / рішення |
|---|---|---|
| `/git-init` | SKIP | Репозиторій, `.gitignore` і `.gitattributes` вже відповідали вимогам |
| `/create-project` | SKIP | `App.java` і `docs/usage.md` вже відповідали skill |
| `/create-build` | PASS | Повторно запущено `ci.sh` і `ci.cmd`; 3 тести пройшли, launchers вивели `Hello, World!` |
| `/create-actions` | SKIP | Workflow уже містив потрібну матрицю, тригери й делегування скриптам |
| `/check` | PASS | `bash scripts/check.sh` повернув `CHECK RESULT: PASS (56 checks)` |

## Сесія GitHub Copilot — підсумок (2026-11-18)

- **Інструмент:** VS Code + GitHub Copilot Chat (план Copilot Student), агент `build-engineer` з `.github/agents/`,
  режим Interactive. Модель обрав Copilot Fusion: GPT-5.6 Luna.
- **Гілка:** `feature/copilot-run`, створена від `develop` (на `develop` були лише agent, skills і commands).
- **Промпти студента:**
  1. «Хто ти і що робиш?» (двічі; другий раз у новій сесії з уже обраним агентом).
  2. «Виконай команду /init строго за файлом .github/prompts/init.prompt.md».
  3. «Рев'ю: ci.sh і ci.cmd не створюють dist/hello і dist/hello.cmd, які вимагає
     .github/skills/build-and-test/SKILL.md (розділ Outputs). Виправ скрипти згідно skill, перезапусти їх і онови запис в docs/ai-log.md.»
  4. «Виконай команду /init ще раз строго за файлом .github/prompts/init.prompt.md».
- **Ключові відповіді:** перший `/init` — 48 кроків, 5 × PASS, `INIT RESULT: PASS`; повторний `/init` — 19 кроків,
  `git-init`, `create-project`, `create-actions` = SKIP, `create-build` і `check` = PASS, `INIT RESULT: PASS`.

### Помилки та розбіжності, знайдені під час сесії

| # | Що сталося | Рішення |
|---|---|---|
| 1 | Нова версія Copilot у VS Code показала «Review Migrations»: prompt files (`.github/prompts/*.prompt.md`) більше не є slash-командами, Copilot пропонує конвертувати їх у skills. `/init` як slash-команда не працює. | Міграцію не виконано, щоб зберегти структуру з методички і перевірки `check.sh`. Команди викликаються текстом із посиланням на файл команди. |
| 2 | На «Хто ти і що робиш?» агент відповів загально («AI-асистент, що використовує Copilot SDK…»), без ролі build engineer з manifest. | Зафіксовано як обмеження. Сам `/init` агент виконав строго за файлом оркестратора і skills. |
| 3 | Після першого `/init` `ci.sh`/`ci.cmd` не створювали `dist/hello` і `dist/hello.cmd`, які вимагає skill `build-and-test`. | Виправлено через Copilot (промпт 3), не вручну. |
| 4 | Copilot під час виконання натрапив на те, що Git Bash не приймає Windows `JAVA_HOME` через Unix-обгортку `mvn`. | Copilot сам переписав `ci.sh`: на Windows викликає `mvn.cmd` через `cmd.exe`. |
| 5 | Помилка `check.sh` на `develop` (хибне «BasicAddition test not executed», див. еталонну гілку) на коді Copilot не відтворилась: `CHECK RESULT: PASS (56 checks)`. | Перевірено `bash scripts/check.sh` студентом. |
| 6 | Повторний `/init` змінює лише `docs/ai-log.md` (правило 6 оркестратора — запис у журнал), тому `git status` показує один змінений файл, а не порожній. `create-build` повертає PASS, бо крок повторно запускає скрипти як перевірку. | Поведінку прийнято як задуману; в інших файлах змін немає. |

### Порівняння з еталоном `feature/hello-java`

`git diff feature/hello-java --stat`: 8 файлів, +98 / −122 (повний вивід — `outputs/copilot_vs_reference_diff.txt`).

- `App.java` — ідентичний еталону.
- `pom.xml` — версія `1.0-SNAPSHOT` замість `1.0.0`; старіші плагіни (compiler 3.14.0, surefire 3.5.3, jar 3.4.2).
- `ci.sh` — вибір `mvn.cmd` на Windows, нормалізація CRLF; **немає `rm -rf dist`** перед складанням,
  тобто виправлення «застарілого артефакту» з еталона Copilot не відтворив.
- `ci.yml` — та сама матриця і тригери, але job має назву `Build and test (<os>)` замість `build-test (<os>)`,
  без кешу Maven і без вивантаження звітів тестів.
- `BasicAdditionTest.java` — ті самі три випадки, інша структура тесту.

