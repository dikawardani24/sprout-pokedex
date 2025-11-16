import 'package:flutter/material.dart';
import 'package:sprout_pokedex/res/color_res.dart';
import 'package:sprout_pokedex/res/dimen_res.dart';

class ItemStats extends StatefulWidget {
  final String statType;
  final double progress;
  final int current;
  final int max;
  final bool animate;
  final Duration animationDuration;

  const ItemStats({
    super.key,
    required this.statType,
    required this.progress,
    required this.max,
    required this.current,
    this.animate = false,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<ItemStats> createState() => _ItemStatsState();
}

class _ItemStatsState extends State<ItemStats> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<int>? _countAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.animate) {
      _controller = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );

      _countAnimation = IntTween(
        begin: 0,
        end: widget.current,
      ).animate(CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeOut,
      ));

      _controller!.forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayValue = _countAnimation?.value ?? widget.current;
    final textTheme = Theme.of(context).textTheme;
    final items = <Widget>[];
    final scrWidth = MediaQuery.of(context).size.width;

    items.add(SizedBox(
      width: DimenRes.size_60,
      child: Text(
        widget.statType,
        style: textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.normal,
          color: ColorRes.grey,
        ),
      ),
    ));

    if (scrWidth > DimenRes.size_200) {
      items.add(Expanded(
        flex: 2,
        child: LinearProgressIndicator(
          value: widget.progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            _getProgressColor(widget.progress),
          ),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ));
    }

    items.add(Text(
      "$displayValue/${widget.max}",
      textAlign: TextAlign.right,
      maxLines: 1,
      style: textTheme.bodyLarge?.copyWith(
        overflow: TextOverflow.ellipsis,
        color: ColorRes.black,
        fontWeight: FontWeight.bold,
      ),
    ));

    return AnimatedBuilder(
      animation: _controller ?? const AlwaysStoppedAnimation(1),
      builder: (context, child) {

        return Row(
          spacing: DimenRes.size_10,
          children: items,
        );
      },
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.6) return Colors.lightGreen;
    if (progress >= 0.4) return Colors.orange;
    if (progress >= 0.2) return Colors.amber;
    return Colors.red;
  }
}