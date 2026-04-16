import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../domain/entities/chat_message.dart';
import '../cubit/chat_cubit.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';
import '../widgets/streaming_bubble.dart';

class ChatPage extends StatelessWidget {
  final ValueChanged<AppTab> onTabSelected;

  const ChatPage({
    super.key,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final isError = state is ChatError;
        final isStreaming = state is ChatStreaming;

        return AppScaffold(
          title: isError ? 'AI Portfolio' : 'AI Assistant',
          subtitle: isError ? null : 'ACTIVE NOW',
          selectedTab: AppTab.chat,
          onTabSelected: onTabSelected,
          avatarIcon: isError ? Icons.person : Icons.smart_toy,
          avatarColor: isError ? AppColors.primary : AppColors.secondary,
          bottomContent: ChatInput(
            enabled: !isError,
            onSend: context.read<ChatCubit>().sendMessage,
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            children: [
              if (!isError) const _DatePill(),
              ...state.messages.map(_MessageItem.new),
              if (isStreaming) ...[
                const SizedBox(height: AppSpacing.xs),
                const StreamingBubble(),
              ],
              if (isError)
                ErrorBubble(
                  onRetry: context.read<ChatCubit>().retryLastMessage,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MessageItem extends StatelessWidget {
  final ChatMessage message;

  const _MessageItem(this.message);

  @override
  Widget build(BuildContext context) {
    final isAssistant = message.role == ChatMessageRole.assistant;
    if (message.text.isEmpty) return const SizedBox.shrink();

    return MessageBubble(
      role: isAssistant ? MessageRole.assistant : MessageRole.user,
      text: message.text,
      timestamp: isAssistant ? null : '10:42 AM',
      richContent: isAssistant && message.id == 'seed-assistant'
          ? const AssistantRiskCard()
          : null,
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
