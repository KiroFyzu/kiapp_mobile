import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Reusable glassmorphism card — compose don't repeat.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final double blur;
  final bool dark;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius = 16,
    this.blur = 24,
    this.dark = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = dark
        ? AppTheme.glassCardDark(radius: radius, blur: blur)
        : AppTheme.glassCard(radius: radius, blur: blur);

    final body = Padding(
      padding: padding ?? const EdgeInsets.all(18),
      child: child,
    );

    if (onTap != null) {
      return Container(
        margin: margin,
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onTap,
            child: body,
          ),
        ),
      );
    }

    return Container(
      margin: margin,
      decoration: decoration,
      child: body,
    );
  }
}
