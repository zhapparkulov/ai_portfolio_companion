import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/extensions/l10n_extensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/coming_soon_snackbar.dart';

class DashboardInsightCard extends StatelessWidget {
  const DashboardInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.muted,
      radius: AppRadii.cardLarge,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.aiInsights, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.dashboardInsightBody,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: context.l10n.applyStrategy,
            onPressed: () => showComingSoonSnackBar(context),
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.small,
          ),
          const SizedBox(height: AppSpacing.lg),
          const _InsightVisual(),
        ],
      ),
    );
  }
}

class _InsightVisual extends StatelessWidget {
  const _InsightVisual();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              Color(0xFFBDE7FF),
              Color(0xFF243B55),
              AppColors.primary,
            ],
          ),
        ),
        child: SizedBox(
          height: 146,
          width: double.infinity,
          child: Icon(
            Icons.auto_awesome,
            color: AppColors.textInverted,
            size: 38,
          ),
        ),
      ),
    );
  }
}
