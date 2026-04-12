import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/species_detail_page.dart';
import '../providers/pokedex_providers.dart';
import 'resource_browser_view.dart';

class SpeciesListView extends ConsumerWidget {
  const SpeciesListView({super.key});

  String _formatName(String value) {
    return value.split('-').map((part) {
      if (part.isEmpty) return part;
      return part[0].toUpperCase() + part.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(speciesProvider);

    return ResourceBrowserView(
      asyncItems: asyncItems,
      onRetry: () => ref.invalidate(speciesProvider),
      searchHint: 'Search species',
      emptyMessage: 'No species found.',
      titleBuilder: (item) => _formatName(item.name),
      subtitleBuilder: (item) => item.name,
      leadingBuilder: (_, __) => const CircleAvatar(
        child: Icon(Icons.psychology_outlined),
      ),
      onTap: (context, item) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SpeciesDetailPage(speciesName: item.name),
          ),
        );
      },
    );
  }
}
