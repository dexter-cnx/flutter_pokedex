import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pokedex_providers.dart';

class TabHeader extends ConsumerWidget {
  const TabHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browseMode = ref.watch(browseModeProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PokéAPI Explorer',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Browse Pokémon, items, abilities, moves, berries, types, species, evolution chains, locations, and location areas.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                children: [
                  const TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: 'Pokémon'),
                      Tab(text: 'Items'),
                      Tab(text: 'Abilities'),
                      Tab(text: 'Moves'),
                      Tab(text: 'Berries'),
                      Tab(text: 'Types'),
                      Tab(text: 'Species'),
                      Tab(text: 'Evolution'),
                      Tab(text: 'Locations'),
                      Tab(text: 'Areas'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<BrowseMode>(
                    segments: const [
                      ButtonSegment(
                        value: BrowseMode.pagination,
                        label: Text('Pagination'),
                        icon: Icon(Icons.looks_one_outlined),
                      ),
                      ButtonSegment(
                        value: BrowseMode.lazyLoading,
                        label: Text('Lazy'),
                        icon: Icon(Icons.auto_awesome_outlined),
                      ),
                      ButtonSegment(
                        value: BrowseMode.infiniteScroll,
                        label: Text('Infinite'),
                        icon: Icon(Icons.vertical_align_bottom_outlined),
                      ),
                    ],
                    selected: {browseMode},
                    onSelectionChanged: (selection) {
                      ref.read(browseModeProvider.notifier).state =
                          selection.first;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
