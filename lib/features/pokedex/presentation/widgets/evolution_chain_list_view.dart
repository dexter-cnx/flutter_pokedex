import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/evolution_chain_detail_page.dart';
import '../providers/pokedex_providers.dart';
import 'resource_browser_view.dart';

class EvolutionChainListView extends ConsumerWidget {
  const EvolutionChainListView({super.key});

  int _extractId(String url) {
    final uri = Uri.parse(url);
    final segment = uri.pathSegments.where((value) => value.isNotEmpty).last;
    return int.parse(segment);
  }

  String _formatChainName(String value) {
    final id = _extractId(value);
    return 'Chain #$id';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(evolutionChainsProvider);

    return ResourceBrowserView(
      asyncItems: asyncItems,
      onRetry: () => ref.invalidate(evolutionChainsProvider),
      searchHint: 'Search evolution chains',
      emptyMessage: 'No evolution chains found.',
      titleBuilder: (item) => _formatChainName(item.url),
      subtitleBuilder: (item) => item.url,
      leadingBuilder: (_, __) => const CircleAvatar(
        child: Icon(Icons.account_tree_outlined),
      ),
      onTap: (context, item) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                EvolutionChainDetailPage(chainId: _extractId(item.url)),
          ),
        );
      },
    );
  }
}
