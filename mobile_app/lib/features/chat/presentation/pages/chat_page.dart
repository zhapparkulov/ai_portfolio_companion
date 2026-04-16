import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';
import '../widgets/streaming_bubble.dart';

class ChatPage extends StatelessWidget {
  final ValueChanged<AppTab> onTabSelected;
  final bool showError;

  const ChatPage({
    super.key,
    required this.onTabSelected,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: showError ? 'AI Portfolio' : 'AI Assistant',
      subtitle: showError ? null : 'ACTIVE NOW',
      selectedTab: AppTab.chat,
      onTabSelected: onTabSelected,
      avatarIcon: showError ? Icons.person : Icons.smart_toy,
      avatarColor: showError ? AppColors.primary : AppColors.secondary,
      bottomContent: ChatInput(
        enabled: !showError,
        onSend: () {},
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          if (!showError) const _DatePill(),
          MessageBubble(
            role: MessageRole.user,
            text: showError
                ? 'Can you analyze the risk-adjusted returns for my tech-heavy '
                    'portfolio over the last quarter?'
                : 'How is my tech exposure looking?',
            timestamp: showError ? 'SENT 10:42 AM' : '10:42 AM',
          ),
          if (showError)
            ErrorBubble(onRetry: () {})
          else ...[
            const MessageBubble(
              role: MessageRole.assistant,
              text: 'Your portfolio is currently 65% tech-heavy. While AAPL is '
                  'performing well, you might consider diversifying into '
                  'healthcare to mitigate sector risk.',
              richContent: AssistantRiskCard(),
            ),
            const SizedBox(height: AppSpacing.xs),
            const StreamingBubble(),
          ],
        ],
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            child: Text(
              'TODAY',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
