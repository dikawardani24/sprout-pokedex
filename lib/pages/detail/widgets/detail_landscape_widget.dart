import 'package:flutter/material.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/models/about_info.dart';
import 'package:sprout_pokedex/pages/detail/tabs/tab_about_content.dart';
import 'package:sprout_pokedex/pages/detail/tabs/tab_stats_content.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_image.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_title.dart';
import 'package:sprout_pokedex/res/color_res.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/string_res.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';

class DetailLandscape extends StatefulWidget {
  final AboutInfo info;

  const DetailLandscape({super.key, required this.info});

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
    final color = widget.info.pokemon.pokedexTypeColor.secondary;
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
          TabAboutContent(info: widget.info),
          TabStatsContent(pokemon: widget.info.pokemon),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Pokemon pokemon = widget.info.pokemon;

    return Container(
      color: widget.info.pokemon.pokedexTypeColor.secondary,
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
                      child: DetailImag(pokemon: pokemon),
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
