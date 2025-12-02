import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

import '../tabs/tab_about_content.dart';
import '../tabs/tab_stats_content.dart';
import 'detail_image.dart';
import 'detail_title.dart';

class DetailLandscapeDesktopWidget extends StatefulWidget {
  final AppPokemonDetail detail;

  const DetailLandscapeDesktopWidget({super.key, required this.detail});

  @override
  State<DetailLandscapeDesktopWidget> createState() => _DetailLandscapeDesktopState();
}

class _DetailLandscapeDesktopState extends State<DetailLandscapeDesktopWidget>
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
    final color = widget.detail.color.secondary;
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
          TabAboutContent(info: widget.detail, showDesc: !(AppConfig.isDesktop || AppConfig.isWeb),),
          TabStatsContent(pokemon: widget.detail),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppPokemonDetail pokemon = widget.detail;
    final textTheme = Theme.of(context).textTheme;
    final sectionTheme = textTheme.titleMedium?.copyWith(
      color: ColorRes.white,
      fontWeight: FontWeight.bold,
    );

    return Container(
      color: widget.detail.color.secondary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: DimenRes.size_400,
            child: Padding(
              padding: const EdgeInsets.all(DimenRes.size_16),
              child: Column(
                spacing: DimenRes.size_12,
                children: [
                  DetailTitle(pokemon: pokemon),
                  SizedBox(
                    width: DimenRes.size_200,
                    height: DimenRes.size_200,
                    child: DetailImag(imageUrl: pokemon.imageUrl),
                  ),
                  Expanded(
                    flex: 1,
                    child: AppCard(
                      color: ColorRes.grey.withAlpha(50),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(DimenRes.size_16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: DimenRes.size_16,
                            children: [
                              Text(StringRes.description, style: sectionTheme),
                              ParagraphView(list: pokemon.species.desc, color: ColorRes.white)
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
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
