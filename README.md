# AI Portfolio Companion

Мобильное AI-приложение для портфеля. Flutter-фронтенд + FastAPI-бэкенд,
спроектированные вокруг Clean Architecture и задокументированного AI-пайплайна разработки.

## Структура репозитория

```
ai_portfolio_companion/
├── mobile_app/       # Flutter-приложение (ВЕСЬ Dart-код живет в mobile_app/lib/)
├── backend/          # FastAPI-бэкенд (еще предстоит реализовать)
├── docs/             # ARCHITECTURE.md — источник правды по архитектуре
└── .claude/          # AI-пайплайн: CLAUDE.md + agents.md
```

## Порядок чтения

1. [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) — система, которую мы строим.
2. [`.claude/CLAUDE.md`](./.claude/CLAUDE.md) — как мы пишем в ней код.
3. [`.claude/agents.md`](./.claude/agents.md) — как мы используем для этого AI.

## Текущий статус

- Фича: **дашборд портфеля** — реализована сквозно (domain, data, presentation).
- Источник mock-данных соответствует контракту `GET /v1/portfolio`; реализация бэкенда
  еще ожидает своей очереди. См. `docs/ARCHITECTURE.md` §6.

## Запуск Flutter-приложения

```bash
cd mobile_app
flutter pub get
flutter run
```

## Запуск FastAPI-бэкенда

Для локального запуска бэкенда потребуется Python (рекомендуется 3.9+).

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Для Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```
