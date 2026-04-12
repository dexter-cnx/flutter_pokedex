import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/pokemon_detail_entity.dart';
import '../providers/pokedex_providers.dart';
import '../widgets/async_error_view.dart';
import 'species_detail_page.dart';
import 'type_detail_page.dart';

class PokemonDetailPage extends ConsumerWidget {
  final int pokemonId;

  const PokemonDetailPage({super.key, required this.pokemonId});

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  String _formatStatValue(int value) {
    if (value >= 10) return value.toString();
    return value.toString().padLeft(2, '0');
  }

  Widget _buildChipList(
    BuildContext context,
    WidgetRef ref,
    List<String> values, {
    bool tappable = false,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values
          .map(
            (value) => tappable
                ? ActionChip(
                    label: Text(_capitalize(value)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TypeDetailPage(typeName: value),
                        ),
                      );
                    },
                  )
                : Chip(
                    label: Text(_capitalize(value)),
                  ),
          )
          .toList(growable: false),
    );
  }

  Widget _buildAbilityChipList(List<String> values) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values
          .map(
            (value) => Chip(
              label: Text(_capitalize(value)),
            ),
          )
          .toList(growable: false),
    );
  }

  Widget _buildMetricCard(String label, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(
      BuildContext context, WidgetRef ref, PokemonDetailEntity pokemon) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: pokemon.spriteUrl,
              width: 180,
              height: 180,
              fit: BoxFit.contain,
              placeholder: (_, __) => const SizedBox(
                width: 180,
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.catching_pokemon, size: 120),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _capitalize(pokemon.name),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            '#${pokemon.id.toString().padLeft(3, '0')}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      SpeciesDetailPage(speciesName: pokemon.speciesName),
                ),
              );
            },
            icon: const Icon(Icons.travel_explore_outlined),
            label: Text(_capitalize(pokemon.speciesName)),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildMetricCard('Height', '${pokemon.height / 10} m'),
              const SizedBox(width: 12),
              _buildMetricCard('Weight', '${pokemon.weight / 10} kg'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMetricCard(
                  'Base XP', _formatStatValue(pokemon.baseExperience)),
              const SizedBox(width: 12),
              _buildMetricCard('Types', pokemon.types.length.toString()),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Types',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _buildChipList(context, ref, pokemon.types, tappable: true),
          const SizedBox(height: 24),
          const Text(
            'Abilities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _buildAbilityChipList(pokemon.abilities),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPokemon = ref.watch(pokemonDetailProvider(pokemonId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Detail'),
      ),
      body: asyncPokemon.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(pokemonDetailProvider(pokemonId)),
        ),
        data: (pokemon) => _buildDetail(context, ref, pokemon),
      ),
    );
  }
}
