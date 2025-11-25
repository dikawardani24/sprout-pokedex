import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/navigation/app_navigation.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_bloc.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_event.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_state.dart';
import 'package:sprout_pokedex/pages/home/widget/pokemon_list.dart';
import 'package:sprout_pokedex/widgets/error_widget.dart';
import 'package:sprout_pokedex/widgets/loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();
  late final HomeBloc _homeBloc;

  void _onTapPokemon(BuildContext context, Pokemon selected) {
    context.startDetailPage(selected.id);
  }

  void _onLoadMore(BuildContext context) {
    _homeBloc.add(GetMorePokemonEvent());
  }

  void _onRetry(BuildContext context) {
    _homeBloc.add(GetMorePokemonEvent());
  }

  void _initPokemon(BuildContext context) {
    _homeBloc.add(GetPokemonsEvent());
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
      scrollController: _controller,
    );
  }

  @override
  void initState() {
    super.initState();
    _homeBloc = GetIt.I.get<HomeBloc>();
    _homeBloc.add(GetPokemonsEvent());

    _controller.addListener(() {
      if (_controller.position.extentAfter < 300) {
        _homeBloc.add(GetMorePokemonEvent());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          bloc: _homeBloc,
          builder: (context, state) {
            print(state.toString());
            return state.when(
              initial: () => Container(),
              loading: () => const Loading(),
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
              error: (msg) => AppErrorWidget(
                message: msg,
                onRetry: () => _initPokemon(context),
              ),
              loadMoreError: (pokemons, msg) => AppErrorWidget(
                message: msg,
                onRetry: () => _initPokemon(context),
              ),
            );
          },
        ),
      ),
    );
  }
}