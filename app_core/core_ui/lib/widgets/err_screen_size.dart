import 'package:flutter/material.dart';

import '../res/dimen_res.dart';
import '../res/string_res.dart';

class AppErrorScreenSize extends StatelessWidget{
  final String message;

  const AppErrorScreenSize({
    super.key,
    this.message = StringRes.errScreenTooSmall
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(DimenRes.size_16), 
          child: Text(message)
        )
    );
  }
}