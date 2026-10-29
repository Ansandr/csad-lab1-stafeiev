---
mode: agent
description: Створити початковий Java Hello World проєкт через skill project-scaffold.
---

# /create-project

## Передумови
- `/git-init` повернув PASS.

## Дії
1. Прочитай `.github/skills/project-scaffold/SKILL.md` і виконай його з параметрами
   `language=java`, `project_name=hello`, `java_package=ua.lpnu.csad.hello`.
2. Якщо `src/ua/lpnu/csad/hello/App.java` уже існує і відповідає шаблону — нічого не змінюй (`SKIP`).
3. Додай до `docs/usage.md` розділ «Запуск проєкту», якщо його ще немає.

## Очікувані файли
`src/ua/lpnu/csad/hello/App.java`, `tests/`, `docs/usage.md`.

## Перевірки
Розділ *Validation* skill `project-scaffold`.

## Повідомлення
- `PASS create-project: src/ua/lpnu/csad/hello/App.java` або `SKIP create-project: already up to date`.
- `FAIL create-project: <причина>` — оркестратор зупиняється.
