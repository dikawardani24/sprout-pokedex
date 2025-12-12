import 'package:flutter/material.dart';

import '../res/color_res.dart';
import '../res/dimen_res.dart';
import '../res/image_res.dart';
import '../res/string_res.dart';

class AppErrorScreenSize extends StatelessWidget{
  final String message;

  const AppErrorScreenSize({
    super.key,
    this.message = StringErrRes.errScreenTooSmall
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(DimenRes.size_16),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  ImageRes.pokeBall,
                  color: ColorRes.grey.withAlpha(20),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(message, textAlign: TextAlign.center,),
              )
            ],
          ),
        ),
      ),
    );
  }
}