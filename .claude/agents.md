# agents.md — AI workflows для AI Portfolio Companion

Этот файл описывает, **как мы используем AI внутри проекта**. Он превращает
разовые prompt'ы в повторяемый пайплайн: специализированные роли, ясные
входы/выходы и ограничения, которые держат AI-работу в соответствии с
`../docs/ARCHITECTURE.md` и
`./CLAUDE.md`.

Считай каждого "agent" ниже именованным рецептом prompt. Человек все равно
review'ит каждое изменение — эти workflows нужны, чтобы AI-вклад был
узким, проверяемым и согласованным с нашими стандартами.

---

## Список агентов

| Agent | Назначение | Читает | Пишет |
|------|---------|-------|--------|
| `feature-scaffolder` | Создает полный вертикальный срез для новой Flutter-фичи | `docs/ARCHITECTURE.md`, `.claude/CLAUDE.md`, ближайшую существующую фичу | `mobile_app/lib/features/<name>/**`, регистрация DI |
| `cubit-author` | Пишет Cubit + sealed state + тесты | domain-слой фичи | `presentation/cubit/*`, `mobile_app/test/**/cubit_test.dart` |
| `repository-wrangler` | Реализует repository + datasource + маппинг models | domain contract, API schema в `docs/ARCHITECTURE.md` | `data/**` |
| `ui-composer` | Собирает pages/widgets по форме state у Cubit | Cubit state, заметки по дизайну | `presentation/pages/*`, `presentation/widgets/*` |
| `test-writer` | Создает unit / bloc / widget tests | измененные файлы | `mobile_app/test/**` |
| `reviewer` | Читает diff и отмечает нарушения правил | diff + `.claude/CLAUDE.md` | только review comments |
| `backend-route-author` | Добавляет FastAPI route, schema, service, repo | API-раздел `docs/ARCHITECTURE.md` | `backend/app/**` |
| `doc-updater` | Держит `docs/ARCHITECTURE.md` синхронизированным с реальным кодом | код + текущие docs | `docs/ARCHITECTURE.md` |

---

## Рабочий процесс: "Добавить новую Flutter-фичу"

Форма команды:

```
@feature-scaffolder add feature `insights`
```

Пайплайн:

1. **feature-scaffolder** генерирует дерево папок + пустые файлы внутри
   `mobile_app/lib/features/insights/`, копируя форму `portfolio/`.
   Выводит список файлов для согласования человеком.
2. **repository-wrangler** заполняет `data/` + `domain/`, используя API-контракт
   из `docs/ARCHITECTURE.md`. Останавливается, если контракт отсутствует.
3. **cubit-author** создает Cubit + sealed state + `bloc_test`.
4. **ui-composer** scaffold'ит page и widgets на основе формы state.
5. **test-writer** дополняет недостающие tests, чтобы выполнить правила покрытия из
   `.claude/CLAUDE.md` §4.
6. **reviewer** проходит по diff и сообщает о нарушениях
   `.claude/CLAUDE.md` §1.
7. Человек делает merge.

Каждый шаг заканчивается короткой заметкой "architecture impact"
(см. `.claude/CLAUDE.md` §5.6).

---

## Рабочий процесс: "Добавить API endpoint"

```
@backend-route-author GET /v1/insights returning list of insight cards
```

1. Определить Pydantic schema в `backend/app/schemas/insights.py`.
2. Добавить service-функцию в `backend/app/services/insights_service.py`
   (pure, testable).
3. Добавить repository в `backend/app/repositories/insights_repository.py`
   (пока читает из `mock_data.py`).
4. Добавить route в `backend/app/api/v1/routes/insights.py` — только тонкая обертка.
5. Зарегистрировать router в `backend/app/api/v1/router.py`.
6. Обновить `docs/ARCHITECTURE.md` §6, если contract изменился.

---

## Рабочий процесс: "Исправить bug"

```
@reviewer bug: portfolio page flashes error before showing data on refresh
```

1. **reviewer** читает diff *и* relevant files. Находит root cause +
   наиболее релевантное правило из `.claude/CLAUDE.md` (здесь: исчерпывающая
   обработка состояний).
2. Предлагает минимальный fix, который сохраняет правила. Без ad-hoc refactors.
3. **test-writer** добавляет regression test, который поймал бы этот bug.
4. Человек делает merge.

---

## Рабочий процесс: "Аудит расхождения docs"

```
@doc-updater audit
```

1. Пройти по дереву фич и сравнить с `docs/ARCHITECTURE.md`.
2. Для каждого mismatch решить, что должно измениться: code или docs. Поднять
   вопрос; не редактировать ничего молча.
3. Вывести короткий checklist для человека.

Запускать в конце каждого sprint.

---

## Стандартный вводный prompt

Каждый prompt для agent начинается с:

```
Ты работаешь в `ai_portfolio_companion`.
Строго следуй `.claude/CLAUDE.md` и `docs/ARCHITECTURE.md`.
Flutter-код живет в `mobile_app/lib/`. Бэкенд живет в `backend/app/`.
Никогда не создавай верхнеуровневую `lib/`.
Если правило блокирует запрошенное изменение, остановись и спроси — не обходи его.
В конце выведи заметку "architecture impact".
```

Именно этот вводный текст делает "AI in the repo" обученным. Модели не нужно
угадывать наши conventions — они записаны и обязательны.

---

## Ограничения

- **Лучше отказ, чем угадывание.** Если agent не может найти правило для
  ситуации, он задает вопрос вместо того, чтобы изобретать pattern.
- **Никакого dependency drift.** Предложение нового package открывает маленький PR,
  который меняет только manifest + раздел компромиссов в `docs/ARCHITECTURE.md`.
- **Никаких записей между фичами** за один запуск agent. Каждый run трогает один
  feature slice, кроме случаев, когда agent — `doc-updater` или `reviewer`.
- **Каждый agent output должен читаться как diff.** Большие blobs без границ
  отклоняются.
- **Tests — обязательный output**, а не optional afterthought.

---

## Как это демонстрирует AI-пайплайн

1. `docs/ARCHITECTURE.md` фиксирует *что* — структуру, контракты, компромиссы.
2. `.claude/CLAUDE.md` фиксирует *как* — conventions, которым AI должен следовать.
3. `.claude/agents.md` фиксирует *рабочий процесс* — какой agent владеет каким slice,
   в каком порядке, с какими inputs и outputs.

Вместе они превращают "prompting an LLM" в небольшой, проверяемый процесс разработки.
Новые участники, люди или AI, могут прочитать три файла и поставлять код,
который выглядит как остальная часть репозитория.
