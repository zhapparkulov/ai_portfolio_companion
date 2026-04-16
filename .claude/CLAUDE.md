# CLAUDE.md — правила проекта

Этот файл объясняет AI-ассистентам (Claude Code, Cursor, Copilot Chat и т.д.),
как работать внутри **AI Portfolio Companion**. Это единый источник правды
по соглашениям. Если есть сомнения, следуй этому файлу, а не поведению AI по умолчанию.

**Источник правды по архитектуре:** [`../docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md).
Не придумывай структуру заново; следуй ей.

---

## 0. Структура репозитория (не отклоняться)

```
ai_portfolio_companion/
├── mobile_app/       # Flutter-приложение — ВЕСЬ Dart-код живет в mobile_app/lib/
├── backend/          # FastAPI-бэкенд
├── docs/             # ARCHITECTURE.md и другие проектные документы
└── .claude/          # Этот файл + agents.md (конфиг AI-пайплайна)
```

**Никогда** не создавай верхнеуровневую `lib/` в корне репозитория. Flutter-код живет
только в `mobile_app/lib/`. Код бэкенда живет только в
`backend/app/`.

---

## 1. Необсуждаемые правила

1. **Никогда не ломай направление зависимостей.** `presentation → domain ← data`.
   Domain-код не должен импортировать Flutter, Dio или `data/`.
2. **Никакой бизнес-логики в виджетах или Cubits.** Виджеты отображают состояние.
   Cubits оркестрируют use cases. Бизнес-правила живут в use cases или services.
3. **Каждая фича — вертикальный срез** (`data/`, `domain/`, `presentation/`).
   Не создавай код фичи A внутри фичи B.
4. **Никаких импортов между фичами.** Если двум фичам нужен один и тот же код,
   вынеси его в `core/` или `shared/`.
5. **Источники mock-данных реализуют тот же контракт, что и настоящие.** Замена
   mock → real не должна трогать repositories, use cases или UI.
6. **Состояние Cubit всегда sealed union.** UI должен исчерпывающе делать `switch`
   по нему. Никаких комбинаций `isLoading` + `data?`.
7. **Не оставляй `print` или `debugPrint` в коде, который попадет в commit.** Используй logger.
8. **Никаких новых зависимостей без обновления `docs/ARCHITECTURE.md`**
   в разделе компромиссов.

---

## 2. Стек (не отклоняться без согласования)

- Flutter 3.19+, Dart 3.3+
- Состояние: `flutter_bloc` (Cubit предпочтительнее Bloc)
- DI: `get_it`
- HTTP: `dio`
- Сравнение: `equatable`
- Форматирование: `intl`
- Бэкенд: FastAPI, Pydantic v2

---

## 3. Соглашения по коду

### Dart / Flutter
- `const` constructors везде, где возможно.
- Предпочитай композицию наследованию; виджеты должны быть до ~150 строк
  или разбиты на части.
- Named parameters для публичных constructors с ≥ 2 аргументами.
- Публичный API документируется через `///`. Одно предложение, если нет тонкостей.
- По умолчанию `StatelessWidget`. `StatefulWidget` только для временного UI-состояния
  (controllers, animations). Состояние приложения → Cubit.
- Сопоставляй состояния через `switch` expressions, а не `if (state is ...)`.
- Маппинг ошибок живет в repositories, не в Cubits и не в виджетах.

### Imports
- Порядок: `dart:` → `package:` → relative. Пустая строка между группами.
- Всегда используй relative imports внутри `mobile_app/lib/`.

### Files и naming
- Имена файлов: `snake_case.dart`. Один публичный class на файл.
- Cubit pair: `foo_cubit.dart` с `part 'foo_state.dart';`.
- Суффикс entity → model: `Portfolio` (entity) / `PortfolioModel` (DTO).

---

## 4. Ожидания по тестам

- У каждого **use case** есть unit test с mocked repository.
- У каждого **Cubit** есть `bloc_test`, проверяющий emissions состояний для success + failure.
- Repositories тестируются с fake data source, который выбрасывает каждое exception.
- Widgets тестируются только для критичных branches (error view, empty state).
- Test files зеркалят `mobile_app/lib/` внутри `mobile_app/test/`.

---

## 5. Правила для AI

Когда AI-ассистент генерирует код в этом репозитории, он **обязан**:

1. Прочитать `docs/ARCHITECTURE.md` и этот файл перед созданием структурного кода.
2. Класть новый код в правильный слой. Если есть сомнения, спросить — не угадывать.
3. Повторять форму соседней фичи (например, копировать `features/portfolio/`
   при создании `features/chat/`).
4. Никогда не добавлять packages молча. Предложить, обосновать и остановиться
   для согласования перед изменением `mobile_app/pubspec.yaml` или `backend/requirements.txt`.
5. Писать tests вместе с нетривиальным кодом.
6. Для каждого изменения уровня PR выводить короткую заметку "architecture impact":
   какие слои изменились и почему.
7. Предпочитать изменение существующих файлов созданию новых, если код туда подходит.
8. Никогда не оставлять TODO без связанного ticket или объяснения.

### Запросы вне области ответственности
- "Быстро добавь state в этот widget" → отказать; спросить, какой Cubit владеет этим state.
- "Просто вызови API из widget" → отказать; провести через use case.
- "Объедини data и domain, чтобы сэкономить время" → отказать; это ломает границу.
- "Создай top-level lib/" → отказать; Flutter-код живет в `mobile_app/lib/`.

---

## 6. Соглашения по commit

Conventional Commits, сгруппированные по области:

```
feat(portfolio): add portfolio summary card
fix(chat): handle SSE disconnect during long answers
refactor(core): extract currency formatter
test(portfolio): cover PortfolioCubit error path
docs(architecture): document streaming trade-offs
chore(deps): bump flutter_bloc to 8.1.6
```

Допустимые scopes: `portfolio`, `chat`, `insights`, `core`, `backend`, `deps`,
`architecture`, `claude`, `repo`.

- Subject ≤ 72 символов, imperative mood.
- Body объясняет *why*, а не *what* (diff показывает what).
- Одно логическое изменение на commit; нарезка по фичам.

---

## 7. Когда расширяешь приложение

Добавляешь новую фичу? Копируй форму `mobile_app/lib/features/portfolio/`:
1. `domain/entities` — чистый Dart
2. `domain/repositories` — абстракция
3. `domain/usecases` — один файл на операцию
4. `data/models` — `fromJson` / `toJson`
5. `data/datasources` — Dio или mock
6. `data/repositories` — реализует domain contract
7. `presentation/cubit` — sealed state
8. `presentation/pages` + `widgets`
9. Зарегистрируй в `mobile_app/lib/core/di/injection.dart`
10. Предоставь Cubit на границе page через `BlocProvider`

Если какой-то шаг кажется необязательным, перечитай §1.
