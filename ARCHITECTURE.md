# AI Portfolio Companion — Architecture Guide

A scalable, production-ready architecture for a mobile-first AI portfolio app built with **Flutter (Clean Architecture + Cubit)** and **FastAPI (lightweight modular backend)**.

The guiding philosophy: **simple enough to build in a weekend, structured enough to scale for a year**.

---

## 1. Flutter — Folder Structure (Feature-Based Clean Architecture)

```
lib/
├── main.dart                          # App entry + DI bootstrap
├── app.dart                           # MaterialApp, theme, router wiring
│
├── core/                              # Cross-cutting concerns (no feature logic)
│   ├── config/
│   │   ├── app_config.dart            # Base URL, env switches
│   │   └── env.dart
│   ├── constants/
│   │   └── api_endpoints.dart
│   ├── di/
│   │   └── injection.dart             # get_it registrations
│   ├── error/
│   │   ├── failures.dart              # Domain-level Failure classes
│   │   └── exceptions.dart            # Data-layer exceptions
│   ├── network/
│   │   ├── dio_client.dart            # Configured Dio + interceptors
│   │   └── sse_client.dart            # Streaming client for chat
│   ├── router/
│   │   └── app_router.dart            # go_router configuration
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── app_colors.dart
│   └── utils/
│       ├── formatters.dart            # Currency, percent, date
│       └── result.dart                # Either<Failure, T> helper
│
├── features/
│   ├── portfolio/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── portfolio_remote_datasource.dart
│   │   │   ├── models/                # DTOs with fromJson/toJson
│   │   │   │   ├── holding_model.dart
│   │   │   │   └── portfolio_model.dart
│   │   │   └── repositories/
│   │   │       └── portfolio_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/              # Pure Dart, no JSON
│   │   │   │   ├── holding.dart
│   │   │   │   └── portfolio.dart
│   │   │   ├── repositories/
│   │   │   │   └── portfolio_repository.dart   # Abstract contract
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
│   │   │   │   └── chat_remote_datasource.dart   # Handles SSE stream
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
│   │   │       └── send_message_stream.dart      # Returns Stream<String>
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
    ├── widgets/                       # App-wide reusable widgets
    │   ├── app_scaffold.dart
    │   ├── error_view.dart
    │   └── loading_view.dart
    └── extensions/
        ├── context_extensions.dart
        └── string_extensions.dart
```

---

## 2. FastAPI — Folder Structure (Clean and Modular)

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py                        # FastAPI app + CORS + router include
│   │
│   ├── core/
│   │   ├── config.py                  # Settings (pydantic-settings)
│   │   └── logging.py
│   │
│   ├── api/
│   │   └── v1/
│   │       ├── router.py              # Aggregates all v1 routes
│   │       └── routes/
│   │           ├── portfolio.py
│   │           ├── chat.py
│   │           └── insights.py
│   │
│   ├── schemas/                       # Pydantic request/response models
│   │   ├── portfolio.py
│   │   ├── chat.py
│   │   └── insights.py
│   │
│   ├── services/                      # Business logic (pure functions / classes)
│   │   ├── portfolio_service.py
│   │   ├── chat_service.py            # Streams LLM tokens
│   │   └── insights_service.py
│   │
│   ├── repositories/                  # Data access abstraction
│   │   └── portfolio_repository.py    # Reads from mock data today,
│   │                                  # DB tomorrow — no service change
│   │
│   └── data/
│       └── mock_data.py               # Seed portfolio, holdings, prices
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

## 3. Architecture Layers

### Flutter — Three Layers per Feature

**Domain (innermost)** — Pure business rules. Zero Flutter, zero Dio, zero JSON. Contains `entities` (immutable value objects), `repositories` (abstract interfaces), and `usecases` (single-responsibility operations like `GetPortfolio`). This layer doesn't know the API exists. It's the most stable and the easiest to test.

