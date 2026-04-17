# Mobile App

Flutter-клиент для AI Portfolio Companion.

Приложение следует feature-based Clean Architecture из
[`../docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md):

```text
lib/
├── core/       # config, DI, network, router/theme/utils
├── features/   # portfolio, chat, insights
└── shared/     # общие widgets/extensions/localization helpers
```

## Фичи

- `portfolio` — dashboard, holdings list, loading/error/success states.
- `chat` — message list, input, SSE streaming response.
- `insights` — AI insight cards, severity/highlight/actions metadata.

## API

Base URL задается через `API_BASE_URL`:

```dart
const String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8000/v1',
);
```

Ожидаемые backend endpoint'ы:

- `GET /v1/portfolio`
- `POST /v1/chat/stream`
- `GET /v1/insights`

## Запуск локально

Сначала подними backend:

```bash
cd ../backend
.venv/bin/uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Потом запусти Flutter:

```bash
cd ../mobile_app
flutter pub get
flutter run
```

Для реального устройства используй IP компьютера в локальной сети:

```bash
flutter run --dart-define=API_BASE_URL=http://YOUR_LOCAL_IP:8000/v1
```

## Проверки

```bash
flutter analyze
flutter test
```

## iOS

Deployment target проекта синхронизирован на `13.0`. Если pods нужно пересобрать:

```bash
cd ios
pod install
```

После этого можно запускать приложение на iOS Simulator или подключенном iPhone.
