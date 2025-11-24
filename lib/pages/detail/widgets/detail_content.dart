import 'package:flutter/material.dart';
import 'package:sprout_pokedex/models/about_info.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_landscape_widget.dart';
import 'package:sprout_pokedex/pages/detail/widgets/detail_portrait.dart';

class DetailContent extends StatelessWidget {
  final AboutInfo info;

  const DetailContent({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width > 600) {
          return DetailLandscape(info: info);
        } else {
          return DetailPortrait(info: info);
        }
      },
    );
  }
}