
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sprout_pokedex/navigation/app_navigation.dart';
import 'package:sprout_pokedex/pages/error_page.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_bloc.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_event.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_state.dart';
import 'package:sprout_pokedex/pages/home/widget/pokemon_list.dart';
import 'package:sprout_pokedex/pages/loading_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => GetIt.I.get<HomeBloc>()..add(GetPokemonsEvent()),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (c, state) {
              final status = state.status;
              if (Status.loading == status) {
                return const LoadingPage();
              }
              if (Status.error == status) {
                return const ErrorPage();
              }

              return PokemonList(
                pokemons: state.pokemons,
                onTap: (selectedId) => context.startDetailPage(selectedId),
              );
            },
          ),
        ),
      ),
    );
  }
}