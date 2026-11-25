---
mode: agent
description: Оркестратор — послідовно запускає git-init, create-project, create-build, create-actions і check та зупиняється на першій помилці.
---

# /init  (orchestrator)

Ти — агент `build-engineer`. Виконай повний сценарій строго в такому порядку:

| Крок | Command | Передає далі |
|---|---|---|
| 1 | `/git-init` (`.github/prompts/git-init.prompt.md`) | гілка, `.gitignore` |
| 2 | `/create-project` (`.github/prompts/create-project.prompt.md`) | головний клас `ua.lpnu.csad.hello.App` |
| 3 | `/create-build` (`.github/prompts/create-build.prompt.md`) | `ci.sh`, `ci.cmd`, `dist/hello.jar` |
| 4 | `/create-actions` (`.github/prompts/create-actions.prompt.md`) | `.github/workflows/ci.yml` |
| 5 | `/check` (`.github/prompts/check.prompt.md`) | `CHECK RESULT` |

## Правила
1. Перед кожним кроком перевір його передумови. Якщо вони не виконані — `FAIL`.
2. Після кожного кроку виведи один рядок статусу: `PASS`, `SKIP` або `FAIL` з причиною.
3. **Зупинись на першому `FAIL`**: не запускай наступні кроки і не повідомляй про успіх.
4. Повторний запуск не повинен руйнувати чи дублювати файли: кроки, результат яких уже відповідає skill, повертають `SKIP`.
5. Не виконуй `git push`, не створюй PR, не змінюй налаштування GitHub.
6. Додай у `docs/ai-log.md` короткий запис: дата, команда, статуси кроків, помилки і рішення.

## Підсумок
Виведи таблицю `Крок | Статус | Файли | Примітка` і останній рядок `INIT RESULT: PASS` лише якщо `/check` повернув `CHECK RESULT: PASS`; інакше `INIT RESULT: FAIL at <крок>`.
