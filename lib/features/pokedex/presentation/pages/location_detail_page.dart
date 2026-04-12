import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/location_detail_entity.dart';
import '../providers/pokedex_providers.dart';
import '../widgets/async_error_view.dart';

class LocationDetailPage extends ConsumerWidget {
  final String locationName;

  const LocationDetailPage({super.key, required this.locationName});

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

  Widget _buildDetail(LocationDetailEntity location) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _capitalize(location.englishName.isNotEmpty
                ? location.englishName
                : location.name.replaceAll('-', ' ')),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(location.region, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Row(
            children: [
              _metric('Game index', location.gameIndex?.toString() ?? '—'),
              const SizedBox(width: 12),
              _metric('Areas', location.areaNames.length.toString()),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Areas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: location.areaNames
                .map(
                  (area) =>
                      Chip(label: Text(_capitalize(area.replaceAll('-', ' ')))),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLocation = ref.watch(locationDetailProvider(locationName));

    return Scaffold(
      appBar: AppBar(title: const Text('Location Detail')),
      body: asyncLocation.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(locationDetailProvider(locationName)),
        ),
        data: _buildDetail,
      ),
    );
  }
}
