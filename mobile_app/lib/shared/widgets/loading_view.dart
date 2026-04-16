import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: const [
        _SkeletonBlock(height: 154, color: AppColors.primary),
        SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(child: _SkeletonBlock(height: 92)),
            SizedBox(width: AppSpacing.sm),
            Expanded(child: _SkeletonBlock(height: 92)),
          ],
        ),
        SizedBox(height: AppSpacing.xl),
        _SkeletonLine(widthFactor: 0.45),
        SizedBox(height: AppSpacing.md),
        _SkeletonBlock(height: 58),
        SizedBox(height: AppSpacing.sm),
        _SkeletonBlock(height: 58),
        SizedBox(height: AppSpacing.sm),
        _SkeletonBlock(height: 58),
        SizedBox(height: AppSpacing.sm),
        _SkeletonBlock(height: 58),
      ],
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  final double height;
  final Color color;

  const _SkeletonBlock({
    required this.height,
    this.color = AppColors.surface,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: color == AppColors.primary ? 0.92 : 1),
        borderRadius: BorderRadius.circular(AppRadii.cardLarge),
      ),
      child: SizedBox(height: height),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double widthFactor;

  const _SkeletonLine({required this.widthFactor});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        child: const SizedBox(height: 18),
      ),
    );
  }
}
