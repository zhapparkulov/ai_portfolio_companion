import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../extensions/l10n_extensions.dart';
import 'app_button.dart';
import 'app_card.dart';

class ErrorView extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: AppCard(
          variant: AppCardVariant.danger,
          elevated: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.negative,
                size: 36,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title ?? context.l10n.somethingWentWrong,
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(
                  color: AppColors.negative,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: context.l10n.retry,
                onPressed: onRetry,
                variant: AppButtonVariant.danger,
                size: AppButtonSize.small,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
