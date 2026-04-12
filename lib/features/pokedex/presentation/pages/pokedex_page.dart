import 'package:flutter/material.dart';

import '../widgets/ability_list_view.dart';
import '../widgets/berry_list_view.dart';
import '../widgets/evolution_chain_list_view.dart';
import '../widgets/item_list_view.dart';
import '../widgets/location_area_list_view.dart';
import '../widgets/location_list_view.dart';
import '../widgets/move_list_view.dart';
import '../widgets/pokemon_list_view.dart';
import '../widgets/species_list_view.dart';
import '../widgets/tab_header.dart';
import '../widgets/type_list_view.dart';
import '../providers/pokedex_providers.dart';

class PokedexPage extends StatelessWidget {
  const PokedexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: PokedexTab.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pokedex'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const TabHeader(),
            Expanded(
              child: TabBarView(
                children: const [
                  PokemonListView(),
                  ItemListView(),
                  AbilityListView(),
                  MoveListView(),
                  BerryListView(),
                  TypeListView(),
                  SpeciesListView(),
                  EvolutionChainListView(),
                  LocationListView(),
                  LocationAreaListView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
