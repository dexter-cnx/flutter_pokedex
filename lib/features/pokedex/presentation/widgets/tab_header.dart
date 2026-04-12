import 'package:flutter/material.dart';

class TabHeader extends StatelessWidget {
  const TabHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: TabBar(
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
            ),
          ),
        ],
      ),
    );
  }
}
