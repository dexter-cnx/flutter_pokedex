import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ability_detail_entity.dart';
import '../providers/pokedex_providers.dart';
import '../widgets/async_error_view.dart';

class AbilityDetailPage extends ConsumerWidget {
  final String abilityName;

  const AbilityDetailPage({super.key, required this.abilityName});

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

  Widget _buildDetail(AbilityDetailEntity ability) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _capitalize(ability.name.replaceAll('-', ' ')),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(ability.generation, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Row(
            children: [
              _metric('Pokémon', ability.pokemonCount.toString()),
              const SizedBox(width: 12),
              _metric('Main series', ability.isMainSeries ? 'Yes' : 'No'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Effect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(ability.effect,
                  style: const TextStyle(fontSize: 16, height: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAbility = ref.watch(abilityDetailProvider(abilityName));

    return Scaffold(
      appBar: AppBar(title: const Text('Ability Detail')),
      body: asyncAbility.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(abilityDetailProvider(abilityName)),
        ),
        data: _buildDetail,
      ),
    );
  }
}
