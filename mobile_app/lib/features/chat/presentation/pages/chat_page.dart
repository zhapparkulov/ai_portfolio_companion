import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/extensions/l10n_extensions.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../domain/entities/chat_message.dart';
import '../cubit/chat_cubit.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';
import '../widgets/streaming_bubble.dart';

class ChatPage extends StatefulWidget {
  final ValueChanged<AppTab> onTabSelected;

  const ChatPage({
    super.key,
    required this.onTabSelected,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatStreaming || state is ChatReady) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
      },
      builder: (context, state) {
        final isError = state is ChatError;
        final isStreaming = state is ChatStreaming;

        return AppScaffold(
          title: isError ? context.l10n.aiPortfolio : context.l10n.aiAssistant,
          subtitle: isError ? null : context.l10n.activeNow,
          selectedTab: AppTab.chat,
          onTabSelected: widget.onTabSelected,
          avatarIcon: isError ? Icons.person : Icons.smart_toy,
          avatarColor: isError ? AppColors.primary : AppColors.secondary,
          bottomContent: ChatInput(
            enabled: !isError,
            onSend: context.read<ChatCubit>().sendMessage,
          ),
          body: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            children: [
              if (!isError) const _DatePill(),
              if (state.messages.isEmpty)
                ..._localizedSeedMessages(context).map(_MessageItem.new)
              else
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
              context.l10n.today,
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

List<ChatMessage> _localizedSeedMessages(BuildContext context) {
  final now = DateTime.now();
  return [
    ChatMessage(
      id: 'seed-user',
      role: ChatMessageRole.user,
      text: context.l10n.seedUserMessage,
      createdAt: now,
    ),
    ChatMessage(
      id: 'seed-assistant',
      role: ChatMessageRole.assistant,
      text: context.l10n.seedAssistantMessage,
      createdAt: now,
    ),
  ];
}
