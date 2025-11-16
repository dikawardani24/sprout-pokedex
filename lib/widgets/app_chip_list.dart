import 'package:flutter/material.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/util/string_ext.dart';
import 'package:sprout_pokedex/widgets/app_chip.dart';

class AppChipList extends StatelessWidget {
  final List<String> chipDataList;
  final Axis appOrientation;
  final double spacing;
  final Color bgColor;
  final TextStyle textStyle;

  const AppChipList({
    super.key,
    required this.chipDataList,
    this.appOrientation = Axis.vertical,
    this.spacing = DimenRes.size_8,
    required this.bgColor,
    required this.textStyle
  });

  Widget _createChip(String data) => AppChip(
    color: bgColor,
    label: data.firstLetterUpperCase,
    textStyle: textStyle,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: appOrientation,
      child: Flex(
        direction: appOrientation,
        spacing: spacing,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: chipDataList.map((e) => _createChip(e)).toList(),
      ),
    );
  }

}