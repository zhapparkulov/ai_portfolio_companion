import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../cubit/portfolio_cubit.dart';
import '../widgets/dashboard_insight_card.dart';
import '../widgets/holding_tile.dart';
import '../widgets/portfolio_summary_card.dart';

class PortfolioPage extends StatelessWidget {
  final ValueChanged<AppTab> onTabSelected;

  const PortfolioPage({
    super.key,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'AI Portfolio',
      selectedTab: AppTab.portfolio,
      onTabSelected: onTabSelected,
      avatarIcon: Icons.person,
      avatarColor: AppColors.primary,
      body: BlocBuilder<PortfolioCubit, PortfolioState>(
        builder: (context, state) => switch (state) {
          PortfolioInitial() || PortfolioLoading() => const LoadingView(),
          PortfolioError(:final message) => ErrorView(
              title: 'Portfolio unavailable',
              message: message,
              onRetry: () => context.read<PortfolioCubit>().refresh(),
            ),
          PortfolioLoaded(:final portfolio) => RefreshIndicator(
              color: AppColors.secondary,
              onRefresh: () => context.read<PortfolioCubit>().refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  PortfolioSummaryCard(portfolio: portfolio),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeader(
                    title: 'Your Holdings',
                    actionLabel: 'View All',
                    onAction: () {},
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (portfolio.holdings.isEmpty)
                    EmptyState(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'No holdings yet',
                      message:
                          'Connect a brokerage account to start tracking your portfolio.',
                      actionLabel: 'Refresh Data',
                      onAction: () => context.read<PortfolioCubit>().refresh(),
                    )
                  else
                    ...portfolio.holdings.map(
                      (holding) => HoldingTile(holding: holding),
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  const DashboardInsightCard(),
                ],
              ),
            ),
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.title)),
        AppButton(
          label: actionLabel,
          onPressed: onAction,
          variant: AppButtonVariant.ghost,
          size: AppButtonSize.small,
        ),
      ],
    );
  }
}
