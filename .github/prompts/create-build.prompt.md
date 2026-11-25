---
mode: agent
description: Створити Maven-складання, тест BasicAddition і скрипти ci.sh / ci.cmd через skill build-and-test.
---

# /create-build

## Передумови
- Існує `src/ua/lpnu/csad/hello/App.java` з функцією `add` (результат `/create-project`).
- Встановлено JDK 17+ і Maven 3.9+ (`java -version`, `mvn -v`).

## Дії
1. Прочитай `.github/skills/build-and-test/SKILL.md` і виконай підкоманди `build-config`, `unit-test`, `ci-scripts`.
2. Не дублюй залежності чи плагіни в `pom.xml`, якщо він уже існує.
3. Запусти `bash ci.sh` (Linux/macOS/Git Bash) або `ci.cmd` (Windows) і покажи підсумок тестів.

## Очікувані файли
`pom.xml`, `tests/ua/lpnu/csad/hello/BasicAdditionTest.java`, `ci.sh`, `ci.cmd`;
після запуску — `dist/hello.jar` (не комітиться).

## Перевірки
- Вивід Maven містить `Tests run:` з `Failures: 0, Errors: 0` і назву `BasicAdditionTest`.
- Скрипт завершився з кодом 0, `java -jar dist/hello.jar` → `Hello, World!`.

## Повідомлення
- `PASS create-build: tests=<N>, artifact=dist/hello.jar`.
- `FAIL create-build: <перший рядок помилки Maven>` — не змінюй тест, щоб приховати помилку.