**Data** — Everything outside the app: HTTP, cache, serialization. Contains `models` (extend entities with `fromJson`/`toJson`), `datasources` (talk to Dio / SSE), and `repository_impl` (implements the domain contract, converts exceptions to `Failure`s, maps models to entities). The only layer that knows JSON exists.

**Presentation** — Flutter UI and state. Contains `cubit` (holds state, calls usecases), `pages` (screens), and `widgets` (feature-scoped widgets). Never touches Dio, never parses JSON — it talks to usecases and renders state.

**Dependency rule:** outer layers depend on inner ones. Presentation → Domain ← Data. Domain has no imports from the other two.

### FastAPI — Three Layers per Feature

**Routes (api/v1/routes)** — HTTP boundary only. Parse the request, call a service, return a response. No business logic. Routes are thin; if a route is over ~15 lines, push logic into the service.

**Services** — Business logic. Composes repositories, applies rules (e.g., calculating daily change), formats data for the response schema. This is where "the app" lives.

**Repositories** — Data access. Today they read from `mock_data.py`; tomorrow they hit Postgres. The service never knows or cares which.

**Schemas** — Pydantic models for validation and serialization. Separate from any future ORM models.

---

## 4. Feature Organization

Features are **vertical slices**, not horizontal ones. Each feature (`portfolio`, `chat`, `insights`) owns its data, domain, and presentation code end-to-end. This keeps related code close, minimizes cross-feature coupling, and makes it easy to delete or extract a feature later.

**Portfolio** is the dashboard feature: loads holdings, total value, and daily change on app start. Depends on no other feature.

**Chat** is self-contained messaging with streaming. It may *reference* portfolio data when building prompts, but that's handled server-side — the chat feature just sends a user message and renders tokens back. This prevents the chat feature from coupling to portfolio internals.

**Insights** is read-only AI analysis. The backend computes insights from portfolio data; the mobile app just displays them. No client-side LLM calls.

**Rule of thumb:** if two features need the same code, lift it into `core/` or `shared/`. Don't let feature A import from feature B.

---

## 5. State Management (Cubit)

**Use Cubit, not Bloc, as the default.** Bloc's event stream is overkill for this app — Cubit gives you the same testability with less boilerplate.

**One Cubit per screen-level concern.** `PortfolioCubit`, `ChatCubit`, `InsightsCubit`. If two widgets need the same state, they share a Cubit via `BlocProvider`. If they need *different* state, they get different Cubits.

**State as a sealed union** (use `freezed` or a hand-rolled sealed class):

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

This forces the UI to handle every case via a `switch` — no "forgotten loading state" bugs.

**Cubits only call usecases.** They never touch Dio or repositories directly. This keeps them testable with a simple mocked usecase.

