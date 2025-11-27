import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class DetailImag extends StatelessWidget {
  final String imageUrl;

  const DetailImag({super.key, required this.imageUrl});

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
            imageUrl: imageUrl,
            imageSize: DimenRes.size_80,
            imageErrSize: DimenRes.size_60
        )
      ],
    );
  }

}