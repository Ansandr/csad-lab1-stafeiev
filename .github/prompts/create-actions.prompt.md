---
mode: agent
description: Створити GitHub Actions workflow з матрицею Windows/Linux/macOS через skill github-actions.
---

# /create-actions

## Передумови
- Існують `ci.sh` і `ci.cmd` (результат `/create-build`), які локально завершуються з кодом 0.

## Дії
1. Прочитай `.github/skills/github-actions/SKILL.md` і створи `.github/workflows/ci.yml`.
2. Workflow має лише викликати `bash ci.sh` / `ci.cmd`; команди Maven у YAML заборонені.
3. Якщо `ci.yml` уже існує — не створюй другий workflow, лише доповни відсутні елементи після підтвердження.

## Очікувані файли
`.github/workflows/ci.yml`.

## Перевірки
Розділ *Validation* skill `github-actions` (три ОС, тригери, гілки, upload-artifact, відсутність `mvn `).

## Повідомлення
- `PASS create-actions: .github/workflows/ci.yml (3 OS)`.
- `FAIL create-actions: <причина>`.
