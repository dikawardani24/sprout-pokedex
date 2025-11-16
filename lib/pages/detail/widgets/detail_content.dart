import 'package:flutter/material.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_landscape_widget.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_portrait.dart';

class DetailContent extends StatelessWidget {
  final Pokemon pokemon;

  const DetailContent({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width > 600) {
          return DetailLandscape(pokemon: pokemon);
        } else {
          return DetailPortrait(pokemon: pokemon);
        }
      },
    );
  }
}