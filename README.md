# Miquido — Gym & FitBot AI Flutter Application

[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![GetX](https://img.shields.io/badge/State%20Management-GetX-8A2BE2)](https://pub.dev/packages/get)
[![Storage](https://img.shields.io/badge/Local%20Storage-GetStorage-0070F0)](https://pub.dev/packages/get_storage)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%26%20SOLID-00C12B)](#clean-architecture--solid-design)
[![Tests](https://img.shields.io/badge/Tests-5%20Passed-brightgreen)](https://flutter.dev)

A modern, high-performance Flutter Gym & Fitness AI Chatbot application built from the [Miquido Gym Chatbot App Figma Design System](https://www.figma.com/design/9hAHsqg5TmP3NFeG3Jz4ma/Miquido---Gym-Chatbot-App-Concept--Community-). 

Powered by **GetX** reactive state management, **GetStorage** local persistence, and **Clean Architecture (Domain, Data, Presentation)**.

---

## 📱 Implemented Figma Screens

| Screen | Figma Node | Description |
|---|---|---|
| **Home Dashboard** | `403:3051` | Upcoming workout cards with custom vector runner illustration, nearby gyms with distance/ratings, and weekly activity curve chart with Wednesday peak indicator & tooltip. |
| **Statistics** | `403:3246` | Month selector, 7-day week calendar strip with active indicator, Overview metric cards (Cal Burnt, Total Time, Exercises, Breaks), triple concentric progress rings (Sleep 76%, Calories 52%, Steps 33%), and weekly calories bar chart. |
| **FitBot AI Chatbot** | `403:2913` | Personal sports concierge with active online status, conversation bubble thread, interactive quick-reply chips, gym recommendation cards with amenity tags (Gym, SPA, Pool), and voice/text input bar. |
| **Facility Details & Booking** | Extension | Dedicated gym view with distance, ratings, pricing, amenities tags, and instant booking with FitBot confirmation. |
| **Workout Detail & Tracking** | Extension | Workout breakdown, exercise intervals, warmup instructions, and completion logger. |
| **Explore & Discover** | Extension | Search sports facilities, trainers, and fitness studios. |
| **Profile & Settings** | Extension | Member account, cache management, and local storage controls. |

---

## 🏛️ Clean Architecture & SOLID Design

The codebase strictly adheres to **Clean Architecture** and **SOLID principles**:

```
lib/
├── core/
│   ├── storage/                # IStorageService abstraction & GetStorage implementation
│   └── theme/                  # Brand palette, DM Sans typography & theme data
├── features/
│   ├── home/
│   │   ├── domain/             # Pure Dart entities, repository contracts & usecases
│   │   ├── data/               # Models with JSON serialization & local data sources
│   │   └── presentation/       # GetX controllers, views & custom painters
│   ├── statistics/
│   │   ├── domain/             # UserMetricEntity, DayProgressEntity & usecases
│   │   ├── data/               # Local datasource & storage persistence
│   │   └── presentation/       # ConcentricProgressRings, WeekCalendarStrip & chart
│   ├── chatbot/
│   │   ├── domain/             # ChatMessageEntity, GymFacilityEntity & usecases
│   │   ├── data/               # Conversational logic engine & booking persistence
│   │   └── presentation/       # FitBot chat bubbles, facility card & input dock
│   ├── facilities/
│   │   └── presentation/       # Facility details & pass booking modal
│   └── navigation/
│       └── presentation/       # Floating rounded pill nav bar & master scaffold
└── routes/
    ├── app_routes.dart         # Type-safe route definitions
    └── app_pages.dart          # Route configurations & dependency injection bindings
```

### SOLID Adherence:
- **Single Responsibility Principle (SRP):** Each controller, use case, and repository manages a single bounded domain.
- **Open/Closed Principle (OCP):** Use cases and storage services depend on abstractions (`IStorageService`, `IHomeRepository`, `IChatbotRepository`), easily extendable without modifying existing code.
- **Liskov Substitution Principle (LSP):** `StorageService` seamlessly substitutes `IStorageService`, enabling zero-cost mock injection in tests.
- **Interface Segregation Principle (ISP):** Contracts are granular and specific.
- **Dependency Inversion Principle (DIP):** High-level domain logic never imports data or presentation modules.

---

## 🚀 Key Features

- **⚡ Reactive State Management:** Powered by GetX reactive observables (`RxBool`, `RxList`, `Rxn`) with fine-grained UI rebuilds.
- **💾 Local Storage Persistence:** Uses `GetStorage` to persist conversation history, gym pass bookings, and user metrics across app restarts.
- **🎨 Custom Vector Graphics:**
  - `ConcentricProgressRings`: Custom-painted triple concentric rings with glowing progress endpoints.
  - `ActivitiesChart`: Smooth cubic Bezier curve with gradient fill and peak tooltip pill (`3h 14min`).
  - `WorkoutCard`: Custom-painted runner vector illustration on treadmill platform.
  - `FloatingNavBar`: Rounded floating pill bottom navigation bar matching the Figma prototype.
- **🤖 Contextual FitBot Assistant:**
  - Natural conversation replies for gym bookings, routines, calorie tracking, and facility options.
  - Interactive quick reply suggestion chips.
  - Facility booking engine with instant snackbar confirmations.

---

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK `^3.13.2` or higher
- Dart SDK `^3.13.2`

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jihanurrahman33/Miquido-GYM-Chatbot-App.git
   cd Miquido-GYM-Chatbot-App
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run static analysis:**
   ```bash
   flutter analyze
   ```

4. **Run test suite:**
   ```bash
   flutter test
   ```

5. **Run the application:**
   ```bash
   flutter run
   ```

---

## 🧪 Testing

The project includes unit and widget tests verifying clean architecture layers and local storage behavior:
```bash
flutter test
```
- `test/unit/chatbot_repository_test.dart`: Validates conversation flow, bot responses, and booking persistence.
- `test/unit/statistics_usecase_test.dart`: Validates metrics calculation and concentric ring percentages.
- `test/widget_test.dart`: Smoke test verifying root views, navigation, and dependency injection.

---

## 📄 License
This project is open-source and available under the [MIT License](LICENSE).
