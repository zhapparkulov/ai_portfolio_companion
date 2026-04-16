import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/chat/presentation/pages/chat_page.dart';
import 'features/insights/presentation/pages/insights_page.dart';
import 'features/portfolio/domain/usecases/get_portfolio.dart';
import 'features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'features/portfolio/presentation/pages/portfolio_page.dart';
import 'shared/widgets/app_scaffold.dart';

class AIPortfolioApp extends StatelessWidget {
  const AIPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Portfolio Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _AppShell(),
    );
  }
}

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  AppTab _selectedTab = AppTab.portfolio;

  void _selectTab(AppTab tab) {
    setState(() => _selectedTab = tab);
  }

  @override
  Widget build(BuildContext context) {
    return switch (_selectedTab) {
      AppTab.portfolio => BlocProvider(
          create: (_) => PortfolioCubit(sl<GetPortfolio>())..load(),
          child: PortfolioPage(onTabSelected: _selectTab),
        ),
      AppTab.chat => ChatPage(onTabSelected: _selectTab),
      AppTab.insights => InsightsPage(onTabSelected: _selectTab),
    };
  }
}
