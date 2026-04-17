import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/extensions/l10n_extensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/coming_soon_snackbar.dart';

enum MessageRole { user, assistant }

class MessageBubble extends StatelessWidget {
  final String text;
  final MessageRole role;
  final String? timestamp;
  final Widget? richContent;

  const MessageBubble({
    super.key,
    required this.text,
    required this.role,
    this.timestamp,
    this.richContent,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = role == MessageRole.user;
    final bubble = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.74,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadii.card),
            topRight: const Radius.circular(AppRadii.card),
            bottomLeft: Radius.circular(isUser ? AppRadii.card : 4),
            bottomRight: Radius.circular(isUser ? 4 : AppRadii.card),
          ),
          boxShadow: isUser
              ? null
              : [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.35),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: AppTextStyles.body.copyWith(
                  color:
                      isUser ? AppColors.textInverted : AppColors.textPrimary,
                ),
              ),
              if (richContent != null) ...[
                const SizedBox(height: AppSpacing.md),
                richContent!,
              ],
              if (timestamp != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    timestamp!,
                    style: AppTextStyles.caption.copyWith(
                      color: isUser
                          ? AppColors.textInverted.withValues(alpha: 0.56)
                          : AppColors.textMuted,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const _AssistantAvatar(),
            const SizedBox(width: AppSpacing.xs),
          ],
          bubble,
        ],
      ),
    );
  }
}

class AssistantRiskCard extends StatelessWidget {
  const AssistantRiskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.muted,
      elevated: false,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up,
                  color: AppColors.positive, size: 16),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  context.l10n.riskExposureAlert,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '65%',
                style: AppTextStyles.title.copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.input),
            child: const LinearProgressIndicator(
              value: 0.65,
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation(AppColors.secondary),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: context.l10n.compareHealthcareEtfs,
                  onPressed: () => showComingSoonSnackBar(context),
                  variant: AppButtonVariant.ghost,
                  size: AppButtonSize.small,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          AppButton(
            label: context.l10n.viewAaplDetails,
            onPressed: () => showComingSoonSnackBar(context),
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.small,
            expand: true,
          ),
        ],
      ),
    );
  }
}

class ErrorBubble extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorBubble({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.negative, size: 16),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.negativeSoft,
                border: Border(
                  left: BorderSide(color: AppColors.negative, width: 3),
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppRadii.card),
                  bottomRight: Radius.circular(AppRadii.card),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.connectionLost,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.negative,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.l10n.connectionLostBody,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.negative,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppButton(
                        label: context.l10n.retry,
                        onPressed: onRetry,
                        variant: AppButtonVariant.danger,
                        size: AppButtonSize.small,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssistantAvatar extends StatelessWidget {
  const _AssistantAvatar();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 13,
      backgroundColor: AppColors.secondary,
      child: Icon(Icons.smart_toy, color: AppColors.textInverted, size: 14),
    );
  }
}
