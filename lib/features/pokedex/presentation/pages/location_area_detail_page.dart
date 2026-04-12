import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/location_area_detail_entity.dart';
import '../providers/pokedex_providers.dart';
import '../widgets/async_error_view.dart';

class LocationAreaDetailPage extends ConsumerWidget {
  final String areaName;

  const LocationAreaDetailPage({super.key, required this.areaName});

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

  Widget _buildDetail(LocationAreaDetailEntity area) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _capitalize(area.name),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(_capitalize(area.location),
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Row(
            children: [
              _metric('Game index', area.gameIndex.toString()),
              const SizedBox(width: 12),
              _metric('Encounters', area.pokemonEncounters.length.toString()),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Encounter Methods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...area.encounterMethods.map(
            (method) => Card(
              child: ListTile(
                leading: const Icon(Icons.bolt),
                title: Text(_capitalize(method.method)),
                subtitle: method.versions.isEmpty
                    ? const Text('No versions listed')
                    : Text(method.versions.map(_capitalize).join(', ')),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Pokémon Encounters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: area.pokemonEncounters
                .map((name) => Chip(label: Text(_capitalize(name))))
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncArea = ref.watch(locationAreaDetailProvider(areaName));

    return Scaffold(
      appBar: AppBar(title: const Text('Location Area Detail')),
      body: asyncArea.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(locationAreaDetailProvider(areaName)),
        ),
        data: _buildDetail,
      ),
    );
  }
}
