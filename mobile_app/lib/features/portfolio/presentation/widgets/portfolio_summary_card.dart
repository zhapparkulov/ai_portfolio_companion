import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/portfolio.dart';

class PortfolioSummaryCard extends StatelessWidget {
  final Portfolio portfolio;

  const PortfolioSummaryCard({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context) {
    final isUp = portfolio.dailyChange >= 0;
    final changeColor = isUp ? AppColors.positive : AppColors.negative;

    return AppCard(
      variant: AppCardVariant.primary,
      radius: AppRadii.cardLarge,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SizedBox(
        height: 164,
        child: Stack(
          children: [
            const Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: _Sparkline(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL BALANCE',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textInverted.withValues(alpha: 0.52),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  Formatters.currency(portfolio.totalValue),
                  style: AppTextStyles.display.copyWith(
                    color: AppColors.textInverted,
                    fontSize: 31,
                  ),
                ),
                const Spacer(),
                Text(
                  'DAILY CHANGE',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textInverted.withValues(alpha: 0.45),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  children: [
                    Text(
                      Formatters.currency(portfolio.dailyChange),
                      style: AppTextStyles.body.copyWith(
                        color: changeColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: changeColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: AppSpacing.xxs,
                        ),
                        child: Text(
                          Formatters.percent(portfolio.dailyChangePercent),
                          style: AppTextStyles.caption.copyWith(
                            color: changeColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Sparkline extends StatelessWidget {
  const _Sparkline();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(150, 82),
      painter: _SparklinePainter(),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final mutedPaint = Paint()
      ..color = AppColors.textInverted.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final linePaint = Paint()
      ..color = AppColors.positive
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final mutedPath = Path()
      ..moveTo(0, size.height * 0.52)
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.46,
        size.width * 0.45,
        size.height * 0.68,
        size.width * 0.68,
        size.height * 0.58,
      )
      ..cubicTo(
        size.width * 0.84,
        size.height * 0.5,
        size.width * 0.88,
        size.height * 0.18,
        size.width,
        size.height * 0.18,
      );

    final linePath = Path()
      ..moveTo(size.width * 0.48, size.height * 0.68)
      ..cubicTo(
        size.width * 0.62,
        size.height * 0.68,
        size.width * 0.64,
        size.height * 0.36,
        size.width * 0.78,
        size.height * 0.34,
      )
      ..cubicTo(
        size.width * 0.9,
        size.height * 0.32,
        size.width * 0.88,
        size.height * 0.08,
        size.width,
        size.height * 0.08,
      );

    canvas.drawPath(mutedPath, mutedPaint);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
