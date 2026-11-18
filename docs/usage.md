# Використання

## 1. Запуск AI-агента (GitHub Copilot у VS Code)

Передумови: VS Code, розширення **GitHub Copilot** і **GitHub Copilot Chat**, вхід під акаунтом
зі студентським планом Copilot; Git, JDK 17+ (перевірено з Temurin 25), Maven 3.9+.

```bash
git clone https://github.com/<github-user>/csad-lab1-stafeiev.git
cd csad-lab1-stafeiev
git switch develop                 # стан «лише агент»
git switch -c feature/hello-java   # нова гілка для результату
code .
```

У VS Code: Copilot Chat → режим **Agent** → у списку агентів вибрати **build-engineer** →
ввести `/init`. Окремі кроки: `/git-init`, `/create-project`, `/create-build`, `/create-actions`,
`/check`. Агент показує зміни; після перегляду натиснути **Keep**, потім закомітити.

## 2. Незалежна перевірка (`/check` без AI)

```bash
bash scripts/check.sh      # Linux/macOS або Git Bash у Windows
```

Останній рядок — `CHECK RESULT: PASS (N checks)` або `CHECK RESULT: FAIL (...)`, код виходу 0/1.

## 3. Запуск проєкту

Після складання запустіть застосунок:

```bash
java -jar dist/hello.jar
```
