import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/item_detail_entity.dart';
import '../providers/pokedex_providers.dart';
import '../widgets/async_error_view.dart';

class ItemDetailPage extends ConsumerWidget {
  final String itemName;

  const ItemDetailPage({super.key, required this.itemName});

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
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

  Widget _buildDetail(ItemDetailEntity item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: item.spriteUrl,
              width: 160,
              height: 160,
              fit: BoxFit.contain,
              placeholder: (_, __) => const SizedBox(
                width: 160,
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.inventory_2_outlined, size: 120),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _capitalize(item.name.replaceAll('-', ' ')),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            item.category,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildMetricCard('Cost', item.cost.toString()),
              const SizedBox(width: 12),
              _buildMetricCard('Category', item.category),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Effect',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                item.effect,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItem = ref.watch(itemDetailProvider(itemName));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Detail'),
      ),
      body: asyncItem.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(itemDetailProvider(itemName)),
        ),
        data: _buildDetail,
      ),
    );
  }
}
