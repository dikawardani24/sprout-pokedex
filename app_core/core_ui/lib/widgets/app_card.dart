import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final GestureTapCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    required this.color,
    this.onTap
  });

  Widget _buildClickable(BorderRadius borderRadius) => InkWell(
    borderRadius: borderRadius,
    onTap: onTap,
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(DimenRes.size_16);
    Widget toShow = child;

    if (onTap != null) toShow = _buildClickable(border);

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: border,
      ),
      child: toShow,
    );
  }
}