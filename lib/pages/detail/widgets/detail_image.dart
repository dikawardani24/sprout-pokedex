import 'package:flutter/material.dart';
import 'package:pokedex/pokedex.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/image_res.dart';
import 'package:sprout_pokedex/util/pokemon_ext.dart';
import 'package:sprout_pokedex/widgets/app_network_image.dart';
import 'package:sprout_pokedex/widgets/circular_matrix.dart';

class DetailImag extends StatelessWidget {
  final Pokemon pokemon;

  const DetailImag({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsetsGeometry.only(left: DimenRes.size_60),
          child: Image.asset(ImageRes.pokeBallColored,
            width: DimenRes.size_200,
            height: DimenRes.size_200,
          ),
        ),
        const CircularMatrix(
          rows: 7,
          columns: 5,
        ),
        AppNetworkImage(
            imageUrl: pokemon.imageUrl,
            imageSize: DimenRes.size_80,
            imageErrSize: DimenRes.size_60
        )
      ],
    );
  }

}