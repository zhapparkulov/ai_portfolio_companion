# AI Portfolio Companion — Руководство по архитектуре

Масштабируемая, готовая к продакшену архитектура мобильного AI-приложения для портфеля, построенного на **Flutter (Clean Architecture + Cubit)** и **FastAPI (легковесный модульный бэкенд)**.

Главный принцип: **достаточно просто, чтобы собрать за выходные, и достаточно структурно, чтобы масштабировать в течение года**.

---

## 1. Flutter — структура папок (Clean Architecture по фичам)

```
lib/
├── main.dart                          # Точка входа приложения + запуск DI
├── app.dart                           # MaterialApp, тема, подключение роутера
│
├── core/                              # Сквозная инфраструктура без логики фич
│   ├── config/
│   │   ├── app_config.dart            # Базовый URL, переключатели окружений
│   │   └── env.dart
│   ├── constants/
│   │   └── api_endpoints.dart
│   ├── di/
│   │   └── injection.dart             # Регистрации get_it
│   ├── error/
│   │   ├── failures.dart              # Классы Failure на уровне domain
│   │   └── exceptions.dart            # Исключения data-слоя
│   ├── network/
│   │   ├── dio_client.dart            # Настроенный Dio + интерсепторы
│   │   └── sse_client.dart            # Потоковый клиент для чата
│   ├── router/
│   │   └── app_router.dart            # Конфигурация go_router
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── app_colors.dart
│   └── utils/
│       ├── formatters.dart            # Валюта, проценты, даты
│       └── result.dart                # Хелпер Either<Failure, T>
│
├── features/
│   ├── portfolio/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── portfolio_remote_datasource.dart
│   │   │   ├── models/                # DTO с fromJson/toJson
│   │   │   │   ├── holding_model.dart
│   │   │   │   └── portfolio_model.dart
│   │   │   └── repositories/
│   │   │       └── portfolio_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/              # Чистый Dart, без JSON
│   │   │   │   ├── holding.dart
│   │   │   │   └── portfolio.dart
│   │   │   ├── repositories/
│   │   │   │   └── portfolio_repository.dart   # Абстрактный контракт
│   │   │   └── usecases/
│   │   │       └── get_portfolio.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── portfolio_cubit.dart
│   │       │   └── portfolio_state.dart
│   │       ├── pages/
│   │       │   └── portfolio_page.dart
│   │       └── widgets/
│   │           ├── portfolio_summary_card.dart
│   │           ├── daily_change_badge.dart
│   │           └── holding_tile.dart
│   │
│   ├── chat/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── chat_remote_datasource.dart   # Обрабатывает SSE-поток
│   │   │   ├── models/
│   │   │   │   ├── chat_message_model.dart
│   │   │   │   └── chat_chunk_model.dart
│   │   │   └── repositories/
│   │   │       └── chat_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── chat_message.dart
│   │   │   ├── repositories/
│   │   │   │   └── chat_repository.dart
│   │   │   └── usecases/
│   │   │       └── send_message_stream.dart      # Возвращает Stream<String>
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── chat_cubit.dart
│   │       │   └── chat_state.dart
│   │       ├── pages/
│   │       │   └── chat_page.dart
│   │       └── widgets/
│   │           ├── message_bubble.dart
│   │           ├── streaming_bubble.dart
│   │           └── chat_input.dart
│   │
│   └── insights/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── insights_remote_datasource.dart
│       │   ├── models/
│       │   │   └── insight_model.dart
│       │   └── repositories/
│       │       └── insights_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── insight.dart
│       │   ├── repositories/
│       │   │   └── insights_repository.dart
│       │   └── usecases/
│       │       └── get_insights.dart
│       └── presentation/
│           ├── cubit/
│           │   ├── insights_cubit.dart
│           │   └── insights_state.dart
│           ├── pages/
│           │   └── insights_page.dart
│           └── widgets/
│               └── insight_card.dart
│
└── shared/
    ├── widgets/                       # Переиспользуемые виджеты всего приложения
    │   ├── app_scaffold.dart
    │   ├── error_view.dart
    │   └── loading_view.dart
    └── extensions/
        ├── context_extensions.dart
        └── string_extensions.dart
```

---

