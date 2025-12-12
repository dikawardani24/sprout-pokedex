import 'package:flutter/material.dart';

import '../res/dimen_res.dart';
import '../util/screen_ext.dart';
import 'err_screen_size.dart';

class AppPageWidget extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionBtn;

  const AppPageWidget({super.key, required this.body, this.appBar, this.floatingActionBtn});

  @override
  Widget build(BuildContext context) {
    if (context.isSmallScreen()) {
      return AppErrorScreenSize();
    }

    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: EdgeInsetsGeometry.all(DimenRes.size_16),
        child: body,
      ),
      floatingActionButton: floatingActionBtn,
    );
  }
}