**When *not* to use a Cubit:** transient UI state (a text field's controller, whether a card is expanded). Use `StatefulWidget` or a local `ValueNotifier`. Cubits are for state the app cares about, not for every toggle.

For chat streaming, the Cubit holds a `List<ChatMessage>` in state and mutates the last (assistant) message's text as chunks arrive, emitting a new state for each chunk. Flutter's widget diffing makes this cheap.

---

## 6. API Design

Base URL: `https://api.example.com/v1`

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

### Chat (streaming)

```
POST /chat/stream
Content-Type: application/json
Accept: text/event-stream

Body: { "message": "How is my portfolio doing?", "conversation_id": "optional" }

Response (SSE):
  data: {"chunk": "Your portfolio "}
  data: {"chunk": "is up 1.01% today. "}
  data: {"done": true}
```

### Insights

```
GET /insights
→ 200 {
    "insights": [
      { "title": "Tech concentration", "body": "...", "severity": "info" }
    ]
  }
```

### Frontend ↔ Backend Interaction Pattern

The mobile app talks to a single versioned HTTP API. Dio handles plain JSON endpoints; a separate SSE client handles the streaming chat endpoint.

Flow for a portfolio load: `PortfolioPage` initState → `PortfolioCubit.load()` → `GetPortfolio` usecase → `PortfolioRepository` (abstract) → `PortfolioRepositoryImpl` → `PortfolioRemoteDataSource.fetch()` → Dio GET `/portfolio` → JSON → `PortfolioModel.fromJson` → entity → back up the stack as `PortfolioLoaded(portfolio)`.

This looks like a lot of steps, but each is one small file. The payoff: you can mock any layer in tests, and swap implementations (e.g., add offline caching in the repository) without touching anything else.

---

## 7. Streaming Responses for Chat (High-Level)

**Backend** — Use FastAPI's `StreamingResponse` with Server-Sent Events (SSE). It's simpler than WebSockets, works through corporate proxies, and reconnects for free.

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

The `chat_service.stream_llm_response` is an `async generator` that yields tokens. Today it can yield from a mocked string; tomorrow it wraps an Anthropic or OpenAI streaming call — the route doesn't change.

**Flutter** — Use a raw HTTP client (not Dio, which buffers) or the `dio` package with `ResponseType.stream`. Parse the SSE event stream into a `Stream<String>` of chunks, exposed by the chat datasource:

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

The `ChatCubit` listens to this stream and appends each chunk to the last assistant message in its state. The UI just renders `state.messages.last` — no special streaming widget logic beyond a blinking cursor while `isStreaming` is true.

---

## 8. Key Architectural Decisions and Trade-offs

**Clean Architecture with feature slices.** *Cost:* more files, more boilerplate for small features. *Benefit:* each layer is independently testable; swapping Dio for Retrofit or mock data for a real DB is a local change. For a 3-feature app this is arguably overkill, but you've explicitly asked for scalable, so this is the right floor.

**Cubit over Bloc.** Less ceremony, same testability. Revisit if you need to compose complex event flows (undo stacks, debounced search across multiple triggers), but for load-display-react apps Cubit wins.

**SSE over WebSockets for chat.** Chat is one-way streaming from server to client; SSE is purpose-built for that, has built-in reconnection, and is trivially cacheable/proxyable. WebSockets are only worth the complexity when you need true bidirectional or binary data.

**Repository pattern even with mock data.** *Cost:* one extra indirection. *Benefit:* when you replace mock data with a database (or add caching, retries, offline support), services and routes don't change at all. This is the single highest-ROI abstraction in the stack.

**Pydantic schemas distinct from domain entities.** The backend uses Pydantic schemas at the HTTP boundary; Flutter uses models (JSON) distinct from entities (pure Dart). This double mapping feels redundant but protects the core from API shape changes — a backend field rename doesn't ripple into UI widgets.

**get_it for DI.** Simpler than `provider` or `riverpod` for pure dependency graphs (as opposed to reactive state). Cubits still get provided via `BlocProvider` in the widget tree; get_it supplies their dependencies (usecases, repositories).

**No real auth, no real DB.** Intentional for v1. When they land, auth goes in a Dio interceptor + a small `auth` feature; DB goes behind the existing repository interfaces. No layer above repositories should need to change.

**Versioned API (`/v1`).** Cheap to add now, expensive to retrofit. Gives you a clean breaking-change path later.

---

## TL;DR Starting Checklist

1. Scaffold the `lib/` tree above with empty files — `flutter create` + script.
2. Set up `get_it` in `core/di/injection.dart` and wire the portfolio feature end-to-end first (data → domain → Cubit → page). This proves the pattern.
3. Stand up FastAPI with one route (`GET /portfolio`) reading from `mock_data.py` via a repository. Wire it to the Flutter app.
4. Add chat second with SSE streaming — this is the interesting part and the highest-risk piece, so de-risk early.
5. Add insights last; it's the simplest feature and benefits from patterns already established.

Build one feature fully before starting the next. Resist the urge to scaffold all three at once.
