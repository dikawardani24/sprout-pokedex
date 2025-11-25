import 'dart:async';

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

class PokemonList extends StatefulWidget {
  final List<Pokemon> pokemons;
  final GestureTapPokemon? onTap;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final GestureLoadMore onLoadMore;

  const PokemonList({
    super.key,
    required this.pokemons,
    this.onTap,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.errorMessage,
    this.onRetry,
    required this.onLoadMore,
  });

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  final _scrollController = ScrollController();
  bool _isLoadingMoreLocal = false;
  Timer? _debounce;

  bool get _shouldLoadMore {
    if (!_scrollController.hasClients) return false;
    if (_isLoadingMoreLocal || widget.hasReachedMax || widget.errorMessage != null) {
      return false;
    }

    return _scrollController.position.extentAfter < 300;
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) return;
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (_shouldLoadMore) {
        _loadMore();
      }
    });
  }

  void _loadMore() {
    if (_isLoadingMoreLocal) return;

    _isLoadingMoreLocal = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLoadMore(widget.pokemons.length);
    });
  }

  @override
  void didUpdateWidget(covariant PokemonList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset local loading state when external loading completes
    if (oldWidget.isLoadingMore && !widget.isLoadingMore) {
      _isLoadingMoreLocal = false;
    }
  }

  Widget _buildAppBar() {
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
            final pokemon = widget.pokemons[index];
            return InkWell(
              onTap: () => widget.onTap?.call(pokemon),
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
          childCount: widget.pokemons.length,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (!widget.isLoadingMore) return const SliverToBoxAdapter();

    return const SliverPadding(
      padding: EdgeInsets.all(20),
      sliver: SliverToBoxAdapter(
        child: Loading(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (widget.errorMessage == null) return const SliverToBoxAdapter();

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringRes.failedLoadMore,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: widget.onRetry,
              child: const Text(StringRes.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndOfList() {
    if (widget.pokemons.isEmpty || !widget.hasReachedMax) {
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

  Widget _buildEmptyState() {
    if (widget.pokemons.isNotEmpty) return const SliverToBoxAdapter();

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

  Widget _buildContent() {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        _buildAppBar(),
        if (widget.pokemons.isNotEmpty) _buildPokemonGrid(),
        _buildEmptyState(),
        _buildLoadingIndicator(),
        _buildErrorWidget(),
        _buildEndOfList(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background decoration
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
        // Content
        _buildContent(),
      ],
    );
  }
}