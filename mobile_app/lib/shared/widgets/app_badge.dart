import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

enum AppBadgeTone { success, danger, info, neutral, warning }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeTone tone;

  const AppBadge({
    super.key,
    required this.label,
    this.tone = AppBadgeTone.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _BadgeColors.forTone(tone);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(color: colors.foreground),
        ),
      ),
    );
  }
}

class _BadgeColors {
  final Color background;
  final Color foreground;

  const _BadgeColors({
    required this.background,
    required this.foreground,
  });

  static _BadgeColors forTone(AppBadgeTone tone) {
    return switch (tone) {
      AppBadgeTone.success => const _BadgeColors(
          background: AppColors.positiveSoft,
          foreground: AppColors.positive,
        ),
      AppBadgeTone.danger => const _BadgeColors(
          background: AppColors.negativeSoft,
          foreground: AppColors.negative,
        ),
      AppBadgeTone.info => const _BadgeColors(
          background: AppColors.infoSoft,
          foreground: AppColors.secondary,
        ),
      AppBadgeTone.warning => const _BadgeColors(
          background: Color(0xFFFFF7E8),
          foreground: AppColors.warning,
        ),
      AppBadgeTone.neutral => const _BadgeColors(
          background: AppColors.surfaceMuted,
          foreground: AppColors.textSecondary,
        ),
    };
  }
}
