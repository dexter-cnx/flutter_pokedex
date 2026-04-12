import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/type_detail_entity.dart';
import '../providers/pokedex_providers.dart';
import '../widgets/async_error_view.dart';

class TypeDetailPage extends ConsumerWidget {
  final String typeName;

  const TypeDetailPage({super.key, required this.typeName});

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  Widget _chipGroup(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map((item) =>
                  Chip(label: Text(_capitalize(item.replaceAll('-', ' ')))))
              .toList(growable: false),
        ),
      ],
    );
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

  Widget _buildDetail(TypeDetailEntity type) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _capitalize(type.name),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
              '${_capitalize(type.damageClass)} • ${_capitalize(type.generation)}',
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Row(
            children: [
              _metric('Pokémon', type.pokemonCount.toString()),
              const SizedBox(width: 12),
              _metric('Moves', type.moveCount.toString()),
            ],
          ),
          const SizedBox(height: 24),
          _chipGroup('Double damage from', type.doubleDamageFrom),
          const SizedBox(height: 20),
          _chipGroup('Double damage to', type.doubleDamageTo),
          const SizedBox(height: 20),
          _chipGroup('Half damage from', type.halfDamageFrom),
          const SizedBox(height: 20),
          _chipGroup('Half damage to', type.halfDamageTo),
          const SizedBox(height: 20),
          _chipGroup('No damage from', type.noDamageFrom),
          const SizedBox(height: 20),
          _chipGroup('No damage to', type.noDamageTo),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncType = ref.watch(typeDetailProvider(typeName));

    return Scaffold(
      appBar: AppBar(title: const Text('Type Detail')),
      body: asyncType.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(typeDetailProvider(typeName)),
        ),
        data: _buildDetail,
      ),
    );
  }
}
