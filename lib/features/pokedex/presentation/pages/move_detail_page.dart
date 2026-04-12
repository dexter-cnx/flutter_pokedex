import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/move_detail_entity.dart';
import '../providers/pokedex_providers.dart';
import '../widgets/async_error_view.dart';

class MoveDetailPage extends ConsumerWidget {
  final String moveName;

  const MoveDetailPage({super.key, required this.moveName});

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

  Widget _buildDetail(MoveDetailEntity move) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _capitalize(move.name.replaceAll('-', ' ')),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            '${move.type} • ${move.damageClass}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _metric('Power', move.power?.toString() ?? '—'),
              const SizedBox(width: 12),
              _metric('Accuracy', move.accuracy?.toString() ?? '—'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _metric('PP', move.pp.toString()),
              const SizedBox(width: 12),
              _metric('Priority', move.priority.toString()),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Effect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(move.effect,
                  style: const TextStyle(fontSize: 16, height: 1.5)),
            ),
          ),
          const SizedBox(height: 24),
          Text('Target: ${move.target}'),
          Text('Learned by ${move.learnedByPokemonCount} Pokémon'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMove = ref.watch(moveDetailProvider(moveName));

    return Scaffold(
      appBar: AppBar(title: const Text('Move Detail')),
      body: asyncMove.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(moveDetailProvider(moveName)),
        ),
        data: _buildDetail,
      ),
    );
  }
}
