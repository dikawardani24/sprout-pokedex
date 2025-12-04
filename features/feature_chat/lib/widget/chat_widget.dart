import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ChatWidgetUser extends StatelessWidget {
  final String text;
  final DateTime when;

  const ChatWidgetUser({super.key, required this.text, required this.when, });

  Color get _colorBox => ColorRes.red;
  Radius get _borderRadiusLeft => const Radius.circular(DimenRes.size_12);
  Radius get _borderRadiusRight => const Radius.circular(0);
  Alignment get _alignment => Alignment.centerRight;

  Widget _buildMessage() {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = DimenRes.size_16;

    return Align(
      alignment: _alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: DimenRes.size_16),
        padding: const EdgeInsets.symmetric(horizontal: DimenRes.size_16, vertical: DimenRes.size_16),
        decoration: BoxDecoration(
          color: _colorBox,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomLeft: _borderRadiusLeft,
            bottomRight: _borderRadiusRight,
          ),
        ),
        child: Column(
          spacing: DimenRes.size_10,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildMessage(),
            AppTime(
              time: when,
              textColor:  Colors.white,
              bgColor: ColorRes.red.withAlpha(80),
            )
          ],
        ),
      ),
    );
  }

}