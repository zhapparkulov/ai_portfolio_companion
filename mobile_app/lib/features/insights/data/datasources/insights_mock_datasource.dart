import '../models/insight_model.dart';
import 'insights_datasource.dart';

class InsightsMockDataSource implements InsightsDataSource {
  @override
  Future<List<InsightModel>> fetchInsights() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    return ((_mockJson['insights'] as List<dynamic>)
        .map((item) => InsightModel.fromJson(item as Map<String, dynamic>))
        .toList());
  }

  static const Map<String, dynamic> _mockJson = {
    'insights': [
      {
        'title': 'Rebalancing Opportunity',
        'badge_label': 'PRIORITY',
        'severity': 'priority',
        'body':
            'Your Tech exposure has grown to 42% of your portfolio due to recent rallies. We recommend shifting 7% into Consumer Staples to maintain your target risk level.',
        'actions': [
          {
            'label': 'Execute Rebalance',
            'primary': true,
          },
        ],
      },
      {
        'title': 'Market Trend',
        'meta': '2h ago',
        'severity': 'info',
        'body':
            'Recent Fed announcements regarding interest rate holds suggest a stabilizing environment for dividend-income assets. Yields on your Treasury holding are projected to remain steady.',
        'highlight': 'Portfolio volatility reduced by 0.4%',
      },
      {
        'title': 'Dividend Alert +20.50',
        'severity': 'positive',
        'body':
            'Three of your core holdings are expected to announce dividends next Tuesday.',
        'actions': [
          {
            'label': 'Set to Reinvest',
            'primary': true,
          },
          {
            'label': 'View Schedule',
          },
        ],
      },
    ],
  };
}
