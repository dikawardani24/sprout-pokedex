import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class AppChatBubble extends StatelessWidget {
  final Color dotColor;
  final double dotSize;

  const AppChatBubble({
    super.key,
    this.dotColor = Colors.grey,
    this.dotSize = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: DimenRes.size_16, bottom: DimenRes.size_16),
      child: Column(
        spacing: DimenRes.size_10,
        children: [
          Text(StringRes.loadingChat),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AnimatedDot(delay: 0, color: dotColor, size: dotSize),
              const SizedBox(width: 4),
              _AnimatedDot(delay: 200, color: dotColor, size: dotSize),
              const SizedBox(width: 4),
              _AnimatedDot(delay: 400, color: dotColor, size: dotSize),
            ],
          )
        ],
      ),
    );
  }
}

class _AnimatedDot extends StatefulWidget {
  final int delay;
  final Color color;
  final double size;

  const _AnimatedDot({
    required this.delay,
    required this.color,
    required this.size,
  });

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}