import 'package:flutter/material.dart';
import 'package:sprout_pokedex/res/string_res.dart';
import 'package:sprout_pokedex/widgets/error_widget.dart';

class ErrorPage extends StatelessWidget {
  final GestureTapCallback? onRetry;
  final String message;

  const ErrorPage({
    super.key,
    this.onRetry,
    this.message = StringRes.error
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppErrorWidget(
          message: message,
          onRetry: onRetry,
        ),
      ),
    );
  }
}