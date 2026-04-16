import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';

enum AppCardVariant { surface, primary, muted, danger }

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool elevated;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.surface,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.radius = AppRadii.card,
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    final background = switch (variant) {
      AppCardVariant.surface => AppColors.surface,
      AppCardVariant.primary => AppColors.primary,
      AppCardVariant.muted => AppColors.surfaceElevated,
      AppCardVariant.danger => AppColors.negativeSoft,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        border: variant == AppCardVariant.surface
            ? Border.all(color: AppColors.border.withValues(alpha: 0.45))
            : null,
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.5),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
