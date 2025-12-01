import 'dart:math';

import 'package:flutter/material.dart';

import '../res/color_res.dart';
import '../res/image_res.dart';

class AppAnimateRotateImg extends StatefulWidget {
  final bool isShow;
  final Alignment alignment;
  final BoxConstraints boxConstraints;

  const AppAnimateRotateImg({
    super.key,
    required this.isShow,
    required this.alignment,
    required this.boxConstraints
  });

  @override
  State<AppAnimateRotateImg> createState() => _AppAnimateRotateImgState();
}

class _AppAnimateRotateImgState extends State<AppAnimateRotateImg> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isShow) return SizedBox.shrink();
    return IgnorePointer(
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 500),
        alignment: widget.alignment,
        child: AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationController.value * 2 * pi,
              child: child,
            );
          },
          child: Image.asset(
            ImageRes.pokeBall,
            color: ColorRes.white.withAlpha(20),
          ),
        ),
      ),
    );
  }
}