import 'package:core_ui/res/color_res.dart';
import 'package:core_ui/res/dimen_res.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final double size;
  final IconData icon;
  final GestureTapCallback? onTap;
  final Color iconColor;
  final Color backgroundColor;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  const AppIconButton({
    super.key,
    this.size = DimenRes.size_60,
    required this.icon,
    this.onTap,
    this.iconColor = ColorRes.black,
    this.iconSize = DimenRes.size_30,
    this.padding,
    this.backgroundColor = ColorRes.transparent
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size),
        customBorder: const CircleBorder(),
        splashFactory: InkRipple.splashFactory,
        child: Container(
          width: size,
          height: size,
          padding: padding,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}