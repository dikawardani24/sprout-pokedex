import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/pages/detail/tabs/tab_about_content.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_imag.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_title.dart';
import 'package:sprout_pokedex/res/color_res.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/image_res.dart';
import 'package:sprout_pokedex/res/string_res.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';

class DetailPortrait extends StatefulWidget {
  final Pokemon pokemon;

  const DetailPortrait({super.key, required this.pokemon});

  @override
  State<DetailPortrait> createState() => _DetailPortraitState();
}

class _DetailPortraitState extends State<DetailPortrait> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabTitles = [
    StringRes.about,
    StringRes.stats,
    StringRes.evolution
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
  }

  Widget _tab() {
    return Stack(
      children: [
        Positioned(
          top: DimenRes.size_120,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(DimenRes.size_16),
                topRight: Radius.circular(DimenRes.size_16),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(DimenRes.size_16),
              child: Column(
                children: [
                  const SizedBox(height: DimenRes.size_40),
                  TabBar(
                    controller: _tabController,
                    labelColor: widget.pokemon.pokedexTypeColor.secondary,
                    unselectedLabelColor: ColorRes.grey,
                    dividerColor: ColorRes.transparent,
                    indicatorColor: widget.pokemon.pokedexTypeColor.secondary,
                    tabs: _tabTitles.map((e) => Tab(text: e)).toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        TabAboutContent(pokemon: widget.pokemon),
                        Center(child: Text(StringRes.stats)),
                        Center(child: Text(StringRes.evolution)),
                      ],
                    ),
                  ),
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
            child: DetailImag(pokemon: widget.pokemon),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: widget.pokemon.pokedexTypeColor.secondary,
          ),
          body: SafeArea(
            child: Container(
              color: widget.pokemon.pokedexTypeColor.secondary,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(DimenRes.size_16),
                    child: DetailTitle(pokemon: widget.pokemon),
                  ),
                  Expanded(
                    child: _tab().animate().moveY(begin: 0, end: 1000, duration: Duration.zero)
                        .animate()
                        .moveY(
                      delay: const Duration(milliseconds: 200),
                      begin: 0,
                      end: -1000,
                      duration: const Duration(milliseconds: 500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Image.asset(ImageRes.pokeBall,
            color: ColorRes.white.withAlpha(20),
          ),
        )
      ],
    );
  }
}