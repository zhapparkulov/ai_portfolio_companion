import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../widgets/insight_card.dart';

class InsightsPage extends StatelessWidget {
  final ValueChanged<AppTab> onTabSelected;
  final bool showEmpty;

  const InsightsPage({
    super.key,
    required this.onTabSelected,
    this.showEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Portfolio Insights',
      selectedTab: AppTab.insights,
      onTabSelected: onTabSelected,
      avatarIcon: Icons.person,
      avatarColor: AppColors.primary,
      body: showEmpty
          ? EmptyState(
              icon: Icons.insights,
              title: 'Insights',
              message:
                  'No insights yet. Your AI assistant is analyzing your portfolio for new opportunities.',
              actionLabel: 'Refresh Data',
              onAction: () {},
              statusLabel: 'AI ANALYSIS IN PROGRESS',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              children: const [
                InsightsHeroCard(),
                SizedBox(height: AppSpacing.lg),
                InsightCard(
                  title: 'Rebalancing Opportunity',
                  badgeLabel: 'PRIORITY',
                  severity: InsightSeverity.priority,
                  body: 'Your Tech exposure has grown to 42% of your portfolio '
                      'due to recent rallies. We recommend shifting 7% into '
                      'Consumer Staples to maintain your target risk level.',
                  actions: [
                    InsightActionButton(
                      label: 'Execute Rebalance',
                      onPressed: _noop,
                      primary: true,
                    ),
                  ],
                ),
                InsightCard(
                  title: 'Market Trend',
                  meta: '2h ago',
                  severity: InsightSeverity.info,
                  body:
                      'Recent Fed announcements regarding interest rate holds '
                      'suggest a stabilizing environment for dividend-income '
                      'assets. Yields on your Treasury holdings are projected '
                      'to remain steady.',
                  highlight: 'Portfolio volatility reduced by 0.4%',
                ),
                InsightCard(
                  title: 'Dividend Alert +20.50',
                  severity: InsightSeverity.positive,
                  body:
                      'Three of your core holdings announced upcoming payouts '
                      'for next Tuesday.',
                  actions: [
                    InsightActionButton(
                      label: 'Set to Reinvest',
                      onPressed: _noop,
                      primary: true,
                    ),
                    InsightActionButton(
                      label: 'View Schedule',
                      onPressed: _noop,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

void _noop() {}
