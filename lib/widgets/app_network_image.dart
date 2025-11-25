
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sprout_pokedex/res/color_res.dart';
import 'package:sprout_pokedex/widgets/loading.dart';

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
      placeholder: (context, child)  => Center(
        child: SizedBox(
          width: imageSize,
          height: imageSize,
          child: Loading(size: imageSize),
        ),
      ),
      errorWidget: (context, error, trace) => Icon(
          Icons.error,
          color: ColorRes.black.withAlpha(20),
          size: imageErrSize
      ),
    );
  }
}