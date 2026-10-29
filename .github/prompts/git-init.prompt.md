---
mode: agent
description: Перевірити Git-репозиторій, створити/оновити .gitignore, показати стан Git.
---

# /git-init

Ти працюєш як агент `build-engineer` (див. `.github/agents/build-engineer.agent.md`).

## Передумови
- Встановлено Git; VS Code відкрито в корені репозиторію.

## Дії
1. Виконай `git rev-parse --is-inside-work-tree`. Якщо результат не `true` — виконай `git init -b master`
   (лише якщо каталог ще не є репозиторієм).
2. Переконайся, що `.gitignore` містить рядки `target/`, `build/`, `dist/`, `*.log`, `.env`, `*.key`, `*.pem`.
   Додай **лише відсутні** рядки, нічого не видаляй і не дублюй.
3. Переконайся, що `.gitattributes` задає `eol=lf` для `*.sh` (через `* text=auto eol=lf`) і `eol=crlf` для `*.cmd`.
4. Виведи `git branch --show-current` і `git status --short`.

## Очікувані файли
`.gitignore`, `.gitattributes`.

## Перевірки
- `git rev-parse --is-inside-work-tree` → `true`.
- `grep -c '^target/$' .gitignore` → `1`.

## Повідомлення
- Успіх: `PASS git-init: branch=<name>, .gitignore ok`.
- Помилка: `FAIL git-init: <причина>` (наприклад, Git не встановлено). Не виконуй `git reset`, `git clean`, `push`.