## 2. FastAPI — структура папок (чистая и модульная)

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py                        # FastAPI-приложение + CORS + подключение роутера
│   │
│   ├── core/
│   │   ├── config.py                  # Настройки (pydantic-settings)
│   │   └── logging.py
│   │
│   ├── api/
│   │   └── v1/
│   │       ├── router.py              # Собирает все v1-маршруты
│   │       └── routes/
│   │           ├── portfolio.py
│   │           ├── chat.py
│   │           └── insights.py
│   │
│   ├── schemas/                       # Pydantic-модели запросов/ответов
│   │   ├── portfolio.py
│   │   ├── chat.py
│   │   └── insights.py
│   │
│   ├── services/                      # Бизнес-логика (чистые функции / классы)
│   │   ├── portfolio_service.py
│   │   ├── chat_service.py            # Стримит LLM-токены
│   │   └── insights_service.py
│   │
│   ├── repositories/                  # Абстракция доступа к данным
│   │   └── portfolio_repository.py    # Сегодня читает mock-данные,
│   │                                  # завтра DB — без изменений в сервисе
│   │
│   └── data/
│       └── mock_data.py               # Начальные данные: portfolio, holdings, prices
│
├── tests/
│   ├── test_portfolio.py
│   └── test_chat.py
│
├── requirements.txt
├── .env.example
└── README.md
```

---

## 3. Архитектурные слои

### Flutter — три слоя на каждую фичу

**Domain (самый внутренний слой)** — чистые бизнес-правила. Никакого Flutter, Dio и JSON. Содержит `entities` (неизменяемые объекты-значения), `repositories` (абстрактные интерфейсы) и `usecases` (операции с одной ответственностью, например `GetPortfolio`). Этот слой не знает, что API вообще существует. Он самый стабильный и самый простой для тестирования.

**Data** — всё, что находится за пределами приложения: HTTP, кэш, сериализация. Содержит `models` (расширяют entities методами `fromJson`/`toJson`), `datasources` (общаются с Dio / SSE) и `repository_impl` (реализует domain-контракт, превращает exceptions в `Failure`, мапит models в entities). Это единственный слой, который знает, что JSON существует.

**Presentation** — Flutter UI и состояние. Содержит `cubit` (держит состояние, вызывает usecases), `pages` (экраны) и `widgets` (виджеты конкретной фичи). Никогда не трогает Dio и не парсит JSON — он общается с usecases и отображает состояние.

**Правило зависимостей:** внешние слои зависят от внутренних. Presentation → Domain ← Data. Domain не импортирует два других слоя.

### FastAPI — три слоя на каждую фичу

**Routes (api/v1/routes)** — только HTTP-граница. Разобрать запрос, вызвать service, вернуть ответ. Никакой бизнес-логики. Routes должны быть тонкими; если route становится длиннее примерно 15 строк, логику нужно вынести в service.

**Services** — бизнес-логика. Комбинирует repositories, применяет правила (например, считает дневное изменение), форматирует данные под response schema. Именно здесь живет "приложение".

**Repositories** — доступ к данным. Сегодня читают из `mock_data.py`; завтра обращаются к Postgres. Service никогда не знает и не должен знать, какой источник используется.

**Schemas** — Pydantic-модели для валидации и сериализации. Они отделены от любых будущих ORM-моделей.

---

## 4. Организация фич

Фичи — это **вертикальные срезы**, а не горизонтальные слои. Каждая фича (`portfolio`, `chat`, `insights`) владеет своим data, domain и presentation-кодом от начала до конца. Так связанный код остается рядом, уменьшается связность между фичами, а позже фичу проще удалить или вынести отдельно.

**Portfolio** — фича дашборда: при старте приложения загружает holdings, total value и daily change. Не зависит ни от одной другой фичи.

**Chat** — самодостаточная переписка с потоковой передачей ответа. При построении prompt он может *ссылаться* на portfolio data, но это обрабатывается на стороне сервера — chat-фича на клиенте только отправляет пользовательское сообщение и отображает токены в ответ. Это не дает chat-фиче связаться с внутренностями portfolio.

**Insights** — AI-анализ только для чтения. Бэкенд вычисляет insights на основе portfolio data; мобильное приложение только отображает их. Никаких LLM-вызовов на клиенте.

**Практическое правило:** если двум фичам нужен один и тот же код, подними его в `core/` или `shared/`. Не позволяй фиче A импортировать что-либо из фичи B.

---

## 5. Управление состоянием (Cubit)

**По умолчанию используй Cubit, а не Bloc.** Поток событий в Bloc для этого приложения избыточен — Cubit дает ту же тестируемость с меньшим количеством шаблонного кода.

**Один Cubit на область ответственности экрана.** `PortfolioCubit`, `ChatCubit`, `InsightsCubit`. Если двум виджетам нужно одно и то же состояние, они делят Cubit через `BlocProvider`. Если им нужно *разное* состояние, они получают разные Cubit.

**Состояние как sealed union** (используй `freezed` или sealed class, написанный вручную):

```dart
sealed class PortfolioState {}
class PortfolioInitial extends PortfolioState {}
class PortfolioLoading extends PortfolioState {}
class PortfolioLoaded extends PortfolioState {
  final Portfolio portfolio;
  PortfolioLoaded(this.portfolio);
}
class PortfolioError extends PortfolioState {
  final String message;
  PortfolioError(this.message);
}
```

Это заставляет UI обработать каждый случай через `switch` — без багов из серии "забыли состояние загрузки".

**Cubits вызывают только usecases.** Они никогда не трогают Dio или repositories напрямую. Благодаря этому их легко тестировать с простым замоканным usecase.

**Когда Cubit не нужен:** временное UI-состояние (controller текстового поля, раскрыта ли карточка). Используй `StatefulWidget` или локальный `ValueNotifier`. Cubit нужен для состояния, которое важно приложению, а не для каждого toggle.

Для потоковой передачи в chat Cubit держит `List<ChatMessage>` в состоянии и по мере прихода chunk'ов меняет текст последнего assistant-сообщения, эмитя новое состояние на каждый chunk. Diffing виджетов во Flutter делает это дешевым.

---

## 6. Дизайн API

Базовый URL: `https://api.example.com/v1`

