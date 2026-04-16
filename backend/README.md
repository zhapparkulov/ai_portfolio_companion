# Бэкенд — FastAPI

FastAPI-бэкенд для AI Portfolio Companion.

**Эта папка пока намеренно остается пустой.** Текущий спринт сфокусирован на
Flutter-фиче `portfolio`, которая работает со встроенным источником mock-данных,
соответствующим API-контракту из [`../docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md) §6.

Когда начнется реализация бэкенда, следуй структуре из `ARCHITECTURE.md` §2
("FastAPI — структура папок") и рабочему процессу
`@backend-route-author` из [`../.claude/agents.md`](../.claude/agents.md).

Целевая точка входа:

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
