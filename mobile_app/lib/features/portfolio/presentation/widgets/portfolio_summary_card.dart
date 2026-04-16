import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/portfolio.dart';

class PortfolioSummaryCard extends StatelessWidget {
  final Portfolio portfolio;

  const PortfolioSummaryCard({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context) {
    final isUp = portfolio.dailyChange >= 0;
    final changeColor = isUp ? Colors.green.shade700 : Colors.red.shade700;
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Value',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer
                    .withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              Formatters.currency(portfolio.totalValue),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  isUp ? Icons.trending_up : Icons.trending_down,
                  color: changeColor,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  '${Formatters.currency(portfolio.dailyChange)}  '
                  '(${Formatters.percent(portfolio.dailyChangePercent)})',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: changeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'today',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
