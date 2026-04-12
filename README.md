# PokéAPI Explorer

This project is a Flutter PokéAPI explorer built with Flutter.

## Goal

Translate the original React Native demo concepts into Flutter using:

- Clean Architecture
- Riverpod
- Dio
- TabBar and TabBarView for category browsing

## Concept Mapping

- Future-based data loading → Riverpod `FutureProvider` + `AsyncValue`
- Category browsing → Flutter `TabBar` + `TabBarView`
- Promise-based fetch helpers → Dio-powered remote data source

## Features

- Pokémon, items, abilities, moves, berries, types, species, evolution chains, locations, and location areas
- Search, filter, and pagination in every category
- Loading skeletons
- Error state
- Simple clean architecture separation

## Run

```bash
flutter pub get
flutter run
```

## Structure

```text
lib/
  core/
  features/
    pokedex/
      data/
      domain/
      presentation/
```
