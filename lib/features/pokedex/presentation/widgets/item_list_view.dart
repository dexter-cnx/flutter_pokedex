import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/item_detail_page.dart';
import '../providers/pokedex_providers.dart';
import 'resource_browser_view.dart';

class ItemListView extends ConsumerWidget {
  const ItemListView({super.key});

  String _formatItemName(String value) {
    return value.split('-').map((part) {
      if (part.isEmpty) return part;
      return part[0].toUpperCase() + part.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browseMode = ref.watch(browseModeProvider);

    return ResourceBrowserView(
      browseMode: browseMode,
      pageFetcher: (offset, limit) async {
        final useCase = ref.read(getItemPageUseCaseProvider);
        final page = await useCase(offset: offset, limit: limit);
        return PageResult(
          items: page.items,
          count: page.count,
          offset: page.offset,
          limit: page.limit,
        );
      },
      onRetry: () => ref.invalidate(getItemPageUseCaseProvider),
      searchHint: 'Search items by name',
      emptyMessage: 'No items found.',
      titleBuilder: (item) => _formatItemName(item.name),
      subtitleBuilder: (item) => item.name,
      leadingBuilder: (context, item) => CachedNetworkImage(
        imageUrl: item.spriteUrl,
        width: 44,
        height: 44,
        placeholder: (_, __) => const SizedBox(
          width: 44,
          height: 44,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (_, __, ___) => const Icon(Icons.inventory_2_outlined),
      ),
      onTap: (context, item) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ItemDetailPage(itemName: item.name),
          ),
        );
      },
    );
  }
}
