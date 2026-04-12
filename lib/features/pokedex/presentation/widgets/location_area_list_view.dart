import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/location_area_detail_page.dart';
import '../providers/pokedex_providers.dart';
import 'resource_browser_view.dart';

class LocationAreaListView extends ConsumerWidget {
  const LocationAreaListView({super.key});

  String _formatName(String value) {
    return value.split('-').map((part) {
      if (part.isEmpty) return part;
      return part[0].toUpperCase() + part.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(locationAreasProvider);

    return ResourceBrowserView(
      asyncItems: asyncItems,
      onRetry: () => ref.invalidate(locationAreasProvider),
      searchHint: 'Search location areas',
      emptyMessage: 'No location areas found.',
      titleBuilder: (item) => _formatName(item.name),
      subtitleBuilder: (item) => item.name,
      leadingBuilder: (_, __) => const CircleAvatar(
        child: Icon(Icons.map_outlined),
      ),
      onTap: (context, item) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LocationAreaDetailPage(areaName: item.name),
          ),
        );
      },
    );
  }
}
