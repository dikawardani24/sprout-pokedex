import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../res/dimen_res.dart';
import 'app_card.dart';

class AppTime extends StatelessWidget{
  final DateTime time;
  final Color textColor, bgColor;

  const AppTime({super.key, required this.time, required this.textColor, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: bgColor,
      child: Padding(
        padding: EdgeInsetsGeometry.all(DimenRes.size_10),
        child: Text(
          time.formatTime(),
          style: TextStyle(
              color: textColor,
              fontSize: DimenRes.size_10
          ),
        ),
      ),
    );
  }

}