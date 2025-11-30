import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tabs/tab_about_content.dart';
import '../tabs/tab_stats_content.dart';
import 'detail_image.dart';
import 'detail_title.dart';

class DetailPortrait extends StatefulWidget {
  final AppPokemonDetail detail;

  const DetailPortrait({super.key, required this.detail});

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
    final AppPokemonDetail pokemon = widget.detail;
    final color = pokemon.color.secondary;

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
          TabAboutContent(info: widget.detail),
          TabStatsContent(pokemon: widget.detail),
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
            child: DetailImag(imageUrl: widget.detail.imageUrl),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.detail.color.secondary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(DimenRes.size_16),
            child: DetailTitle(pokemon: widget.detail),
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
