import 'package:flutter/material.dart';

import '../res/color_res.dart';
import '../res/dimen_res.dart';
import '../res/icon_res.dart';
import '../res/string_res.dart';
import '../util/navigation_extension.dart';
import '../util/screen_ext.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title, message;
  final VoidCallback? onConfirmed, onCancel;
  final NavigatorState dialogNavigator;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.onConfirmed,
    this.onCancel,
    required this.dialogNavigator
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (c, b) {
        if (b.isScreenTooSmall()) {
          return SizedBox.shrink();
        }

        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(DimenRes.size_16))),
          title: Column(
            children: [
              Row(
                spacing: DimenRes.size_10,
                children: [
                  Icon(IconRes.iconAsk, color: ColorRes.red, size: DimenRes.size_40),
                  const SizedBox(width: DimenRes.size_10),
                  Expanded(child: Text(title, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold, color: ColorRes.red, overflow: TextOverflow.ellipsis))),
                ],
              ),
              const SizedBox(height: DimenRes.size_6,),
              const Divider(height: DimenRes.size_1, color: ColorRes.red)
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text(StringRes.ok),
              onPressed: () {
                context.goBack();
                onConfirmed?.call();
              }
            ),
            TextButton(
              child: const Text(StringRes.cancel),
              onPressed: () {
                context.goBack();
                onCancel?.call();
              },
            )
          ],
        );
      },
    );

  }


}