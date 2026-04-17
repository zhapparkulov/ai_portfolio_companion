# AI Portfolio Companion

Мобильное AI-приложение для управления инвестиционным портфелем: Flutter-клиент,
FastAPI-бэкенд и задокументированный AI development pipeline.

Проект построен вокруг `docs/ARCHITECTURE.md`: feature-based Clean Architecture
на мобильной стороне и тонкий модульный FastAPI backend.

## Что уже работает

- Portfolio Dashboard: загрузка портфеля через `GET /v1/portfolio`, total value,
  daily change, holdings list, loading/error/success состояния.
- AI Chat: отправка сообщения через `POST /v1/chat/stream`, SSE streaming chunks,
  message list, input, thinking/streaming состояние.
- Insights: загрузка карточек через `GET /v1/insights`, severity/highlight/actions
  metadata, loading/empty/error/success состояния.
- Локализация: английский и русский язык, переключатель языка в верхней панели.
- Design system: базовые shared widgets, theme tokens, mobile-first dark fintech UI.
- iOS setup: deployment target синхронизирован на `13.0` в Podfile/Xcode project.

## Структура

```text
ai_portfolio_companion/
├── mobile_app/       # Flutter-приложение
├── backend/          # FastAPI API layer
├── docs/             # Архитектурная документация
├── .claude/          # Claude Code pipeline
├── .codex/           # Codex pipeline memory / change log
└── .agents/          # Общие AI-agent правила
```

## Важные документы

1. [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) — source of truth по архитектуре.
2. [`.claude/CLAUDE.md`](./.claude/CLAUDE.md) — правила работы AI внутри проекта.
3. [`.claude/agents.md`](./.claude/agents.md) — роли и сценарии AI-агентов.
4. [`.codex/CODEX.md`](./.codex/CODEX.md) — рабочие правила Codex.
5. [`.codex/changes.md`](./.codex/changes.md) — журнал изменений и проверок.

## Backend

### Установка

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Запуск

```bash
cd backend
.venv/bin/uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Endpoint'ы

- `GET /health`
- `GET /v1/portfolio`
- `POST /v1/chat/stream`
- `GET /v1/insights`

### Быстрая проверка API

```bash
curl http://127.0.0.1:8000/health
curl http://127.0.0.1:8000/v1/portfolio
curl http://127.0.0.1:8000/v1/insights
curl -N \
  -H "Accept: text/event-stream" \
  -H "Content-Type: application/json" \
  -d '{"message":"How is my tech exposure?"}' \
  http://127.0.0.1:8000/v1/chat/stream
```

### Backend tests

```bash
cd backend
.venv/bin/python -m pytest tests
```

## Flutter

### Установка

```bash
cd mobile_app
flutter pub get
```

### Запуск на iOS Simulator

Сначала запусти backend на `127.0.0.1:8000`, затем:

```bash
cd mobile_app
flutter run
```

По умолчанию Flutter использует:

```text
http://127.0.0.1:8000/v1
```

### Запуск на Android Emulator

Для Android emulator `127.0.0.1` указывает на сам emulator, а не на Mac. Поэтому
по умолчанию приложение использует:

```text
http://10.0.2.2:8000/v1
```

Backend должен быть запущен на `0.0.0.0:8000` или `127.0.0.1:8000` на Mac:

```bash
cd backend
.venv/bin/uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Запуск на реальном телефоне

Backend должен слушать `0.0.0.0`, а телефон и компьютер должны быть в одной сети.
Передай IP компьютера через `API_BASE_URL`:

```bash
cd mobile_app
flutter run --dart-define=API_BASE_URL=http://YOUR_LOCAL_IP:8000/v1
```

### Flutter checks

```bash
cd mobile_app
flutter analyze
flutter test
```

## iOS / CocoaPods

Если CocoaPods ругается на разные `IPHONEOS_DEPLOYMENT_TARGET`, проверь, что target
везде `13.0`, затем переустанови pods:

```bash
cd mobile_app/ios
pod install
```

В проекте уже зафиксировано:

- `platform :ios, '13.0'` в `ios/Podfile`.
- `IPHONEOS_DEPLOYMENT_TARGET = 13.0` для Debug/Profile/Release.
- post_install hook в Podfile принудительно выставляет pods target в `13.0`.

## Текущий уровень готовности

Проект уже закрывает основной full-stack сценарий: Flutter UI вызывает FastAPI
endpoint'ы для portfolio, chat streaming и insights. Следующий рубеж для условных
100% — прогнать приложение на iOS Simulator или реальном устройстве, записать Loom
walkthrough и отполировать действия, которые пока являются UI-заготовками.
