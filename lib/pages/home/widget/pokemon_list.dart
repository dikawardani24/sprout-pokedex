import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_bloc.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_event.dart';
import 'package:sprout_pokedex/pages/home/bloc/home_state.dart';
import 'package:sprout_pokedex/pages/loading_page.dart';
import 'package:sprout_pokedex/res/color_res.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/string_res.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';
import 'package:sprout_pokedex/pages/home/widget/item_pokemon.dart';

typedef GestureTapPokemon = void Function(int id);

class PokemonList extends StatefulWidget{
  final List<Pokemon> pokemons;
  final GestureTapPokemon? onTap;

  const PokemonList({
    super.key,
    required this.pokemons,
    this.onTap
  });

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  final _scrollController = ScrollController();

  bool get _isBottomReached {
    if (!_scrollController.hasClients) {
      return false;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScrollListener() {
    if (_isBottomReached) {
      context.read<HomeBloc>().add(GetMorePokemonEvent());
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.watch<HomeBloc>().state;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          snap: true,
          backgroundColor: ColorRes.white.withAlpha(95),
          floating: true,
          pinned: true,
          scrolledUnderElevation: 10,
          expandedHeight: DimenRes.size_100,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: const EdgeInsets.only(bottom: DimenRes.size_16, left: DimenRes.size_16, right: DimenRes.size_16),
            title: Text(
              StringRes.appName,
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(DimenRes.size_12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: DimenRes.size_200,
              mainAxisExtent: DimenRes.size_180,
              crossAxisSpacing: DimenRes.size_12,
              mainAxisSpacing: DimenRes.size_12,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final e = state.pokemons[index];
                return InkWell(
                  onTap: () {
                    widget.onTap?.call(e.id);
                  },
                  child: ItemPokemon(
                    id: e.pokenumber,
                    name: e.name,
                    types: e.types.map((type) => type.type.name).toList(),
                    color: e.pokedexTypeColor.secondary,
                    imageUrl: e.imageUrl,
                  ),
                );
              },
              childCount: state.pokemons.length,
            ),
          ),
        ),
        if (state.status == Status.loadingMore) const SliverPadding(
          padding: EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: LoadingPage(),
          ),
        )
      ],
    );
  }
}