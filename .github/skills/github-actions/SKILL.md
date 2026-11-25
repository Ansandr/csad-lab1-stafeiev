---
name: github-actions
description: Створює .github/workflows/ci.yml з однією job і матрицею ubuntu/windows/macos, яка лише викликає ci.sh / ci.cmd і зберігає hello.jar як артефакт. Використовуй для команди /create-actions.
---

# Skill: github-actions

## Призначення

Налаштувати CI у GitHub Actions: при кожному `push` і `pull_request` у гілки `develop` або
`master` проєкт складається і тестується на Windows, Linux і macOS, а виконуваний артефакт
зберігається для завантаження.

## Вхідні дані

| Параметр | Значення |
|---|---|
| команди складання | `bash ci.sh` (Linux/macOS), `ci.cmd` (Windows) — результат `build-and-test` |
| ОС | `ubuntu-latest`, `windows-latest`, `macos-latest` |
| гілки | `develop`, `master` |
| JDK | Temurin 21 через `actions/setup-java@v4` (конфігурація середовища) |
| артефакт | `dist/` → `hello-${{ matrix.os }}` |

## Вихідні файли

`.github/workflows/ci.yml`.

## Правила

- Одна job `build-test` з `strategy.matrix.os` і `fail-fast: false` (щоб бачити результат усіх ОС).
- Кроки: checkout → setup-java (конфігурація) → запуск скрипта (складання + тести) → upload-artifact.
- **YAML не містить команд Maven**: складання виконують тільки `ci.sh`/`ci.cmd`.
- Жодних секретів чи токенів у workflow; `permissions: contents: read`.

## Validation

1. YAML синтаксично коректний (наприклад, `python -c "import yaml,sys;yaml.safe_load(open('.github/workflows/ci.yml'))"`
   або перегляд у вкладці Actions).
2. Файл містить `ubuntu-latest`, `windows-latest`, `macos-latest`, `push`, `pull_request`,
   `develop`, `master`, `ci.sh`, `ci.cmd`, `upload-artifact`.
3. Файл не містить `mvn ` (складання делеговано скриптам).
4. Після push на GitHub — три зелені job і три артефакти `hello-<os>`.

## Приклад

Вхід: скрипти `ci.sh`, `ci.cmd`. Результат: workflow «CI» з job
`build-test (ubuntu-latest)`, `build-test (windows-latest)`, `build-test (macos-latest)`.

## Обробка помилок

| Ситуація | Дія |
|---|---|
| `ci.yml` уже існує | не створювати другий workflow; оновити лише відсутні ОС/тригери після підтвердження |
| `Permission denied` для `ci.sh` на Linux/macOS | викликати через `bash ci.sh` (не залежить від біта виконання) |
| Job на одній ОС падає | не видаляти ОС з матриці; відкрити лог, виправити скрипт/код, повторити |
| Артефакт порожній | перевірити, що скрипт копіює `hello.jar` у `dist/` до кроку upload |
