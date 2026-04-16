import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../extensions/l10n_extensions.dart';

enum AppTab { portfolio, chat, insights }

class AppScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final AppTab selectedTab;
  final ValueChanged<AppTab> onTabSelected;
  final IconData? avatarIcon;
  final Color avatarColor;
  final List<Widget> actions;
  final Widget? bottomContent;

  const AppScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    required this.selectedTab,
    required this.onTabSelected,
    this.avatarIcon,
    this.avatarColor = AppColors.primary,
    this.actions = const [],
    this.bottomContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _AppHeader(
                    title: title,
                    subtitle: subtitle,
                    avatarIcon: avatarIcon,
                    avatarColor: avatarColor,
                    actions: actions,
                  ),
                  Expanded(child: body),
                  if (bottomContent != null) bottomContent!,
                ],
              ),
            ),
          ),
          AppBottomNavigation(
            selectedTab: selectedTab,
            onTabSelected: onTabSelected,
          ),
        ],
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? avatarIcon;
  final Color avatarColor;
  final List<Widget> actions;

  const _AppHeader({
    required this.title,
    required this.subtitle,
    required this.avatarIcon,
    required this.avatarColor,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: avatarColor.withValues(alpha: 0.12),
            child: Icon(
              avatarIcon ?? Icons.person,
              size: 15,
              color: avatarColor,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.positive,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(width: 6, height: 6),
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        subtitle!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (actions.isEmpty)
            IconButton(
              tooltip: context.l10n.notificationsTooltip,
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, size: 22),
            )
          else
            ...actions,
        ],
      ),
    );
  }
}

class AppBottomNavigation extends StatelessWidget {
  final AppTab selectedTab;
  final ValueChanged<AppTab> onTabSelected;

  const AppBottomNavigation({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomPadding =
        bottomInset > AppSpacing.sm ? bottomInset : AppSpacing.sm;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withValues(alpha: 0.9),
            width: 0.6,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          bottomPadding,
        ),
        child: Row(
          children: [
            _NavItem(
              tab: AppTab.portfolio,
              selectedTab: selectedTab,
              icon: Icons.pie_chart_outline,
              selectedIcon: Icons.pie_chart,
              label: context.l10n.portfolioTab,
              onTap: onTabSelected,
            ),
            _NavItem(
              tab: AppTab.chat,
              selectedTab: selectedTab,
              icon: Icons.smart_toy_outlined,
              selectedIcon: Icons.smart_toy,
              label: context.l10n.chatTab,
              onTap: onTabSelected,
            ),
            _NavItem(
              tab: AppTab.insights,
              selectedTab: selectedTab,
              icon: Icons.lightbulb_outline,
              selectedIcon: Icons.lightbulb,
              label: context.l10n.insightsTab,
              onTap: onTabSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final AppTab tab;
  final AppTab selectedTab;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final ValueChanged<AppTab> onTap;

  const _NavItem({
    required this.tab,
    required this.selectedTab,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = tab == selectedTab;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(tab),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? AppColors.secondary : AppColors.textMuted,
                size: 20,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: isSelected ? AppColors.secondary : AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
