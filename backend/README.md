# Бэкенд — FastAPI

FastAPI-бэкенд для AI Portfolio Companion. Реализация следует структуре из
[`../docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md): тонкие routes, бизнес-логика
в services, mock-данные за repository.

## Структура

```
backend/
├── app/
│   ├── main.py
│   ├── api/v1/{router.py, routes/}
│   ├── schemas/
│   ├── services/
│   ├── repositories/
│   └── data/mock_data.py
└── requirements.txt
```

## Endpoint'ы

- `POST /v1/chat/stream` — SSE stream для AI chat.
- `GET /v1/portfolio` — snapshot портфеля.
- `GET /v1/insights` — AI insight cards.
- `GET /health` — health check.

## Запуск

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Flutter по умолчанию смотрит на:

```bash
http://127.0.0.1:8000/v1
```

Для запуска на реальном устройстве укажи адрес машины в одной сети:

```bash
flutter run --dart-define=API_BASE_URL=http://YOUR_LOCAL_IP:8000/v1
```

## Тесты

```bash
cd backend
.venv/bin/python -m pytest tests
```

## Быстрая проверка контрактов

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
