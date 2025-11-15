import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/image_res.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: DimenRes.size_100,
        height: DimenRes.size_100,
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