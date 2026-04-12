import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/evolution_chain_entity.dart';
import '../providers/pokedex_providers.dart';
import '../widgets/async_error_view.dart';

class EvolutionChainDetailPage extends ConsumerWidget {
  final int chainId;

  const EvolutionChainDetailPage({super.key, required this.chainId});

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  Widget _buildNode(EvolutionChainNodeEntity node, {int depth = 0}) {
    final indent = depth * 16.0;
    return Padding(
      padding: EdgeInsets.only(left: indent, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.catching_pokemon),
              title: Text(_capitalize(node.species)),
              subtitle: node.triggers.isEmpty
                  ? const Text('Base form')
                  : Text(node.triggers.join(' • ')),
            ),
          ),
          ...node.evolvesTo.map((child) => _buildNode(child, depth: depth + 1)),
        ],
      ),
    );
  }

  Widget _buildDetail(EvolutionChainEntity chain) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evolution Chain #${chain.id}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            chain.babyTriggerItem == null
                ? 'No baby trigger item'
                : 'Baby trigger: ${chain.babyTriggerItem}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          _buildNode(chain.chain),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncChain = ref.watch(evolutionChainProvider(chainId));

    return Scaffold(
      appBar: AppBar(title: const Text('Evolution Chain')),
      body: asyncChain.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AsyncErrorView(
          error: error,
          onRetry: () => ref.invalidate(evolutionChainProvider(chainId)),
        ),
        data: _buildDetail,
      ),
    );
  }
}
