import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text_field.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController? controller;
  final bool enabled;
  final ValueChanged<String> onSend;

  const ChatInput({
    super.key,
    this.controller,
    required this.enabled,
    required this.onSend,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  TextEditingController? _internalController;

  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  void _send() {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    widget.onSend(message);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _controller,
            enabled: widget.enabled,
            hintText: widget.enabled
                ? 'Ask about your investments...'
                : 'Type a message...',
            leadingIcon: Icons.add,
            onSubmitted: (_) => _send(),
            trailing: _SendButton(enabled: widget.enabled, onSend: _send),
          ),
          if (!widget.enabled) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'CHAT SERVICE TEMPORARILY UNAVAILABLE',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onSend;

  const _SendButton({
    required this.enabled,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onSend : null,
      borderRadius: BorderRadius.circular(AppRadii.pill),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: enabled ? AppColors.secondary : AppColors.border,
          shape: BoxShape.circle,
        ),
        child: const SizedBox(
          width: 34,
          height: 34,
          child:
              Icon(Icons.arrow_upward, color: AppColors.textInverted, size: 18),
        ),
      ),
    );
  }
}
