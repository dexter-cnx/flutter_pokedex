# Starter Guide

## What this starter includes

This Flutter starter translates the original React Native demo into a Flutter structure using:

- Clean Architecture
- Riverpod
- Dio
- IndexedStack for preserving tab state

## Recommended next steps

### 1. Run the app

```bash
flutter pub get
flutter run
```

### 2. Improve architecture

Recommended upgrades:

- add `freezed` and `json_serializable`
- add repository tests
- replace `FutureProvider` with `AsyncNotifier` if you want refresh logic, pagination, or mutations
- add route layer with `go_router`
- split design system into app theme + reusable widgets

### 3. Production refactor ideas

#### Core
- create `app_exception_mapper.dart`
- create reusable Dio interceptors
- centralize environment config

#### Domain
- keep entities framework-agnostic
- move formatting rules into presentation or dedicated mappers

#### Data
- add DTO parsing tests
- add local cache later with Hive or Isar

#### Presentation
- add feature-level notifiers
- add pull-to-refresh
- add empty states
- add detail page for Pokémon and Items

## Mapping from original repo

- `use()` promise reading → `FutureProvider`
- `Suspense fallback` → `AsyncValue.when(loading: ...)`
- `Activity` → `IndexedStack`
- component lists → feature presentation widgets
