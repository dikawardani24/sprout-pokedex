import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppErrorWidget extends StatelessWidget {
  final GestureTapCallback? onRetry;
  final String message;
  final double minHeight;

  const AppErrorWidget({
    super.key,
    this.onRetry,
    this.message = StringRes.error,
    this.minHeight = 300,
  });


  Widget _getContent(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    spacing: DimenRes.size_16,
    children: [
      SvgPicture.asset(
        ImageRes.snorlax,
        width: DimenRes.size_100,
        height: DimenRes.size_100,
      ),
      Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      if (onRetry != null) ...[
        ElevatedButton(
          onPressed: onRetry,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorRes.red,
            foregroundColor: ColorRes.white,
            padding: const EdgeInsets.symmetric(
              horizontal: DimenRes.size_16,
              vertical: DimenRes.size_12,
            ),
          ),
          child: const Text(
            StringRes.retry,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ],
  );

  Widget _createWidget(BuildContext context, bool isShowContent) {
    Widget content = AppErrorScreenSize(message: message);

    if (isShowContent) content = _getContent(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DimenRes.size_20),
        child: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (c, constraint) {
      if (constraint.maxHeight < 300) {
        return _createWidget(context, false);
      }
      return _createWidget(context, true);
    });
  }
}