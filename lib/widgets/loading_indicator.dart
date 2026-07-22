import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Centered loading indicator with optional label.
class AppLoadingIndicator extends StatelessWidget {
  final String? label;

  const AppLoadingIndicator({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppTheme.primaryLight),
          if (label != null) ...[
            const SizedBox(height: 12),
            Text(label!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
