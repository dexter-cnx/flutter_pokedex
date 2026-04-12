# PokéAPI Explorer

This project is a Flutter PokéAPI explorer built with Flutter.
The repository name is `flutter_pokedex`.

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

## API Implementation

The app talks directly to [PokéAPI](https://pokeapi.co/api/v2) and, for the Pokémon tab, an alternate GraphQL source through a clean data flow:

- `presentation` layer decides which category tab and browse mode to show
- `domain` layer defines entities, repositories, and use cases
- `data` layer uses `Dio` to call PokéAPI endpoints and map JSON into entities
- the Pokémon tab can switch between PokéAPI and GraphQL Pokémon from the header

### Base endpoints

The app uses these list endpoints for browsing:

- `/pokemon`
- `/item`
- `/ability`
- `/move`
- `/berry`
- `/type`
- `/pokemon-species`
- `/evolution-chain`
- `/location`
- `/location-area`

The app uses these detail endpoints when you tap an item in a list:

- `/pokemon/{id}`
- `/item/{name}`
- `/ability/{name}`
- `/move/{name}`
- `/berry/{name}`
- `/type/{name}`
- `/pokemon-species/{name}`
- `/evolution-chain/{id}`
- `/location/{name}`
- `/location-area/{name}`

### Browse modes

Each list supports three loading strategies:

- `Pagination` loads one page from the API at a time using `offset` and `limit`
- `Lazy loading` appends the next page when the user taps `Load more`
- `Infinite scroll` automatically requests the next page when the user reaches the bottom

### GraphQL Pokémon source

The GraphQL source is based on the Pokémon-specific API documented on the GraphQL Pokémon guide site. The guide URL is:

- [https://graphql-pokemon.vercel.app/](https://graphql-pokemon.vercel.app/)

The working API endpoint used by the app is:

- `https://graphqlpokemon.favware.tech/v8/`

This source currently powers the Pokémon list browsing flow:

- `getAllPokemon(offset, take)` is used for paging the Pokémon tab
- `getPokemonByDexNumber(number)` is used for Pokémon detail
- list rows map `num`, `species`, and `sprite` into the app's Pokémon entity
- detail maps the GraphQL response into the Pokémon detail screen, including flavor text, base stats total, evolutions, and alternate sprites
- the rest of the categories still use PokéAPI because the GraphQL Pokémon API is focused on Pokémon data

### Paging behavior

The reusable browser widget sends `offset` and `limit` to the repository layer and receives a page result with:

- `items`
- `count`
- `offset`
- `limit`

That lets the app show the correct page number, know whether more data exists, and reuse the same UI for both full browsing and incremental loading.

### Detail data mapping

Some detail pages derive extra values from the API response:

- Pokémon detail reads sprite, species, types, abilities, height, weight, and base experience
- Item detail reads sprite, cost, category, and effect text
- Type detail reads damage relations and counts of Pokémon and moves
- Species detail reads evolution chain URL, egg groups, flavor text, and evolution metadata
- Evolution chain detail resolves the chain ID from the returned resource URL

### Why this structure

This design keeps the UI simple and makes the app easier to extend:

- adding a new category usually means adding one endpoint mapping, one provider, and one list/detail page
- changing the browse mode does not require rewriting each tab
- the repository and data source stay responsible for API behavior, while the UI stays focused on presentation

## Features

- Pokémon, items, abilities, moves, berries, types, species, evolution chains, locations, and location areas
- Search, filter, pagination, lazy loading, and infinite scroll in every category
- PokéAPI or GraphQL source selection for the Pokémon tab
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
