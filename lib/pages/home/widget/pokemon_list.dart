import 'package:flutter/material.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/pages/home/widget/item_pokemon.dart';
import 'package:sprout_pokedex/res/color_res.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/image_res.dart';
import 'package:sprout_pokedex/res/string_res.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';
import 'package:sprout_pokedex/widgets/loading.dart';

typedef GestureTapPokemon = void Function(Pokemon selected);
typedef GestureLoadMore = void Function(int totalCurrent);

class PokemonList extends StatelessWidget {
  final List<Pokemon> pokemons;
  final GestureTapPokemon? onTap;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final GestureLoadMore onLoadMore;
  final ScrollController scrollController;

  const PokemonList({
    super.key,
    required this.pokemons,
    this.onTap,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.errorMessage,
    this.onRetry,
    required this.onLoadMore,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Image.asset(
            ImageRes.pokeBall,
            color: ColorRes.grey.withAlpha(60),
            width: DimenRes.size_200,
            height: DimenRes.size_200,
          ),
        ),

        CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            _buildAppBar(context),

            if (pokemons.isNotEmpty) _buildPokemonGrid(),

            if (pokemons.isEmpty) _buildEmptyState(context),

            if (isLoadingMore) _buildLoadingIndicator(),

            if (errorMessage != null)
              _buildErrorWidget(context),

            if (hasReachedMax && pokemons.isNotEmpty)
              _buildEndOfList(context),
          ],
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      snap: true,
      backgroundColor: ColorRes.white.withAlpha(95),
      floating: true,
      pinned: true,
      scrolledUnderElevation: 10,
      expandedHeight: DimenRes.size_100,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(
          bottom: DimenRes.size_16,
          left: DimenRes.size_16,
          right: DimenRes.size_16,
        ),
        title: Text(
          StringRes.appName,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPokemonGrid() {
    return SliverPadding(
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
            final pokemon = pokemons[index];
            return InkWell(
              onTap: () => onTap?.call(pokemon),
              borderRadius: BorderRadius.circular(12),
              child: ItemPokemon(
                key: ValueKey(pokemon.id),
                id: pokemon.pokenumber,
                name: pokemon.name,
                types: pokemon.typeNames,
                color: pokemon.pokedexTypeColor.secondary,
                imageUrl: pokemon.imageUrl,
              ),
            );
          },
          childCount: pokemons.length,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (!isLoadingMore) return const SliverToBoxAdapter();

    return const SliverPadding(
      padding: EdgeInsets.all(20),
      sliver: SliverToBoxAdapter(
        child: Loading(),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (errorMessage == null) return const SliverToBoxAdapter();

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Text(
              StringRes.failedLoadMore,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.red),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text(StringRes.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndOfList(BuildContext context) {
    if (pokemons.isEmpty || !hasReachedMax) {
      return const SliverToBoxAdapter();
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: Text(
            StringRes.allPokemonLoaded,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    if (pokemons.isNotEmpty) return const SliverToBoxAdapter();

    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageRes.pokeBall,
              color: ColorRes.grey.withAlpha(100),
              width: DimenRes.size_100,
              height: DimenRes.size_100,
            ),
            const SizedBox(height: 16),
            Text(
              StringRes.emptyPokemon,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              StringRes.pullRefresh,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
