import 'package:flutter/material.dart';

import '../res/color_res.dart';
import '../res/dimen_res.dart';

class AppText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;

  const AppText({
    super.key,
    required this.text,
    this.maxLines,
    this.overflow,
    this.color,
    this.fontWeight,
    this.fontSize
  });

  const AppText.singleLine({
    super.key,
    required this.text,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.fontSize,
    this.fontWeight
  });

  const AppText.header({
    super.key,
    required this.text,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.fontSize,
    this.fontWeight = FontWeight.bold
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
        overflow: overflow,
      ),
    );
  }
}

class PokemonId extends StatelessWidget {
  final String pokeId;
  final double fontSize;

  const PokemonId({
    super.key,
    required this.pokeId,
    this.fontSize = DimenRes.size_12
  });

  @override
  Widget build(BuildContext context) {
    return AppText.header(
      text: pokeId,
      fontSize: fontSize,
      color: ColorRes.black.withAlpha(60),
    );
  }
}