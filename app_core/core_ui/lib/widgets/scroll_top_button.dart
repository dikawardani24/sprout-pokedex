import 'dart:async';

import 'package:flutter/material.dart';
import '../core_ui.dart';

class ScrollTopContainer extends StatefulWidget {
  final ScrollController scrollController;
  final Duration showButtonDelay;
  final double bottomThreshold;
  final double scrollDistanceThreshold;
  final Duration scrollAnimationDuration;
  final Curve scrollAnimationCurve;

  const ScrollTopContainer({
    super.key,
    required this.scrollController,
    this.showButtonDelay = const Duration(seconds: 3),
    this.bottomThreshold = 50.0,
    this.scrollDistanceThreshold = 500.0,
    this.scrollAnimationDuration = const Duration(milliseconds: 500),
    this.scrollAnimationCurve = Curves.easeInOut,
  });

  @override
  State<ScrollTopContainer> createState() => _ScrollTopContainerState();
}

class _ScrollTopContainerState extends State<ScrollTopContainer>
    with SingleTickerProviderStateMixin {
  ScrollController get _controller => widget.scrollController;

  bool _showScrollToTop = false;
  Timer? _scrollTimer;
  bool _isAtBottom = false;

  // Animation controller for slide-up effect
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom (offscreen)
      end: Offset.zero, // End at original position
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _controller.addListener(_checkScrollPosition);
  }

  void _scrollToTop() {
    if (!_controller.hasClients) return;

    _controller.animateTo(
      0,
      duration: widget.scrollAnimationDuration,
      curve: widget.scrollAnimationCurve,
    );

    // Animate button out before hiding
    _hideScrollToTopButton();
  }

  void _startBottomTimer() {
    _cancelTimer();

    _scrollTimer = Timer(widget.showButtonDelay, () {
      if (_isAtBottom && mounted) {
        _showButton();
      }
    });
  }

  void _cancelTimer() {
    _scrollTimer?.cancel();
    _scrollTimer = null;
  }

  void _showButton() {
    if (mounted) {
      setState(() {
        _showScrollToTop = true;
      });
      _animationController.forward();
    }
  }

  void _hideScrollToTopButton() {
    if (mounted && _showScrollToTop) {
      // Animate out first, then hide
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showScrollToTop = false;
          });
        }
      });
    }
  }

  void _checkScrollPosition() {
    if (!_controller.hasClients || !mounted) return;

    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;

    // Check if user is at bottom (within threshold pixels from bottom)
    final isAtBottomNow = currentScroll >= maxScroll - widget.bottomThreshold;

    if (isAtBottomNow && !_isAtBottom) {
      // Just reached bottom - start timer
      _isAtBottom = true;
      _startBottomTimer();
    } else if (!isAtBottomNow && _isAtBottom) {
      // Moved away from bottom - cancel timer
      _isAtBottom = false;
      _cancelTimer();
      _hideScrollToTopButton();
    }

    // Also show button when scrolled down significantly
    if (currentScroll > widget.scrollDistanceThreshold && !_showScrollToTop) {
      _showButton();
    } else if (currentScroll <= widget.scrollDistanceThreshold && _showScrollToTop) {
      _hideScrollToTopButton();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_checkScrollPosition);
    _cancelTimer();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showScrollToTop) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.all(DimenRes.size_16),
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: AppIconButton.only(
              icon: IconRes.iconNavUp,
              onTap: _scrollToTop,
            ),
          ),
        ),
      ),
    );
  }
}