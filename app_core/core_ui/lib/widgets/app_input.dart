import 'package:flutter/material.dart';

class AppInputField extends StatelessWidget {
  final String? label;
  final FormFieldValidator<String>? validator;
  final TextInputType textInputType;
  final int? maxLine, minLine;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final ScrollController? scrollController;

  const AppInputField({
    super.key,
    this.label,
    required this.textInputType,
    this.validator,
    this.maxLine,
    this.minLine,
    this.suffixIcon,
    this.controller,
    this.prefixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.onChanged,
    this.focusNode,
    this.onTap,
    this.scrollController
  });

  Widget? _buildLabel(String? label) {
    if (label != null && label.isNotEmpty) return Text(label);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget? label = _buildLabel(this.label);

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: textInputType,
      validator: validator,
      maxLines: maxLine,
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      onChanged: onChanged,
      focusNode: focusNode,
      onTap: onTap,
      minLines: minLine,
      scrollController: scrollController,
      decoration: InputDecoration(
          label: label,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon
      ),
    );
  }
}