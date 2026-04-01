# 꽃 지도 (Flower Map)

A Flutter prototype app that shows representative flower viewing locations across Korea on an interactive map.

## Features

- **Interactive Map** – Powered by [flutter_map](https://pub.dev/packages/flutter_map) with OpenStreetMap tiles (no API key required)
- **Flower Location Markers** – Colour-coded emoji markers for 8 flower types:
  - 🌸 벚꽃 (Cherry Blossom)
  - 🌼 개나리 (Forsythia)
  - 🌺 진달래 (Azalea)
  - 💜 등나무 (Wisteria)
  - 🤍 목련 (Magnolia)
  - 🌻 유채꽃 (Rapeseed)
  - 🌸 코스모스 (Cosmos)
  - 🌻 해바라기 (Sunflower)
- **Filter Bar** – Toggle individual flower types on/off
- **Detail Sheet** – Tap any marker to view location name, address, bloom season and description
- **공공데이터포털 API Ready** – Plug in your [data.go.kr](https://www.data.go.kr) service key to fetch live data

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0

### Run the app

```bash
flutter pub get
flutter run
```

### Connecting to the 공공데이터포털 API

1. Register at [data.go.kr](https://www.data.go.kr) and request access to the flower viewing spots dataset (`15106827`).
2. Open `lib/services/flower_data_service.dart` and set your service key:

```dart
static const String _apiKey = 'YOUR_SERVICE_KEY_HERE';
```

When a valid key is provided, the app fetches live data from the API. It falls back to the built-in sample dataset if the key is empty or the request fails.

## Project Structure

```
lib/
├── main.dart                     # App entry point
├── models/
│   └── flower_location.dart      # FlowerLocation model & FlowerType enum
├── screens/
│   └── map_screen.dart           # Main map screen with markers & filter bar
├── services/
│   └── flower_data_service.dart  # Data layer (API + sample data)
└── widgets/
    └── flower_widgets.dart       # Reusable UI components

test/
├── flower_location_test.dart     # Unit tests for FlowerLocation model
└── flower_data_service_test.dart # Unit tests for FlowerDataService
```

## Running Tests

```bash
flutter test
```