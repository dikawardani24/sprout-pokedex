
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double imageSize;
  final double imageErrSize;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    required this.imageSize,
    required this.imageErrSize
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fill,
      memCacheHeight: imageSize.toInt() * 2,
      memCacheWidth: imageSize.toInt() * 2,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 200),
      useOldImageOnUrlChange: true,
      placeholder: (context, url) => _ImagePlaceholder(size: imageSize),
      errorWidget: (context, error, trace) => Icon(
          Icons.error,
          color: ColorRes.black.withAlpha(20),
          size: imageErrSize
      ),
    );
  }
}

/// Optimized rotating placeholder using single AnimationController
class _ImagePlaceholder extends StatefulWidget {
  final double size;

  const _ImagePlaceholder({required this.size});

  @override
  State<_ImagePlaceholder> createState() => _ImagePlaceholderState();
}

class _ImagePlaceholderState extends State<_ImagePlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: RotationTransition(
          turns: _controller,
          child: Image.asset(
            ImageRes.pokeBallColoredSamll,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}