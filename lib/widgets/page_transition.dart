import 'package:flutter/material.dart';

/// Shared page route transitions for consistency.
class RouteTransition {
  /// Slide up + fade — used for result/settings push.
  static Route<T> slideUp<T>(Widget page, {Duration duration = const Duration(milliseconds: 350)}) {
    return PageRouteBuilder(
      pageBuilder: (_, a1, _) => page,
      transitionsBuilder: (_, a1, _, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: a1, curve: Curves.easeOutQuad)),
        child: FadeTransition(opacity: a1, child: child),
      ),
      transitionDuration: duration,
    );
  }

  /// Fade — used for modals / simple pushes.
  static Route<T> fade<T>(Widget page, {Duration duration = const Duration(milliseconds: 300)}) {
    return PageRouteBuilder(
      pageBuilder: (_, a1, _) => page,
      transitionsBuilder: (_, a1, _, child) => FadeTransition(opacity: a1, child: child),
      transitionDuration: duration,
    );
  }
}
