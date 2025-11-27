import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Loading extends StatelessWidget {
  final double size;

  const Loading({
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
          ImageRes.pokeBallColoredSamll,
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