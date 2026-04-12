import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/ability_detail_page.dart';
import '../providers/pokedex_providers.dart';
import 'resource_browser_view.dart';

class AbilityListView extends ConsumerWidget {
  const AbilityListView({super.key});

  String _formatName(String value) {
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
        final useCase = ref.read(getNamedApiResourcesPageUseCaseProvider);
        final page = await useCase('/ability', offset: offset, limit: limit);
        return PageResult(
          items: page.items,
          count: page.count,
          offset: page.offset,
          limit: page.limit,
        );
      },
      onRetry: () => ref.invalidate(getNamedApiResourcesPageUseCaseProvider),
      searchHint: 'Search abilities',
      emptyMessage: 'No abilities found.',
      titleBuilder: (item) => _formatName(item.name),
      subtitleBuilder: (item) => item.name,
      leadingBuilder: (_, __) => const CircleAvatar(
        child: Icon(Icons.auto_fix_high),
      ),
      onTap: (context, item) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AbilityDetailPage(abilityName: item.name),
          ),
        );
      },
    );
  }
}
