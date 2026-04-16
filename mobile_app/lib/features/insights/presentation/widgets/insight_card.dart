import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/extensions/l10n_extensions.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

enum InsightSeverity { priority, info, positive, risk }

class InsightCard extends StatelessWidget {
  final String title;
  final String body;
  final InsightSeverity severity;
  final String? badgeLabel;
  final String? meta;
  final List<Widget> actions;
  final String? highlight;

  const InsightCard({
    super.key,
    required this.title,
    required this.body,
    required this.severity,
    this.badgeLabel,
    this.meta,
    this.actions = const [],
    this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _SeverityColors.forSeverity(severity);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        radius: AppRadii.cardLarge,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.soft,
                borderRadius: BorderRadius.circular(AppRadii.input),
              ),
              child: SizedBox(
                width: 42,
                height: 42,
                child: Icon(colors.icon, color: colors.strong, size: 20),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.title.copyWith(
                            color: highlight != null
                                ? colors.strong
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (badgeLabel != null) ...[
                        const SizedBox(width: AppSpacing.xs),
                        AppBadge(
                          label: badgeLabel!,
                          tone: switch (severity) {
                            InsightSeverity.priority => AppBadgeTone.success,
                            InsightSeverity.positive => AppBadgeTone.success,
                            InsightSeverity.risk => AppBadgeTone.danger,
                            InsightSeverity.info => AppBadgeTone.info,
                          },
                        ),
                      ],
                      if (meta != null) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Text(meta!, style: AppTextStyles.caption),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    body,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  if (highlight != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    AppBadge(label: highlight!, tone: AppBadgeTone.success),
                  ],
                  if (actions.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Row(children: actions),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InsightsHeroCard extends StatelessWidget {
  const InsightsHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.primary,
      radius: AppRadii.cardLarge,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome,
                  color: AppColors.textInverted, size: 16),
              const SizedBox(width: AppSpacing.xs),
              Text(
                context.l10n.aiIntelligence,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textInverted.withValues(alpha: 0.58),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.optimizeForGrowth,
            style: AppTextStyles.heading.copyWith(
              color: AppColors.textInverted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.insightsHeroBody,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textInverted.withValues(alpha: 0.68),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class InsightActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool primary;

  const InsightActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.xs),
        child: AppButton(
          label: label,
          onPressed: onPressed,
          variant:
              primary ? AppButtonVariant.secondary : AppButtonVariant.ghost,
          size: AppButtonSize.small,
          expand: true,
        ),
      ),
    );
  }
}

class _SeverityColors {
  final Color soft;
  final Color strong;
  final IconData icon;

  const _SeverityColors({
    required this.soft,
    required this.strong,
    required this.icon,
  });

  static _SeverityColors forSeverity(InsightSeverity severity) {
    return switch (severity) {
      InsightSeverity.priority => const _SeverityColors(
          soft: AppColors.infoSoft,
          strong: AppColors.secondary,
          icon: Icons.balance,
        ),
      InsightSeverity.info => const _SeverityColors(
          soft: AppColors.surfaceMuted,
          strong: AppColors.primary,
          icon: Icons.trending_up,
        ),
      InsightSeverity.positive => const _SeverityColors(
          soft: AppColors.positiveSoft,
          strong: AppColors.positive,
          icon: Icons.payments_outlined,
        ),
      InsightSeverity.risk => const _SeverityColors(
          soft: AppColors.negativeSoft,
          strong: AppColors.negative,
          icon: Icons.warning_amber_rounded,
        ),
    };
  }
}
