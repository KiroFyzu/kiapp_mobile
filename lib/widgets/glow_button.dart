import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Elevated button with glow shadow + micro-scale press.
class GlowButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;
  final double height;
  final double radius;
  final EdgeInsetsGeometry? padding;

  const GlowButton({
    super.key,
    required this.child,
    this.onPressed,
    this.color,
    this.height = 54,
    this.radius = 14,
    this.padding,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOutBack);
    _scaleCtrl.value = 1.0;
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool active = widget.onPressed != null;
    final Color bgColor = widget.color ?? AppTheme.primary;

    return GestureDetector(
      onTapDown: active ? (_) => _scaleCtrl.reverse() : null,
      onTapUp: active ? (_) => _scaleCtrl.forward() : null,
      onTapCancel: () => _scaleCtrl.forward(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: SizedBox(
          width: double.infinity,
          height: widget.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: bgColor.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    widget.padding ?? const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                ),
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
