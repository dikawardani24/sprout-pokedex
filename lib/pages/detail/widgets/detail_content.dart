import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_landscape_widget.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_portrait.dart';

class DetailContent extends StatelessWidget {
  final AppPokemonDetail detail;

  const DetailContent({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width > 600) {
          return DetailLandscape(detail: detail);
        } else {
          return DetailPortrait(detail: detail);
        }
      },
    );
  }
}