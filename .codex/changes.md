# Журнал изменений Codex

Этот файл фиксирует сессии Codex: что менялось, почему, какие проверки были
запущены и что логично делать дальше.

## 2026-04-17 — Добавлена рабочая память Codex

Что сделано:
- Создана структура `.codex/` по аналогии с `.claude/`.
- Добавлены правила работы Codex в `.codex/CODEX.md`.
- Добавлен журнал `.codex/changes.md`.
- Добавлен шаблон записи `.codex/change-template.md`.

Затронутые области:
- Документация AI-пайплайна проекта.

Решения:
- Журнал хранится в Markdown, чтобы его можно было читать и редактировать прямо в IDE.
- `.codex/changes.md` не заменяет git, а фиксирует человеческий контекст: решения,
  проверки и следующие шаги.

Проверки:
- Не запускались: изменение только документационное.

Следующий шаг:
- После каждой заметной Codex-сессии добавлять новую запись в `.codex/changes.md`.

## 2026-04-17 — SSE для chat и Clean Architecture slice для insights

Что сделано:
- Заменен mock streaming в `ChatRemoteDataSource` на реальный SSE-поток через Dio `ResponseType.stream`.
- Добавлены `AppConfig`, `ApiEndpoints`, `DioClient` и `SseClient` в `mobile_app/lib/core/`.
- `ChatRemoteDataSource` теперь отправляет `POST /chat/stream` и парсит SSE-события `data: {...}`.
- `insights` поднят до полноценного feature slice: `data`, `domain`, `presentation/cubit`.
- Добавлены общий `InsightsDataSource` contract и `InsightsRemoteDataSource` под будущий `GET /insights`.
- `InsightsPage` переведен на `InsightsCubit`, loading / empty / error / loaded states.
- DI обновлен для chat SSE-инфраструктуры и insights use case.
- Добавлены unit / cubit tests для новых chat и insights слоев.
- Удалены неиспользуемые mock response ключи из ARB после замены chat stream.

Затронутые области:
- `mobile_app/lib/core/config/`
- `mobile_app/lib/core/constants/`
- `mobile_app/lib/core/network/`
- `mobile_app/lib/features/chat/data/`
- `mobile_app/lib/features/insights/`
- `mobile_app/lib/app.dart`
- `mobile_app/lib/core/di/injection.dart`
- `mobile_app/test/features/chat/`
- `mobile_app/test/features/insights/`

Решения:
- Chat mock chunks удалены из datasource: теперь клиент ожидает готовый backend endpoint `POST /v1/chat/stream`.
- Insights пока использует mock data source через общий `InsightsDataSource` contract, чтобы позже заменить источник данных без изменения repository/usecase/UI.
- Severity и action metadata вынесены в domain entities insights, а карточки только отображают полученное состояние.

Проверки:
- `dart format mobile_app/lib mobile_app/test .codex`
- `flutter gen-l10n`
- `flutter analyze`
- `flutter test`

Следующий шаг:
- Когда backend `GET /v1/insights` будет готов, заменить `InsightsMockDataSource` на remote datasource за тем же repository contract.

## 2026-04-17 — FastAPI backend endpoints v1

Что сделано:
- Поднят backend skeleton по `docs/ARCHITECTURE.md`: `app/main.py`, `api/v1`, `routes`, `schemas`, `services`, `repositories`, `data`.
- Добавлен `POST /v1/chat/stream` с `StreamingResponse` и SSE contract `data: {"chunk": ...}` / `data: {"done": true}`.
- Добавлен `GET /v1/portfolio` с mock snapshot портфеля.
- Добавлен `GET /v1/insights`, который строит mock insight cards на основе portfolio data.
- Добавлены `requirements.txt`, `.env.example`, backend `.gitignore` и README с командами запуска.
- Добавлены endpoint tests для chat, portfolio и insights.

Затронутые области:
- `backend/app/main.py`
- `backend/app/api/v1/**`
- `backend/app/schemas/**`
- `backend/app/services/**`
- `backend/app/repositories/**`
- `backend/app/data/mock_data.py`
- `backend/tests/**`
- `backend/requirements.txt`
- `backend/README.md`

