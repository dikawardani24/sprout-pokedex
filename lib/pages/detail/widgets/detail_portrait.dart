import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

class DetailPortrait extends StatefulWidget {
  final AboutInfo info;

  const DetailPortrait({super.key, required this.info});

  @override
  State<DetailPortrait> createState() => _DetailPortraitState();
}

class _DetailPortraitState extends State<DetailPortrait>
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
    final Pokemon pokemon = widget.info.pokemon;
    final color = pokemon.pokedexTypeColor.secondary;

    return TabBar(
      controller: _tabController,
      labelColor: color,
      unselectedLabelColor: ColorRes.grey,
      indicatorColor: color,
      dividerColor: Colors.transparent,
      tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
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

  Widget _buildTabContainer() {
    return Stack(
      children: [
        Positioned.fill(
          top: DimenRes.size_120,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(DimenRes.size_16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(DimenRes.size_16),
              child: Column(
                children: [
                  const SizedBox(height: DimenRes.size_40),
                  _buildTabBar(),
                  _buildTabView(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 160,
          child: Center(
            child: DetailImag(pokemon: widget.info.pokemon),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.info.pokemon.pokedexTypeColor.secondary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(DimenRes.size_16),
            child: DetailTitle(pokemon: widget.info.pokemon),
          ),

          /// Tab Container + Animation
          Expanded(
            child: _buildTabContainer()
                .animate()
                .moveY(
              begin: 1000,
              end: 0,
              duration: 500.ms,
              curve: Curves.easeOut,
            ),
          ),
        ],
      ),
    );
  }
}
