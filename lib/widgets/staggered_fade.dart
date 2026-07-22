import 'package:flutter/material.dart';

/// Staggered fade+slide entrance for list items.
class StaggeredFade extends StatelessWidget {
  final int index;
  final Widget child;
  final AnimationController controller;
  final double offset;

  const StaggeredFade({
    super.key,
    required this.index,
    required this.child,
    required this.controller,
    this.offset = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    final delay = (index * 0.06).clamp(0.0, 1.0);
    final anim = CurvedAnimation(
      parent: controller,
      curve: Interval(delay, 1.0, curve: Curves.easeOutQuad),
    );
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, offset),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }
}
