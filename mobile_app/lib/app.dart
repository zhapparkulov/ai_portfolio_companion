import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'features/portfolio/domain/usecases/get_portfolio.dart';
import 'features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'features/portfolio/presentation/pages/portfolio_page.dart';

class AIPortfolioApp extends StatelessWidget {
  const AIPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Portfolio Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0E7C66)),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => PortfolioCubit(sl<GetPortfolio>())..load(),
        child: const PortfolioPage(),
      ),
    );
  }
}
