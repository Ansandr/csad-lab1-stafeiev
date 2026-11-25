---
mode: agent
description: Перевірити структуру агента, проєкт, складання, тести і workflow, нічого не змінюючи.
---

# /check  (read-only)

## Передумови
- Доступний `bash` (Linux/macOS або Git Bash у Windows), JDK 17+ і Maven.

## Дії
1. **Не змінюй жодних файлів проєкту чи конфігурації.** Дозволено лише створення ігнорованих `target/` і `dist/`.
2. Виконай `bash scripts/check.sh` і покажи повний вивід.
3. Додатково переглянь вручну, що manifest, кожен skill і кожна command мають усі обов’язкові розділи.

## Що перевіряє `scripts/check.sh`
- наявність manifest, трьох skills, шести commands, документації;
- розділи manifest (роль, заборонені дії, критерії завершення) і skills (призначення, входи, виходи, validation, приклад, помилки);
- порядок викликів у `init.prompt.md`;
- `ci.yml`: три ОС, `push`, `pull_request`, `develop`, `master`, виклик скриптів, відсутність `mvn `;
- складання і тести через `ci.sh` (тест `BasicAddition`), вивід `Hello, World!`;
- відсутність `target/`, `build/`, `dist/` і секретів у `git ls-files`.

## Очікувані файли
Жодних нових відстежуваних файлів.

## Повідомлення
- Останній рядок: `CHECK RESULT: PASS (<n> checks)` або `CHECK RESULT: FAIL (<k> of <n> checks failed)`; код виходу 0 або 1.
- Не інтерпретуй FAIL як успіх і не «виправляй» перевірку.
