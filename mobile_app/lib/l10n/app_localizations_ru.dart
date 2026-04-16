// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'AI Portfolio Companion';

  @override
  String get notificationsTooltip => 'Уведомления';

  @override
  String get portfolioTab => 'ПОРТФЕЛЬ';

  @override
  String get chatTab => 'ЧАТ';

  @override
  String get insightsTab => 'ИНСАЙТЫ';

  @override
  String get retry => 'Повторить';

  @override
  String get somethingWentWrong => 'Что-то пошло не так';

  @override
  String get aiPortfolio => 'AI Портфель';

  @override
  String get portfolioUnavailable => 'Портфель недоступен';

  @override
  String get yourHoldings => 'Ваши активы';

  @override
  String get viewAll => 'Смотреть все';

  @override
  String get noHoldingsYet => 'Активов пока нет';

  @override
  String get noHoldingsMessage =>
      'Подключите брокерский счет, чтобы начать отслеживать портфель.';

  @override
  String get refreshData => 'Обновить данные';

  @override
  String get totalBalance => 'ОБЩИЙ БАЛАНС';

  @override
  String get dailyChange => 'ИЗМЕНЕНИЕ ЗА ДЕНЬ';

  @override
  String get aiInsights => 'AI Инсайты';

  @override
  String get dashboardInsightBody =>
      'Ваш портфель сейчас на 12% волатильнее, чем на прошлой неделе. Рассмотрите ребалансировку в сторону более стабильных секторов.';

  @override
  String get applyStrategy => 'Применить стратегию';

  @override
  String get aiAssistant => 'AI Ассистент';

  @override
  String get activeNow => 'АКТИВЕН';

  @override
  String get today => 'СЕГОДНЯ';

  @override
  String get askInvestmentsHint => 'Спросите об инвестициях...';

  @override
  String get typeMessageHint => 'Введите сообщение...';

  @override
  String get chatUnavailable => 'ЧАТ ВРЕМЕННО НЕДОСТУПЕН';

  @override
  String get riskExposureAlert => 'РИСК-КОНЦЕНТРАЦИЯ';

  @override
  String get compareHealthcareEtfs => 'Сравнить Healthcare ETF';

  @override
  String get viewAaplDetails => 'Детали AAPL';

  @override
  String get connectionLost => 'Соединение потеряно.';

  @override
  String get connectionLostBody => 'Не удается связаться с AI-ассистентом.';

  @override
  String get analyzingPortfolioRisk => 'Анализирую риск портфеля';

  @override
  String get seedUserMessage => 'Как выглядит моя экспозиция в tech?';

  @override
  String get seedAssistantMessage =>
      'Ваш портфель сейчас на 65% сконцентрирован в tech. Хотя AAPL показывает хорошие результаты, стоит рассмотреть диверсификацию в healthcare, чтобы снизить секторный риск.';

  @override
  String get chatFallbackError => 'Не удалось связаться с AI-ассистентом.';

  @override
  String get chatEmptyMessageError => 'Сообщение не может быть пустым.';

  @override
  String get mockRiskResponse1 => 'Ваш портфель сейчас ';

  @override
  String get mockRiskResponse2 => 'на 65% сконцентрирован в tech. ';

  @override
  String get mockRiskResponse3 => 'AAPL и NVDA дают большую часть роста, ';

  @override
  String get mockRiskResponse4 =>
      'но риск снижения сосредоточен в одном секторе. ';

  @override
  String get mockRiskResponse5 =>
      'Рассмотрите перенос 7% в healthcare или дивидендные активы.';

  @override
  String get mockDefaultResponse1 => 'Сегодня портфель растет, ';

  @override
  String get mockDefaultResponse2 => 'особенно за счет крупных tech-компаний. ';

  @override
  String get mockDefaultResponse3 =>
      'AI-рекомендация — удерживать победителей, ';

  @override
  String get mockDefaultResponse4 =>
      'но постепенно ребалансировать, если tech превысит целевой диапазон.';

  @override
  String get portfolioInsights => 'Инсайты портфеля';

  @override
  String get insightsTitle => 'Инсайты';

  @override
  String get insightsEmptyMessage =>
      'Инсайтов пока нет. AI-ассистент анализирует ваш портфель и ищет новые возможности.';

  @override
  String get aiAnalysisInProgress => 'AI-АНАЛИЗ В ПРОЦЕССЕ';

  @override
  String get aiIntelligence => 'AI INTELLIGENCE';

  @override
  String get optimizeForGrowth => 'Оптимизация роста';

  @override
  String get insightsHeroBody =>
      'С учетом сегодняшних рыночных изменений и вашего риск-профиля мы нашли 3 действия для улучшения эффективности портфеля.';

  @override
  String get rebalancingOpportunity => 'Возможность ребалансировки';

  @override
  String get priority => 'ПРИОРИТЕТ';

  @override
  String get rebalancingBody =>
      'Доля Tech выросла до 42% портфеля из-за недавнего ралли. Рекомендуем перенести 7% в Consumer Staples, чтобы сохранить целевой уровень риска.';

  @override
  String get executeRebalance => 'Ребалансировать';

  @override
  String get marketTrend => 'Рыночный тренд';

  @override
  String get twoHoursAgo => '2 ч назад';

  @override
  String get marketTrendBody =>
      'Недавние заявления ФРС о паузе по ставкам указывают на более стабильную среду для дивидендных активов. Доходность ваших Treasury-позиций, вероятно, останется устойчивой.';

  @override
  String get portfolioVolatilityReduced =>
      'Волатильность портфеля снижена на 0.4%';

  @override
  String get dividendAlert => 'Дивиденд +20.50';

  @override
  String get dividendAlertBody =>
      'Три ваших базовых актива объявили выплаты на следующий вторник.';

  @override
  String get setToReinvest => 'Реинвестировать';

  @override
  String get viewSchedule => 'График выплат';
}
