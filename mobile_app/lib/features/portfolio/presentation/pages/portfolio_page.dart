import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/extensions/l10n_extensions.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/language_switcher.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../cubit/portfolio_cubit.dart';
import '../widgets/dashboard_insight_card.dart';
import '../widgets/holding_tile.dart';
import '../widgets/portfolio_summary_card.dart';

class PortfolioPage extends StatelessWidget {
  final ValueChanged<AppTab> onTabSelected;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const PortfolioPage({
    super.key,
    required this.onTabSelected,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.aiPortfolio,
      selectedTab: AppTab.portfolio,
      onTabSelected: onTabSelected,
      avatarIcon: Icons.person,
      avatarColor: AppColors.primary,
      actions: [
        LanguageSwitcher(
          currentLocale: currentLocale,
          onLocaleChanged: onLocaleChanged,
        ),
        IconButton(
          tooltip: context.l10n.notificationsTooltip,
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, size: 22),
        ),
      ],
      body: BlocBuilder<PortfolioCubit, PortfolioState>(
        builder: (context, state) => switch (state) {
          PortfolioInitial() || PortfolioLoading() => const LoadingView(),
          PortfolioError(:final message) => ErrorView(
              title: context.l10n.portfolioUnavailable,
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
                    title: context.l10n.yourHoldings,
                    actionLabel: context.l10n.viewAll,
                    onAction: () {},
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (portfolio.holdings.isEmpty)
                    EmptyState(
                      icon: Icons.account_balance_wallet_outlined,
                      title: context.l10n.noHoldingsYet,
                      message: context.l10n.noHoldingsMessage,
                      actionLabel: context.l10n.refreshData,
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
