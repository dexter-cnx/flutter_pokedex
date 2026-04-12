import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/berry_detail_entity.dart';
import '../providers/pokedex_providers.dart';
import '../widgets/async_error_view.dart';

class BerryDetailPage extends ConsumerWidget {
  final String berryName;

  const BerryDetailPage({super.key, required this.berryName});

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

  Widget _buildDetail(BerryDetailEntity berry) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _capitalize(berry.name.replaceAll('-', ' ')),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _metric('Size', berry.size.toString()),
              const SizedBox(width: 12),
              _metric('Smoothness', berry.smoothness.toString()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _metric('Growth', berry.growthTime.toString()),
              const SizedBox(width: 12),
              _metric('Harvest', berry.maxHarvest.toString()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _metric('Firmness', berry.firmness),
              const SizedBox(width: 12),
              _metric('Item', berry.itemName),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Flavors',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: berry.flavors
                .map(
                  (flavor) => Chip(
                    label:
                        Text('${_capitalize(flavor.name)} (${flavor.potency})'),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBerry = ref.watch(berryDetailProvider(berryName));

    return Scaffold(
      appBar: AppBar(title: const Text('Berry Detail')),
      body: asyncBerry.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(berryDetailProvider(berryName)),
        ),
        data: _buildDetail,
      ),
    );
  }
}