### Portfolio

```
GET /portfolio
→ 200 {
    "total_value": 124530.42,
    "daily_change": 1243.10,
    "daily_change_percent": 1.01,
    "holdings": [
      {
        "symbol": "AAPL",
        "name": "Apple Inc.",
        "quantity": 25,
        "avg_price": 150.22,
        "current_price": 189.50,
        "value": 4737.50,
        "daily_change_percent": 0.82
      }
    ]
  }
```

### Chat (потоковая передача)

```
POST /chat/stream
Content-Type: application/json
Accept: text/event-stream

Тело: { "message": "Как дела у моего портфеля?", "conversation_id": "optional" }

Ответ (SSE):
  data: {"chunk": "Ваш портфель "}
  data: {"chunk": "сегодня вырос на 1.01%. "}
  data: {"done": true}
```

### Insights

```
GET /insights
→ 200 {
    "insights": [
      { "title": "Концентрация в tech", "body": "...", "severity": "info" }
    ]
  }
```

### Паттерн взаимодействия фронтенд ↔ бэкенд

Мобильное приложение общается с единым версионированным HTTP API. Dio обрабатывает обычные JSON endpoints; отдельный SSE client обрабатывает потоковый chat endpoint.

Поток загрузки portfolio: `PortfolioPage` initState → `PortfolioCubit.load()` → usecase `GetPortfolio` → `PortfolioRepository` (abstract) → `PortfolioRepositoryImpl` → `PortfolioRemoteDataSource.fetch()` → Dio GET `/portfolio` → JSON → `PortfolioModel.fromJson` → entity → обратно вверх по стеку как `PortfolioLoaded(portfolio)`.

На первый взгляд это выглядит как много шагов, но каждый шаг — один маленький файл. Выигрыш: можно замокать любой слой в тестах и заменить реализации (например, добавить offline caching в repository), не трогая остальной код.

---

## 7. Потоковые ответы для Chat (верхний уровень)

**Бэкенд** — используй `StreamingResponse` из FastAPI вместе с Server-Sent Events (SSE). Это проще, чем WebSockets, проходит через корпоративные proxy и бесплатно дает reconnect.

```python
# app/api/v1/routes/chat.py
from fastapi import APIRouter
from fastapi.responses import StreamingResponse
from app.services.chat_service import stream_llm_response
from app.schemas.chat import ChatRequest

router = APIRouter()

@router.post("/chat/stream")
async def chat_stream(req: ChatRequest):
    async def event_generator():
        async for chunk in stream_llm_response(req.message):
            yield f"data: {{\"chunk\": {json.dumps(chunk)}}}\n\n"
        yield "data: {\"done\": true}\n\n"

    return StreamingResponse(event_generator(), media_type="text/event-stream")
```

