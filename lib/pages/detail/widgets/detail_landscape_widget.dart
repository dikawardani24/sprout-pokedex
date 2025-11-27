import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:sprout_pokedex/pages/detail/tabs/tab_about_content.dart';
import 'package:sprout_pokedex/pages/detail/tabs/tab_stats_content.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_image.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_title.dart';

class DetailLandscape extends StatefulWidget {
  final AppPokemonDetail detail;

  const DetailLandscape({super.key, required this.detail});

  @override
  State<DetailLandscape> createState() => _DetailLandscapeState();
}

class _DetailLandscapeState extends State<DetailLandscape>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  final List<String> _tabTitles = [
    StringRes.about,
    StringRes.stats,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  Widget _buildTabBar() {
    final color = widget.detail.pokedexTypeColor.secondary;
    return TabBar(
      controller: _tabController,
      labelColor: color,
      unselectedLabelColor: ColorRes.grey,
      indicatorColor: color,
      dividerColor: Colors.transparent,
      isScrollable: true,
      tabs: _tabTitles.map((e) => Tab(text: e)).toList(),
    );
  }

  Widget _buildTabView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          TabAboutContent(info: widget.detail),
          TabStatsContent(pokemon: widget.detail),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppPokemonDetail pokemon = widget.detail;

    return Container(
      color: widget.detail.pokedexTypeColor.secondary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(DimenRes.size_16),
              child: Column(
                children: [
                  DetailTitle(pokemon: pokemon),
                  const SizedBox(height: DimenRes.size_24),

                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: DetailImag(imageUrl: pokemon.imageUrl),
                    ),
                  ),
                ],
              )
              ,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(DimenRes.size_16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(DimenRes.size_16),
                child: Column(
                  children: [
                    _buildTabBar(),
                    const SizedBox(height: DimenRes.size_16),
                    _buildTabView(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
