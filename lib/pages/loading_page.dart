import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/image_res.dart';

class LoadingPage extends StatelessWidget {
  final double size;

  const LoadingPage({
    super.key,
    this.size = DimenRes.size_100,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          ImageRes.pokeBallColored,
        ),
      ),
    )
        .animate()
        .fade()
        .scale()
        .then()
        .animate(
      onPlay: (controller) => controller.repeat(),
    )
        .rotate(duration: const Duration(seconds: 1))
        .then();
  }
}