Решения:
- Chat backend пока использует mock generator, но уже соблюдает SSE-протокол, который ожидает Flutter.
- Portfolio и insights читают mock data через repository/service boundaries, чтобы позже заменить источник данных без изменения routes.
- Backend оставлен совместимым с Python 3.9: используются `Optional[...]` вместо `str | None`.

Проверки:
- `PYTHONPYCACHEPREFIX=/tmp/ai_portfolio_pycache .venv/bin/python -m compileall app tests`
- `.venv/bin/python -m pytest tests` — 4 passed

Следующий шаг:
- Подключить Flutter `portfolio` к `GET /v1/portfolio` через remote datasource и переключить DI с mock на remote.

## 2026-04-17 — End-to-end проверка и актуализация README

Что сделано:
- Проверен живой FastAPI backend на `127.0.0.1:8000`.
- Подтверждены контракты `GET /health`, `GET /v1/portfolio`, `GET /v1/insights`.
- Подтвержден SSE-контракт `POST /v1/chat/stream`: backend отдает `data: {"chunk": ...}` и завершает `data: {"done": true}`.
- Исправлены мелкие Flutter analyzer/test blockers: неиспользуемый import, отсутствующие `@override`, async DI setup в widget test.
- Обновлены `README.md`, `mobile_app/README.md` и `backend/README.md` под текущее full-stack состояние проекта.

Затронутые области:
- `README.md`
- `mobile_app/README.md`
- `backend/README.md`
- `mobile_app/lib/core/di/injection.dart`
- `mobile_app/lib/features/chat/presentation/cubit/chat_cubit.dart`
- `mobile_app/lib/features/portfolio/data/datasources/portfolio_mock_datasource.dart`
- `mobile_app/lib/features/portfolio/data/datasources/portfolio_remote_datasource.dart`
- `mobile_app/test/widget_test.dart`

Решения:
- Документация теперь описывает реальный запуск Flutter + FastAPI, а не старое состояние с ожидающим backend.
- Для реального устройства явно задокументирован `--dart-define=API_BASE_URL=http://YOUR_LOCAL_IP:8000/v1`.
- Widget test теперь поднимает DI асинхронно и переопределяет `GetPortfolio` fake-репозиторием, чтобы не зависеть от backend.

Проверки:
- `flutter analyze`
- `flutter test`
- `.venv/bin/python -m pytest tests`
- `curl http://127.0.0.1:8000/health`
- `curl http://127.0.0.1:8000/v1/portfolio`
- `curl http://127.0.0.1:8000/v1/insights`
- `curl -N -H "Accept: text/event-stream" -H "Content-Type: application/json" -d '{"message":"How is my tech exposure?"}' http://127.0.0.1:8000/v1/chat/stream`

Следующий шаг:
- Прогнать приложение на iOS Simulator или реальном iPhone против локального backend и записать Loom walkthrough.

## 2026-04-17 — Android локальный backend fix

Что сделано:
- Обновлен `AppConfig`: без `API_BASE_URL` Android emulator теперь использует `http://10.0.2.2:8000/v1`, остальные платформы — `http://127.0.0.1:8000/v1`.
- В Android main manifest добавлен `INTERNET` permission для всех build modes.
- В Android main manifest включен `android:usesCleartextTraffic="true"` для локального HTTP backend.
- README дополнен пояснением про Android emulator, `10.0.2.2` и override через `API_BASE_URL`.

Затронутые области:
- `mobile_app/lib/core/config/app_config.dart`
- `mobile_app/android/app/src/main/AndroidManifest.xml`
- `README.md`
- `mobile_app/README.md`

Решения:
- Не менять общий backend URL на Android-only значение: iOS Simulator продолжает работать через `127.0.0.1`.
- Для физического Android телефона оставить явный `--dart-define=API_BASE_URL=http://YOUR_LOCAL_IP:8000/v1`.

Проверки:
- `dart format mobile_app/lib/core/config/app_config.dart`
- `flutter analyze`
- `flutter test`

Следующий шаг:
- Запустить Android emulator с поднятым backend и проверить portfolio/chat/insights в UI.
