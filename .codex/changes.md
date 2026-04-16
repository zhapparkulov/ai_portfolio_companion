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
