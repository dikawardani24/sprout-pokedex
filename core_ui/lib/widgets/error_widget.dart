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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Add scroll for very small screens
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(DimenRes.size_20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                ImageRes.snorlax,
                width: DimenRes.size_100,
                height: DimenRes.size_100,
              ),
              const SizedBox(height: DimenRes.size_16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: DimenRes.size_16),
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
          ),
        ),
      ),
    );
  }
}