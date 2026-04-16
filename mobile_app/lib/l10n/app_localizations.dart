import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Portfolio Companion'**
  String get appTitle;

  /// No description provided for @notificationsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTooltip;

  /// No description provided for @portfolioTab.
  ///
  /// In en, this message translates to:
  /// **'PORTFOLIO'**
  String get portfolioTab;

  /// No description provided for @chatTab.
  ///
  /// In en, this message translates to:
  /// **'CHAT'**
  String get chatTab;

  /// No description provided for @insightsTab.
  ///
  /// In en, this message translates to:
  /// **'INSIGHTS'**
  String get insightsTab;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @aiPortfolio.
  ///
  /// In en, this message translates to:
  /// **'AI Portfolio'**
  String get aiPortfolio;

  /// No description provided for @portfolioUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Portfolio unavailable'**
  String get portfolioUnavailable;

  /// No description provided for @yourHoldings.
  ///
  /// In en, this message translates to:
  /// **'Your Holdings'**
  String get yourHoldings;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noHoldingsYet.
  ///
  /// In en, this message translates to:
  /// **'No holdings yet'**
  String get noHoldingsYet;

  /// No description provided for @noHoldingsMessage.
  ///
  /// In en, this message translates to:
  /// **'Connect a brokerage account to start tracking your portfolio.'**
  String get noHoldingsMessage;

  /// No description provided for @refreshData.
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'TOTAL BALANCE'**
  String get totalBalance;

  /// No description provided for @dailyChange.
  ///
  /// In en, this message translates to:
  /// **'DAILY CHANGE'**
  String get dailyChange;

  /// No description provided for @aiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get aiInsights;

  /// No description provided for @dashboardInsightBody.
  ///
  /// In en, this message translates to:
  /// **'Your portfolio is currently 12% more volatile than last week. Consider rebalancing toward more stable sectors.'**
  String get dashboardInsightBody;

  /// No description provided for @applyStrategy.
  ///
  /// In en, this message translates to:
  /// **'Apply Strategy'**
  String get applyStrategy;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @activeNow.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE NOW'**
  String get activeNow;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @askInvestmentsHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about your investments...'**
  String get askInvestmentsHint;

  /// No description provided for @typeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessageHint;

  /// No description provided for @chatUnavailable.
  ///
  /// In en, this message translates to:
  /// **'CHAT SERVICE TEMPORARILY UNAVAILABLE'**
  String get chatUnavailable;

  /// No description provided for @riskExposureAlert.
  ///
  /// In en, this message translates to:
  /// **'RISK EXPOSURE ALERT'**
  String get riskExposureAlert;

  /// No description provided for @compareHealthcareEtfs.
  ///
  /// In en, this message translates to:
  /// **'Compare Healthcare ETFs'**
  String get compareHealthcareEtfs;

  /// No description provided for @viewAaplDetails.
  ///
  /// In en, this message translates to:
  /// **'View AAPL Details'**
  String get viewAaplDetails;

  /// No description provided for @connectionLost.
  ///
  /// In en, this message translates to:
  /// **'Connection lost.'**
  String get connectionLost;

  /// No description provided for @connectionLostBody.
  ///
  /// In en, this message translates to:
  /// **'We\'re having trouble reaching the AI assistant.'**
  String get connectionLostBody;

  /// No description provided for @analyzingPortfolioRisk.
  ///
  /// In en, this message translates to:
  /// **'Analyzing portfolio risk'**
  String get analyzingPortfolioRisk;

  /// No description provided for @seedUserMessage.
  ///
  /// In en, this message translates to:
  /// **'How is my tech exposure looking?'**
  String get seedUserMessage;

  /// No description provided for @seedAssistantMessage.
  ///
  /// In en, this message translates to:
  /// **'Your portfolio is currently 65% tech-heavy. While AAPL is performing well, you might consider diversifying into healthcare to mitigate sector risk.'**
  String get seedAssistantMessage;

  /// No description provided for @chatFallbackError.
  ///
  /// In en, this message translates to:
  /// **'Unable to reach the AI assistant.'**
  String get chatFallbackError;

  /// No description provided for @chatEmptyMessageError.
  ///
  /// In en, this message translates to:
  /// **'Message cannot be empty.'**
  String get chatEmptyMessageError;

  /// No description provided for @portfolioInsights.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Insights'**
  String get portfolioInsights;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsTitle;

  /// No description provided for @insightsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No insights yet. Your AI assistant is analyzing your portfolio for new opportunities.'**
  String get insightsEmptyMessage;

  /// No description provided for @aiAnalysisInProgress.
  ///
  /// In en, this message translates to:
  /// **'AI ANALYSIS IN PROGRESS'**
  String get aiAnalysisInProgress;

  /// No description provided for @aiIntelligence.
  ///
  /// In en, this message translates to:
  /// **'AI INTELLIGENCE'**
  String get aiIntelligence;

  /// No description provided for @optimizeForGrowth.
  ///
  /// In en, this message translates to:
  /// **'Optimize for Growth'**
  String get optimizeForGrowth;

  /// No description provided for @insightsHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Based on today\'s market shifts and your risk profile, we\'ve identified 3 key actions to enhance your portfolio\'s performance.'**
  String get insightsHeroBody;

  /// No description provided for @rebalancingOpportunity.
  ///
  /// In en, this message translates to:
  /// **'Rebalancing Opportunity'**
  String get rebalancingOpportunity;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'PRIORITY'**
  String get priority;

  /// No description provided for @rebalancingBody.
  ///
  /// In en, this message translates to:
  /// **'Your Tech exposure has grown to 42% of your portfolio due to recent rallies. We recommend shifting 7% into Consumer Staples to maintain your target risk level.'**
  String get rebalancingBody;

  /// No description provided for @executeRebalance.
  ///
  /// In en, this message translates to:
  /// **'Execute Rebalance'**
  String get executeRebalance;

  /// No description provided for @marketTrend.
  ///
  /// In en, this message translates to:
  /// **'Market Trend'**
  String get marketTrend;

  /// No description provided for @twoHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'2h ago'**
  String get twoHoursAgo;

  /// No description provided for @marketTrendBody.
  ///
  /// In en, this message translates to:
  /// **'Recent Fed announcements regarding interest rate holds suggest a stabilizing environment for dividend-income assets. Yields on your Treasury holdings are projected to remain steady.'**
  String get marketTrendBody;

  /// No description provided for @portfolioVolatilityReduced.
  ///
  /// In en, this message translates to:
  /// **'Portfolio volatility reduced by 0.4%'**
  String get portfolioVolatilityReduced;

  /// No description provided for @dividendAlert.
  ///
  /// In en, this message translates to:
  /// **'Dividend Alert +20.50'**
  String get dividendAlert;

  /// No description provided for @dividendAlertBody.
  ///
  /// In en, this message translates to:
  /// **'Three of your core holdings announced upcoming payouts for next Tuesday.'**
  String get dividendAlertBody;

  /// No description provided for @setToReinvest.
  ///
  /// In en, this message translates to:
  /// **'Set to Reinvest'**
  String get setToReinvest;

  /// No description provided for @viewSchedule.
  ///
  /// In en, this message translates to:
  /// **'View Schedule'**
  String get viewSchedule;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
