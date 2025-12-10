import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isExpanded;
  final bool enabled;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isFormAction;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isExpanded = true,
    this.enabled = true,
    this.backgroundColor = ColorRes.red,
    this.textColor = ColorRes.white,
    this.isFormAction = false
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = isExpanded ? const Size(double.infinity, DimenRes.size_60) : null;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: buttonSize,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DimenRes.size_16))),
      onPressed: enabled ? () {
        if (isFormAction) context.dismissKeyboard();
        onPressed();
      } : null,
      child: Text(
        label,
        style: TextStyle(
            fontSize: DimenRes.size_16,
            fontWeight: FontWeight.bold,
            color: textColor
        ),
      ),
    );
  }

  factory AppButton.defaultBtn({
    required String label,
    required VoidCallback onPressed
  }) => AppButton(label: label, onPressed: onPressed);
}
