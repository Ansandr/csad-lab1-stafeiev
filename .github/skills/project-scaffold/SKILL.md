---
name: project-scaffold
description: Створює мінімальний Java Hello World проєкт (src/, tests/, docs/usage.md, README, .gitignore). Використовуй для команди /create-project.
---

# Skill: project-scaffold

## Призначення

Створити початкову структуру мінімального кросплатформного проєкту Hello World на Java:
каталоги, головний клас із функцією `add`, README-розділ про проєкт і початковий `.gitignore`.

## Коли застосовувати

- Команда `/create-project` або крок 2 оркестратора `/init`.
- Репозиторій порожній або не містить `src/ua/lpnu/csad/hello/App.java`.

## Вхідні дані

| Параметр | Обов’язковий | За замовчуванням |
|---|---|---|
| `language` | так | `java` (інші значення → FAIL, цей агент підтримує лише Java) |
| `project_name` | так | `hello` |
| `java_package` | ні | `ua.lpnu.csad.hello` |

## Вихідні файли

| Файл | Вміст |
|---|---|
| `src/ua/lpnu/csad/hello/App.java` | `public static int add(int a, int b)`, `main` друкує `Hello, World!` |
| `tests/` | порожній каталог-заготовка (тест додає `build-and-test`) |
| `docs/usage.md` | розділ «Запуск проєкту» (додається, якщо відсутній) |
| `.gitignore` | рядки `target/`, `build/`, `dist/`, `*.log`, `.env` (лише відсутні) |

Шаблон `App.java`:

```java
package ua.lpnu.csad.hello;

/** Minimal cross-platform Hello World application. */
public final class App {
    private App() { }

    /** Returns the sum of two integers (unit-tested by BasicAddition). */
    public static int add(int a, int b) {
        return a + b;
    }

    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

## Validation

1. Файл `src/ua/lpnu/csad/hello/App.java` існує і містить `package ua.lpnu.csad.hello;`,
   `static int add(` та `Hello, World!`.
2. Команда запуску відома і записана в `docs/usage.md`: `java -jar dist/hello.jar`.
3. `.gitignore` містить `target/` рівно один раз (`grep -c '^target/$' .gitignore` → `1`).

## Приклад

Вхід: `language=java, project_name=hello`.
Очікуваний результат: створено `src/ua/lpnu/csad/hello/App.java`, у `.gitignore` додано
відсутні рядки, повідомлення `PASS project-scaffold: src/ua/lpnu/csad/hello/App.java`.

## Обробка помилок

| Ситуація | Дія |
|---|---|
| `language` ≠ `java` | `FAIL: unsupported language` — нічого не створювати |
| `App.java` існує і збігається з шаблоном | `SKIP: already up to date` |
| `App.java` існує, але відрізняється | показати diff, не перезаписувати без підтвердження |
| Немає прав на запис / не Git-репозиторій | `FAIL` з текстом помилки, зупинити оркестратор |

Типовий сценарій помилки: агент створює `src/main/java/...` (стандартний макет Maven) замість
`src/...`; перевірка 1 повертає FAIL, бо шлях не збігається з тим, який очікує `pom.xml`
(`<sourceDirectory>src</sourceDirectory>`).
