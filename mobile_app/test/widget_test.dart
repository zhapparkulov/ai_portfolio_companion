import 'package:ai_portfolio_companion/app.dart';
import 'package:ai_portfolio_companion/core/di/injection.dart';
import 'package:ai_portfolio_companion/features/chat/domain/repositories/chat_repository.dart';
import 'package:ai_portfolio_companion/features/chat/domain/usecases/send_message_stream.dart';
import 'package:ai_portfolio_companion/features/insights/domain/entities/insight.dart';
import 'package:ai_portfolio_companion/features/insights/domain/entities/insight_action.dart';
import 'package:ai_portfolio_companion/features/insights/domain/entities/insight_severity.dart';
import 'package:ai_portfolio_companion/features/insights/domain/repositories/insights_repository.dart';
import 'package:ai_portfolio_companion/features/insights/domain/usecases/get_insights.dart';
import 'package:ai_portfolio_companion/features/portfolio/domain/entities/holding.dart';
import 'package:ai_portfolio_companion/features/portfolio/domain/entities/portfolio.dart';
import 'package:ai_portfolio_companion/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:ai_portfolio_companion/features/portfolio/domain/usecases/get_portfolio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  tearDown(() async {
    await sl.reset();
  });

  testWidgets('renders portfolio dashboard with holdings', (tester) async {
    await _pumpApp(tester);
    await tester.pumpAndSettle();

    expect(find.text('AI Portfolio'), findsOneWidget);
    expect(find.text('PORTFOLIO'), findsOneWidget);
    expect(find.text('TOTAL BALANCE'), findsOneWidget);
    expect(find.text('Your Holdings'), findsOneWidget);
    expect(find.text(r'$1,000.00'), findsOneWidget);
    expect(find.text(r'$758.00'), findsOneWidget);
    expect(find.text(r'$12.00'), findsOneWidget);
    expect(find.text('+1.20%'), findsWidgets);
    expect(find.text('AAPL'), findsOneWidget);
    expect(find.text('Apple Inc.'), findsOneWidget);
  });

  testWidgets('sends chat message and renders streamed answer', (tester) async {
    await _pumpApp(
      tester,
      chatRepository: const _FakeChatRepository(chunks: [
        'Portfolio ',
        'looks ',
        'balanced.',
      ]),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('CHAT'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText), 'How is my risk?');
    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pumpAndSettle();

    expect(find.text('How is my risk?'), findsOneWidget);
    expect(find.text('Portfolio looks balanced.'), findsOneWidget);
  });

  testWidgets('renders insight card and coming soon action feedback',
      (tester) async {
    await _pumpApp(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('INSIGHTS'));
    await tester.pumpAndSettle();

    expect(find.text('Rebalance now'), findsOneWidget);
    expect(
        find.text('Move 7% from tech into defensive sectors.'), findsOneWidget);

    await tester.tap(find.text('Review Plan'));
    await tester.pump();

    expect(
      find.text('This feature is in development and coming soon.'),
      findsOneWidget,
    );
  });

  testWidgets('switches app locale from English to Russian', (tester) async {
    await _pumpApp(tester);
    await tester.pumpAndSettle();

    expect(find.text('AI Portfolio'), findsOneWidget);
    expect(find.text('Your Holdings'), findsOneWidget);

    await tester.tap(find.text('RU'));
    await tester.pumpAndSettle();

    expect(find.text('AI Портфель'), findsOneWidget);
    expect(find.text('Ваши активы'), findsOneWidget);
  });
}

Future<void> _pumpApp(
  WidgetTester tester, {
  PortfolioRepository portfolioRepository = const _FakePortfolioRepository(),
  ChatRepository chatRepository = const _FakeChatRepository(),
  InsightsRepository insightsRepository = const _FakeInsightsRepository(),
  String initialLocale = 'en',
}) async {
  SharedPreferences.setMockInitialValues({'app_locale': initialLocale});
  await sl.reset();
  await configureDependencies();

  await sl.unregister<GetPortfolio>();
  sl.registerFactory<GetPortfolio>(() => GetPortfolio(portfolioRepository));

  await sl.unregister<SendMessageStream>();
  sl.registerFactory<SendMessageStream>(
    () => SendMessageStream(chatRepository),
  );

  await sl.unregister<GetInsights>();
  sl.registerFactory<GetInsights>(() => GetInsights(insightsRepository));

  await tester.pumpWidget(const AIPortfolioApp());
}

class _FakePortfolioRepository implements PortfolioRepository {
  const _FakePortfolioRepository();

  @override
  Future<PortfolioResult> getPortfolio() async {
    return (
      failure: null,
      portfolio: const Portfolio(
        totalValue: 1000,
        dailyChange: 12,
        dailyChangePercent: 1.2,
        holdings: [
          Holding(
            symbol: 'AAPL',
            name: 'Apple Inc.',
            quantity: 4,
            avgPrice: 150,
            currentPrice: 189.5,
            dailyChangePercent: 1.2,
          ),
        ],
      ),
    );
  }
}

class _FakeChatRepository implements ChatRepository {
  final List<String> chunks;

  const _FakeChatRepository({
    this.chunks = const ['Mock ', 'answer.'],
  });

  @override
  Stream<String> sendMessageStream({
    required String message,
    String? conversationId,
  }) async* {
    for (final chunk in chunks) {
      yield chunk;
    }
  }
}

class _FakeInsightsRepository implements InsightsRepository {
  const _FakeInsightsRepository();

  @override
  Future<InsightsResult> getInsights() async {
    return (
      failure: null,
      insights: const [
        Insight(
          title: 'Rebalance now',
          body: 'Move 7% from tech into defensive sectors.',
          severity: InsightSeverity.priority,
          badgeLabel: 'PRIORITY',
          actions: [
            InsightAction(label: 'Review Plan', primary: true),
          ],
        ),
      ],
    );
  }
}
