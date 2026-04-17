import 'package:ai_portfolio_companion/app.dart';
import 'package:ai_portfolio_companion/core/di/injection.dart';
import 'package:ai_portfolio_companion/features/portfolio/domain/entities/portfolio.dart';
import 'package:ai_portfolio_companion/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:ai_portfolio_companion/features/portfolio/domain/usecases/get_portfolio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('renders portfolio dashboard shell', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await configureDependencies();
    await sl.unregister<GetPortfolio>();
    sl.registerFactory<GetPortfolio>(
      () => const GetPortfolio(_FakePortfolioRepository()),
    );

    await tester.pumpWidget(const AIPortfolioApp());
    expect(find.text('AI Portfolio'), findsOneWidget);
    expect(find.text('PORTFOLIO'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('TOTAL BALANCE'), findsOneWidget);
    expect(find.text('Your Holdings'), findsOneWidget);
  });
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
        holdings: [],
      ),
    );
  }
}
