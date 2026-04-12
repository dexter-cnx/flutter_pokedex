import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_explorer/main.dart';
import 'package:pokedex_explorer/features/pokedex/presentation/providers/pokedex_providers.dart';

void main() {
  testWidgets('renders app shell', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pokemonsProvider.overrideWith((ref) async => []),
          itemsProvider.overrideWith((ref) async => []),
          abilitiesProvider.overrideWith((ref) async => []),
          movesProvider.overrideWith((ref) async => []),
          berriesProvider.overrideWith((ref) async => []),
          locationsProvider.overrideWith((ref) async => []),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('PokéAPI Explorer'), findsWidgets);
    expect(find.text('Pokémon'), findsWidgets);
    expect(find.text('Items'), findsWidgets);
    expect(find.text('Abilities'), findsWidgets);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
