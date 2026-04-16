import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? leadingIcon;
  final Widget? trailing;
  final bool enabled;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.leadingIcon,
    this.trailing,
    this.enabled = true,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: enabled ? AppColors.surface : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadii.input),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          if (leadingIcon != null)
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: Icon(
                leadingIcon,
                color: enabled ? AppColors.textSecondary : AppColors.textMuted,
                size: 20,
              ),
            ),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              onSubmitted: onSubmitted,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
              ),
              style: AppTextStyles.body.copyWith(
                color: enabled ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ),
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: trailing,
            ),
        ],
      ),
    );
  }
}
