# csad-lab1-stafeiev — AI-агент Build Engineer для кросплатформного Hello World

| Поле | Значення |
|---|---|
| Студент | Стафеєв Андрій Андрійович |
| Група | КІ-407 |
| Номер у списку / варіант | 23 → варіант 5 таблиці ЛР1 (23 mod 6 = 5, припущення — підтвердити у викладача) |
| Мова / складання / тести | Java 17+ / Apache Maven / JUnit 5 |
| Дисципліна | Автоматизоване проєктування комп’ютерних систем (ЛР1) |

Репозиторій містить AI-агента `build-engineer` для GitHub Copilot у VS Code: manifest,
три skills, шість commands (prompt files) і оркестратор `init`. Агент генерує мінімальний
кросплатформний Java-проєкт Hello World, систему складання Maven, юніт-тест `BasicAddition`,
локальні скрипти `ci.sh`/`ci.cmd` і GitHub Actions workflow для Windows, Linux і macOS.

## Гілки

- `develop` — лише агент (manifest, skills, commands), документація і скрипт перевірки.
- `feature/hello-java` — повний результат запуску агента: код, тести, складання, CI.
- `master` — фінальна інтеграція після перевірки та схвалення PR.

## Як запустити агента

1. Відкрити репозиторій у VS Code, увійти в GitHub Copilot (студентський план).
2. Відкрити Copilot Chat, вибрати агента **build-engineer** (режим Agent).
3. Виконати команду `/init` (або послідовно `/git-init`, `/create-project`, `/create-build`,
   `/create-actions`, `/check`).
4. Переглянути зміни, прийняти їх і закомітити.

Детально: [docs/usage.md](docs/usage.md), архітектура: [docs/architecture.md](docs/architecture.md),
журнал AI: [docs/ai-log.md](docs/ai-log.md).
