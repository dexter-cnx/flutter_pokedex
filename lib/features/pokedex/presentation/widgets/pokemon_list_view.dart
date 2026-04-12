import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/pokemon_detail_page.dart';
import '../providers/pokedex_providers.dart';
import 'resource_browser_view.dart';

class PokemonListView extends ConsumerWidget {
  const PokemonListView({super.key});

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browseMode = ref.watch(browseModeProvider);
    final apiSource = ref.watch(apiSourceProvider);

    return ResourceBrowserView(
      browseMode: browseMode,
      dataSourceKey: apiSource,
      pageFetcher: (offset, limit) async {
        if (apiSource == ApiSource.graphqlPokemon) {
          final useCase = ref.read(getGraphqlPokemonPageUseCaseProvider);
          final page = await useCase(offset: offset, limit: limit);
          return PageResult(
            items: page.items,
            count: page.count,
            offset: page.offset,
            limit: page.limit,
          );
        }

        final useCase = ref.read(getPokemonPageUseCaseProvider);
        final page = await useCase(offset: offset, limit: limit);
        return PageResult(
          items: page.items,
          count: page.count,
          offset: page.offset,
          limit: page.limit,
        );
      },
      onRetry: () {
        if (apiSource == ApiSource.graphqlPokemon) {
          ref.invalidate(getGraphqlPokemonPageUseCaseProvider);
          return;
        }
        ref.invalidate(getPokemonPageUseCaseProvider);
      },
      searchHint: 'Search Pokémon by name',
      emptyMessage: 'No Pokémon found.',
      titleBuilder: (pokemon) => _capitalize(pokemon.name),
      subtitleBuilder: (pokemon) => '#${pokemon.id.toString().padLeft(3, '0')}',
      leadingBuilder: (context, pokemon) => CachedNetworkImage(
        imageUrl: pokemon.spriteUrl,
        width: 56,
        height: 56,
        placeholder: (_, __) => const SizedBox(
          width: 56,
          height: 56,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (_, __, ___) => const Icon(Icons.catching_pokemon),
      ),
      onTap: (context, pokemon) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PokemonDetailPage(pokemonId: pokemon.id),
          ),
        );
      },
    );
  }
}
