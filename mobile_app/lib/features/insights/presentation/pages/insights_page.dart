import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/l10n_extensions.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/coming_soon_snackbar.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../../domain/entities/insight.dart';
import '../cubit/insights_cubit.dart';
import '../widgets/insight_card.dart';

class InsightsPage extends StatelessWidget {
  final ValueChanged<AppTab> onTabSelected;

  const InsightsPage({
    super.key,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.portfolioInsights,
      selectedTab: AppTab.insights,
      onTabSelected: onTabSelected,
      avatarIcon: Icons.person,
      avatarColor: AppColors.primary,
      body: BlocBuilder<InsightsCubit, InsightsState>(
        builder: (context, state) => switch (state) {
          InsightsInitial() || InsightsLoading() => const LoadingView(),
          InsightsEmpty() => EmptyState(
              icon: Icons.insights,
              title: context.l10n.insightsTitle,
              message: context.l10n.insightsEmptyMessage,
              actionLabel: context.l10n.refreshData,
              onAction: () => context.read<InsightsCubit>().refresh(),
              statusLabel: context.l10n.aiAnalysisInProgress,
            ),
          InsightsError(:final message) => ErrorView(
              title: context.l10n.insightsTitle,
              message: message,
              onRetry: () => context.read<InsightsCubit>().refresh(),
            ),
          InsightsLoaded(:final insights) => RefreshIndicator(
              color: AppColors.secondary,
              onRefresh: () => context.read<InsightsCubit>().refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  const InsightsHeroCard(),
                  const SizedBox(height: AppSpacing.lg),
                  ...insights.map(_InsightItem.new),
                ],
              ),
            ),
        },
      ),
    );
  }
}

class _InsightItem extends StatelessWidget {
  final Insight insight;

  const _InsightItem(this.insight);

  @override
  Widget build(BuildContext context) {
    return InsightCard(
      title: insight.title,
      body: insight.body,
      badgeLabel: insight.badgeLabel,
      meta: insight.meta,
      severity: insight.severity,
      highlight: insight.highlight,
      actions: insight.actions
          .map(
            (action) => InsightActionButton(
              label: action.label,
              primary: action.primary,
              onPressed: () => showComingSoonSnackBar(context),
            ),
          )
          .toList(),
    );
  }
}
