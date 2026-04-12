import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/pokemon_species_detail_entity.dart';
import '../providers/pokedex_providers.dart';
import '../widgets/async_error_view.dart';
import 'evolution_chain_detail_page.dart';

class SpeciesDetailPage extends ConsumerWidget {
  final String speciesName;

  const SpeciesDetailPage({super.key, required this.speciesName});

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  Widget _metric(String label, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  int? _extractChainId(String url) {
    if (url.isEmpty) return null;
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    final segment = uri.pathSegments.where((e) => e.isNotEmpty).isEmpty
        ? null
        : uri.pathSegments.where((e) => e.isNotEmpty).last;
    return segment == null ? null : int.tryParse(segment);
  }

  Widget _buildDetail(
      BuildContext context, WidgetRef ref, PokemonSpeciesDetailEntity species) {
    final chainId = _extractChainId(species.evolutionChainUrl);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _capitalize(species.name),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
              '${_capitalize(species.color)} • ${_capitalize(species.generation)}',
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Row(
            children: [
              _metric('Capture', species.captureRate.toString()),
              const SizedBox(width: 12),
              _metric('Happiness', species.baseHappiness.toString()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _metric('Habitat', species.habitat ?? 'Unknown'),
              const SizedBox(width: 12),
              _metric('Egg groups', species.eggGroups.length.toString()),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                species.flavorText,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: species.eggGroups
                .map((group) => Chip(label: Text(_capitalize(group))))
                .toList(growable: false),
          ),
          const SizedBox(height: 24),
          Text('Evolves from: ${species.evolvesFromSpecies ?? 'N/A'}'),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: chainId == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            EvolutionChainDetailPage(chainId: chainId),
                      ),
                    );
                  },
            icon: const Icon(Icons.account_tree_outlined),
            label: const Text('View evolution chain'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSpecies = ref.watch(speciesDetailProvider(speciesName));

    return Scaffold(
      appBar: AppBar(title: const Text('Species Detail')),
      body: asyncSpecies.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(speciesDetailProvider(speciesName)),
        ),
        data: (species) => _buildDetail(context, ref, species),
      ),
    );
  }
}