`chat_service.stream_llm_response` — это `async generator`, который yield'ит токены. Сегодня он может yield'ить из mock-строки; завтра он оборачивает streaming-вызов Anthropic или OpenAI — route при этом не меняется.

**Flutter** — используй raw HTTP client (не Dio, который буферизует) или пакет `dio` с `ResponseType.stream`. Распарси SSE event stream в `Stream<String>` из chunk'ов, который наружу отдает chat datasource:

```dart
Stream<String> sendMessage(String message) async* {
  final response = await client.post(
    url, body: {'message': message}, stream: true,
  );
  await for (final line in response.stream.transform(utf8.decoder).transform(const LineSplitter())) {
    if (!line.startsWith('data:')) continue;
    final payload = jsonDecode(line.substring(5));
    if (payload['done'] == true) return;
    yield payload['chunk'] as String;
  }
}
```

`ChatCubit` слушает этот stream и добавляет каждый chunk к последнему assistant-сообщению в своем состоянии. UI просто отображает `state.messages.last` — специальная streaming-логика не нужна, кроме мигающего cursor, пока `isStreaming` равен true.

---

## 8. Ключевые архитектурные решения и компромиссы

**Clean Architecture с feature slices.** *Цена:* больше файлов и шаблонного кода для маленьких фич. *Польза:* каждый слой тестируется независимо; замена Dio на Retrofit или mock data на настоящую DB остается локальным изменением. Для приложения из 3 фич это можно назвать избыточностью, но если цель — масштабируемость, это правильный минимальный уровень структуры.

**Cubit вместо Bloc.** Меньше ceremony, та же тестируемость. К Bloc стоит вернуться, если появятся сложные потоки событий (undo stacks, debounced search из нескольких triggers), но для сценариев "загрузить → показать → отреагировать" Cubit выигрывает.

**SSE вместо WebSockets для chat.** Chat — это односторонний streaming от server к client; SSE создан именно для этого, имеет встроенный reconnection и тривиально проходит через cache/proxy. WebSockets стоят своей сложности только когда нужны настоящая bidirectional-коммуникация или binary data.

**Repository pattern даже с mock data.** *Цена:* один дополнительный уровень косвенности. *Польза:* когда ты заменишь mock data на database (или добавишь caching, retries, offline support), services и routes вообще не изменятся. Это абстракция с самым высоким ROI во всем стеке.

**Pydantic schemas отдельно от domain entities.** Бэкенд использует Pydantic schemas на HTTP-границе; Flutter использует models (JSON), отделенные от entities (pure Dart). Двойной mapping выглядит избыточно, но защищает ядро от изменений формы API — переименование поля на backend не разлетается по UI widgets.

**get_it для DI.** Проще, чем `provider` или `riverpod`, когда речь про чистый граф зависимостей, а не reactive state. Cubits все равно предоставляются через `BlocProvider` в widget tree; get_it поставляет им зависимости (usecases, repositories).

**Без real auth и real DB.** Это намеренно для v1. Когда они появятся, auth пойдет в Dio interceptor + маленькую `auth` feature; DB встанет за существующие repository interfaces. Ни один слой выше repositories не должен измениться.

**Версионированный API (`/v1`).** Дешево добавить сейчас, дорого прикручивать позже. Дает чистый путь для breaking changes в будущем.

---

## TL;DR стартовый чеклист

1. Создать `lib/` дерево выше с пустыми файлами — `flutter create` + скрипт.
2. Настроить `get_it` в `core/di/injection.dart` и сначала провести portfolio feature end-to-end (data → domain → Cubit → page). Это докажет, что паттерн работает.
3. Поднять FastAPI с одним route (`GET /portfolio`), который читает из `mock_data.py` через repository. Подключить его к Flutter-приложению.
4. Вторым добавить chat с SSE streaming — это самая интересная и самая рискованная часть, поэтому ее нужно снизить риск на раннем этапе.
5. Последним добавить insights; это самая простая фича, и она выигрывает от уже сложившихся паттернов.

Собери одну фичу полностью, прежде чем начинать следующую. Не поддавайся желанию scaffold'ить все три сразу.
