import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class StreamingBubble extends StatefulWidget {
  final String text;

  const StreamingBubble({
    super.key,
    this.text = 'Analyzing portfolio risk',
  });

  @override
  State<StreamingBubble> createState() => _StreamingBubbleState();
}

class _StreamingBubbleState extends State<StreamingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 13,
          backgroundColor: AppColors.secondary,
          child: Icon(Icons.smart_toy, color: AppColors.textInverted, size: 14),
        ),
        const SizedBox(width: AppSpacing.xs),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.text, style: AppTextStyles.bodySmall),
                const SizedBox(width: AppSpacing.xs),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final activeDot = (_controller.value * 3).floor();
                    return Row(
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: index == activeDot
                                  ? AppColors.secondary
                                  : AppColors.textMuted,
                              shape: BoxShape.circle,
                            ),
                            child: const SizedBox(width: 4, height: 4),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
