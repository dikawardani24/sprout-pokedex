import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_portrait.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_title.dart';
import 'package:sprout_pokedex/pages/loading_page.dart';
import 'package:sprout_pokedex/res/color_res.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/image_res.dart';
import 'package:sprout_pokedex/res/string_res.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';
import 'package:sprout_pokedex/widgets/circular_matrix.dart';

class DetailContent extends StatefulWidget {
  final Pokemon pokemon;

  const DetailContent({super.key, required this.pokemon});

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> with TickerProviderStateMixin{
  late TabController _tabController;
  List<String> tabTitles = [
    StringRes.about,
    StringRes.stats,
    StringRes.evolution
  ];

  Widget _createTitle() {
    return  Padding(
      padding: const EdgeInsetsGeometry.all(DimenRes.size_16),
      child: DetailTitle(pokemon: widget.pokemon),
    );
  }

  Widget _createImage() {
    return CachedNetworkImage(
      imageUrl: widget.pokemon.imageUrl,
      fit: BoxFit.fill,
      placeholder: (context, child)  => const Center(
        child: SizedBox(
          width: DimenRes.size_80,
          height: DimenRes.size_80,
          child: LoadingPage(size: DimenRes.size_200,),
        ),
      ),
      errorWidget: (context, error, trace) => Icon(
          Icons.error,
          color: ColorRes.black.withAlpha(20),
          size: DimenRes.size_60
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DetailPortrait(pokemon: widget.pokemon);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: widget.pokemon.pokedexTypeColor.secondary,
      ),
      body: SafeArea(
        child: Container(
          color: widget.pokemon.pokedexTypeColor.secondary,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsetsGeometry.only(top: DimenRes.size_60),
                  child: Image.asset(ImageRes.pokeBallColored,
                    width: DimenRes.size_200,
                    height: DimenRes.size_200,
                  ),
                ),
              ),
              Column(
                children: [
                  _createTitle(),
                  SizedBox(height: DimenRes.size_120,),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(DimenRes.size_16),
                          topRight: Radius.circular(DimenRes.size_16),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsetsGeometry.all(DimenRes.size_16),
                        child: Column(
                          children: [
                            TabBar(
                              controller: _tabController,
                              labelColor: widget.pokemon.pokedexTypeColor.secondary,
                              unselectedLabelColor: ColorRes.grey,
                              dividerColor: ColorRes.transparent,
                              indicatorColor: widget.pokemon.pokedexTypeColor.secondary,
                              tabs: tabTitles.map((e) => Tab(text: e,)).toList(),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: DimenRes.size_80, top: DimenRes.size_100),
                  child: CircularMatrix(
                    rows: 7,
                    columns: 5,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: DimenRes.size_80,),
                    _createImage()
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
    );
  }
}