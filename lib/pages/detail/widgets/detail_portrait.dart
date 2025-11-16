import 'package:flutter/material.dart';
import 'package:pokedex/pokedex.dart';
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
                    child: Stack(
                      children: [
                        // White background container
                        Positioned(
                          top: 120, // Increased to prevent overlap
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
                                  const SizedBox(height: 40), // Reduced space for overlap
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
                                        Center(child: Text(StringRes.about)),
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
                        // Centered image with limited height
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 160, // Fixed height to prevent covering tabs
                          child: Center(
                            child: DetailImag(pokemon: widget.pokemon),
                          ),
                        ),
                      ],
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