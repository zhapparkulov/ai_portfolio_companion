import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/l10n_extensions.dart';
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
      title: context.l10n.portfolioInsights,
      selectedTab: AppTab.insights,
      onTabSelected: onTabSelected,
      avatarIcon: Icons.person,
      avatarColor: AppColors.primary,
      body: showEmpty
          ? EmptyState(
              icon: Icons.insights,
              title: context.l10n.insightsTitle,
              message: context.l10n.insightsEmptyMessage,
              actionLabel: context.l10n.refreshData,
              onAction: () {},
              statusLabel: context.l10n.aiAnalysisInProgress,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              children: [
                const InsightsHeroCard(),
                const SizedBox(height: AppSpacing.lg),
                InsightCard(
                  title: context.l10n.rebalancingOpportunity,
                  badgeLabel: context.l10n.priority,
                  severity: InsightSeverity.priority,
                  body: context.l10n.rebalancingBody,
                  actions: [
                    InsightActionButton(
                      label: context.l10n.executeRebalance,
                      onPressed: _noop,
                      primary: true,
                    ),
                  ],
                ),
                InsightCard(
                  title: context.l10n.marketTrend,
                  meta: context.l10n.twoHoursAgo,
                  severity: InsightSeverity.info,
                  body: context.l10n.marketTrendBody,
                  highlight: context.l10n.portfolioVolatilityReduced,
                ),
                InsightCard(
                  title: context.l10n.dividendAlert,
                  severity: InsightSeverity.positive,
                  body: context.l10n.dividendAlertBody,
                  actions: [
                    InsightActionButton(
                      label: context.l10n.setToReinvest,
                      onPressed: _noop,
                      primary: true,
                    ),
                    InsightActionButton(
                      label: context.l10n.viewSchedule,
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
