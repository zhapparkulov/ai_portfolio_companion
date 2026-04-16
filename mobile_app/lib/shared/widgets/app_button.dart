import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

enum AppButtonSize { small, medium }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool expand;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _ButtonColors.forVariant(variant);
    final isSmall = size == AppButtonSize.small;
    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: isSmall ? 14 : 16, color: colors.foreground),
          const SizedBox(width: AppSpacing.xs),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.button.copyWith(
              color: colors.foreground,
              fontSize: isSmall ? 12 : 14,
            ),
          ),
        ),
      ],
    );

    return SizedBox(
      width: expand ? double.infinity : null,
      height: isSmall ? 34 : 48,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          disabledBackgroundColor: AppColors.surfaceMuted,
          disabledForegroundColor: AppColors.textMuted,
          backgroundColor: colors.background,
          foregroundColor: colors.foreground,
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? AppSpacing.sm : AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
            side: BorderSide(color: colors.border),
          ),
        ),
        child: content,
      ),
    );
  }
}

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color border;

  const _ButtonColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  static _ButtonColors forVariant(AppButtonVariant variant) {
    return switch (variant) {
      AppButtonVariant.primary => const _ButtonColors(
          background: AppColors.primary,
          foreground: AppColors.textInverted,
          border: AppColors.primary,
        ),
      AppButtonVariant.secondary => const _ButtonColors(
          background: AppColors.secondary,
          foreground: AppColors.textInverted,
          border: AppColors.secondary,
        ),
      AppButtonVariant.ghost => const _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.textPrimary,
          border: AppColors.border,
        ),
      AppButtonVariant.danger => const _ButtonColors(
          background: AppColors.negative,
          foreground: AppColors.textInverted,
          border: AppColors.negative,
        ),
    };
  }
}
