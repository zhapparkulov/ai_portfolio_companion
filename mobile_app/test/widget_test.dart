import 'package:ai_portfolio_companion/app.dart';
import 'package:ai_portfolio_companion/core/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders portfolio dashboard shell', (tester) async {
    configureDependencies();

    await tester.pumpWidget(const AIPortfolioApp());
    expect(find.text('AI Portfolio'), findsOneWidget);
    expect(find.text('PORTFOLIO'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('TOTAL BALANCE'), findsOneWidget);
    expect(find.text('Your Holdings'), findsOneWidget);
  });
}
