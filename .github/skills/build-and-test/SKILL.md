---
name: build-and-test
description: Налаштовує Maven-складання, юніт-тест JUnit 5 BasicAddition і локальні скрипти ci.sh / ci.cmd, що створюють dist/hello.jar. Використовуй для команди /create-build.
---

# Skill: build-and-test

## Призначення

Створити систему складання (Maven `pom.xml`), тестову функцію та юніт-тест `BasicAddition`,
а також локальні скрипти без аргументів `ci.sh` і `ci.cmd`, які виконують повний цикл:
компіляція → тести → пакування `hello.jar` → копіювання в `dist/` → smoke-запуск.

## Підкоманди

1. `build-config` — `pom.xml` (groupId `ua.lpnu.csad`, artifactId `hello`, `finalName=hello`,
   `sourceDirectory=src`, `testSourceDirectory=tests`, `maven.compiler.release=17`,
   `Main-Class: ua.lpnu.csad.hello.App`, JUnit Jupiter у scope `test`, версії плагінів зафіксовані).
2. `unit-test` — `tests/ua/lpnu/csad/hello/BasicAdditionTest.java` (`assertEquals(4, App.add(2, 2))`
   та граничні випадки).
3. `ci-scripts` — `ci.sh` (LF, `set -euo pipefail`) і `ci.cmd` (CRLF, перевірка `errorlevel`).

## Вхідні дані

| Параметр | Джерело |
|---|---|
| головний клас | результат `project-scaffold`: `ua.lpnu.csad.hello.App` |
| `java_release` | manifest, `17` |
| версія JUnit | `5.13.4` (фіксована, щоб складання було відтворюваним) |

## Вихідні файли

`pom.xml`, `tests/ua/lpnu/csad/hello/BasicAdditionTest.java`, `ci.sh`, `ci.cmd`.
Після запуску (не комітяться): `target/`, `dist/hello.jar`, `dist/hello`, `dist/hello.cmd`.

## Що роблять скрипти

```text
mvn -B -ntp clean test package   # компіляція + JUnit (BasicAddition) + hello.jar
mkdir dist; copy target/hello.jar dist/
java -jar dist/hello.jar         # має вивести Hello, World!
```

## Validation

1. `mvn -B -ntp test` → `Tests run: N, Failures: 0, Errors: 0` і в звіті є `BasicAdditionTest`.
2. `./ci.sh` (Linux/macOS) або `ci.cmd` (Windows) завершується з кодом 0.
3. Вивід `java -jar dist/hello.jar` дорівнює `Hello, World!`.
4. `git status --short` не показує `target/` чи `dist/` (вони в `.gitignore`).

## Приклад

Вхід: `App.java` з функцією `add`. Запуск: `./ci.sh`.
Очікуваний вивід (фрагмент):

```text
[INFO] Tests run: 3, Failures: 0, Errors: 0, Skipped: 0
[ci] artifact: dist/hello.jar
Hello, World!
[ci] SUCCESS
```

## Обробка помилок

| Ситуація | Дія |
|---|---|
| `mvn`/`java` не знайдено | `FAIL: toolchain missing` + підказка встановити JDK 17+ і Maven 3.9+ |
| Тест падає | скрипт повертає код ≠ 0; **заборонено** змінювати очікуване значення тесту, щоб він пройшов |
| `ci.sh` без прав виконання | `git update-index --chmod=+x ci.sh`; у CI викликати `bash ci.sh` |
| `pom.xml` вже існує | порівняти ключові елементи; не додавати залежність JUnit удруге |

Типовий сценарій помилки: без `testSourceDirectory=tests` Maven шукає тести в `src/test/java`,
виводить `No tests to run.` і завершується «успішно». Тому перевірка 1 вимагає `Tests run` ≥ 1.
