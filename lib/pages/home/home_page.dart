import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/navigation/app_navigation.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_bloc.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_event.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_state.dart';
import 'package:sprout_pokedex/pages/home/widget/pokemon_list.dart';
import 'package:sprout_pokedex/pages/loading_page.dart';
import 'package:sprout_pokedex/widgets/error_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onTapPokemon(BuildContext context, Pokemon selected) {
    context.startDetailPage(selected.id);
  }

  void _onLoadMore(BuildContext context) {
    context.read<HomeBloc>().add(GetMorePokemonEvent());
  }

  void _onRetry(BuildContext context) {
    context.read<HomeBloc>().add(GetMorePokemonEvent());
  }

  Widget _buildPokemonList({
    required BuildContext context,
    required List<Pokemon> pokemons,
    bool isLoadingMore = false,
    bool hasReachedMax = false,
    String? errorMessage,
  }) {
    return PokemonList(
      pokemons: pokemons,
      isLoadingMore: isLoadingMore,
      hasReachedMax: hasReachedMax,
      errorMessage: errorMessage,
      onTap: (selected) => _onTapPokemon(context, selected),
      onLoadMore: (_) => _onLoadMore(context),
      onRetry: () => _onRetry(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<HomeBloc>()..add(GetPokemonsEvent()),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return state.when(
                initial: () => const LoadingPage(),
                loading: () => const LoadingPage(),
                loadingMore: (pokemons) => _buildPokemonList(
                  context: context,
                  pokemons: pokemons,
                  isLoadingMore: true,
                ),
                loaded: (pokemons, hasReachedMax) => _buildPokemonList(
                  context: context,
                  pokemons: pokemons,
                  hasReachedMax: hasReachedMax,
                ),
                error: (message) => Center(
                  child: AppErrorWidget(
                    message: message,
                    onRetry: () => context.read<HomeBloc>().add(GetPokemonsEvent()),
                  ),
                ),
                loadMoreError: (pokemons, message) => AppErrorWidget(
                  message: message,
                  onRetry: () => context.read<HomeBloc>().add(GetPokemonsEvent()),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}