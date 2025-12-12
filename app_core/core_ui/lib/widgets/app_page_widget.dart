import 'package:flutter/material.dart';

import '../res/dimen_res.dart';
import '../util/screen_ext.dart';
import 'err_screen_size.dart';

class AppPageWidget extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionBtn;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final double padding;

  const AppPageWidget({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionBtn,
    this.floatingActionButtonLocation,
    this.padding = DimenRes.size_16
  });

  Widget _buildContent() => SafeArea(child: body);

  Widget _buildBody() {
    if (padding > 0) {
      return Padding(
          padding: EdgeInsetsGeometry.all(padding),
          child: _buildContent()
      );
    }

    return _buildContent();
  }

  @override
  Widget build(BuildContext context) {
    if (context.isSmallScreen()) {
      return AppErrorScreenSize();
    }

    return Scaffold(
      appBar: appBar,
      body: _buildBody(),
      floatingActionButton: floatingActionBtn,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}