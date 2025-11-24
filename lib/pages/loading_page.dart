import 'package:flutter/material.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';
import 'package:sprout_pokedex/widgets/loading.dart';

class LoadingPage extends StatelessWidget {
  final double size;

  const LoadingPage({
    super.key,
    this.size = DimenRes.size_100,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Loading(
        size: DimenRes.size_200,
      ),
    );
  }
}