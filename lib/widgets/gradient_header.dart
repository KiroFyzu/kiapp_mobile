import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Gradient text header using ShaderMask.
class GradientHeader extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const GradientHeader({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
      child: Text(
        text,
        style: (style ?? Theme.of(context).textTheme.headlineMedium)
            ?.copyWith(color: Colors.white),
        textAlign: textAlign,
      ),
    );
  }
}
