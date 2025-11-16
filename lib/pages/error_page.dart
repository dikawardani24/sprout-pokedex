import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sprout_pokedex/res/color_res.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/res/image_res.dart';
import 'package:sprout_pokedex/res/string_res.dart';

class ErrorPage extends StatelessWidget {
  final GestureTapCallback? onRetry;

  const ErrorPage({
    super.key,
    this.onRetry
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: DimenRes.size_4,
      children: [
        SvgPicture.asset(ImageRes.snorlax,
          width: DimenRes.size_100,
          height: DimenRes.size_100,
        ),
        const Text(StringRes.error),
        if (onRetry != null) InkWell(
          onTap: onRetry,
          child: const Text(StringRes.retry, style: TextStyle(color: ColorRes.red),),
        )
      ],
    );
  }
}