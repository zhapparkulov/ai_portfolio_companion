import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/portfolio_cubit.dart';
import '../widgets/holding_tile.dart';
import '../widgets/portfolio_summary_card.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PortfolioCubit>().refresh(),
          ),
        ],
      ),
      body: BlocBuilder<PortfolioCubit, PortfolioState>(
        builder: (context, state) => switch (state) {
          PortfolioInitial() || PortfolioLoading() =>
            const Center(child: CircularProgressIndicator()),
          PortfolioError(:final message) => _ErrorView(
              message: message,
              onRetry: () => context.read<PortfolioCubit>().refresh(),
            ),
          PortfolioLoaded(:final portfolio) => RefreshIndicator(
              onRefresh: () => context.read<PortfolioCubit>().refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  PortfolioSummaryCard(portfolio: portfolio),
                  const SizedBox(height: 20),
                  Text(
                    'Holdings',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...portfolio.holdings.map((h) => HoldingTile(holding: h)),
                ],
              ),
            ),
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
