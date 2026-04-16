import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/locale_storage.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/chat/domain/usecases/send_message_stream.dart';
import 'features/chat/presentation/cubit/chat_cubit.dart';
import 'features/chat/presentation/pages/chat_page.dart';
import 'features/insights/domain/usecases/get_insights.dart';
import 'features/insights/presentation/cubit/insights_cubit.dart';
import 'features/insights/presentation/pages/insights_page.dart';
import 'features/portfolio/domain/usecases/get_portfolio.dart';
import 'features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'features/portfolio/presentation/pages/portfolio_page.dart';
import 'l10n/app_localizations.dart';
import 'shared/widgets/app_scaffold.dart';

class AIPortfolioApp extends StatefulWidget {
  const AIPortfolioApp({super.key});

  @override
  State<AIPortfolioApp> createState() => _AIPortfolioAppState();
}

class _AIPortfolioAppState extends State<AIPortfolioApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = sl<LocaleStorage>().getLocale();
  }

  void _changeLocale(Locale locale) {
    if (_locale == locale) return;
    setState(() => _locale = locale);
    sl<LocaleStorage>().saveLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: _AppShell(
        currentLocale: _locale,
        onLocaleChanged: _changeLocale,
      ),
    );
  }
}

class _AppShell extends StatefulWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const _AppShell({
    required this.currentLocale,
    required this.onLocaleChanged,
  });

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
          child: PortfolioPage(
            currentLocale: widget.currentLocale,
            onLocaleChanged: widget.onLocaleChanged,
            onTabSelected: _selectTab,
          ),
        ),
      AppTab.chat => BlocProvider(
          create: (_) => ChatCubit(sl<SendMessageStream>()),
          child: ChatPage(onTabSelected: _selectTab),
        ),
      AppTab.insights => BlocProvider(
          create: (_) => InsightsCubit(sl<GetInsights>())..load(),
          child: InsightsPage(onTabSelected: _selectTab),
        ),
    };
  }
}
