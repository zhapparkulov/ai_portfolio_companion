import 'package:equatable/equatable.dart';

import 'insight_action.dart';
import 'insight_severity.dart';

class Insight extends Equatable {
  final String title;
  final String body;
  final InsightSeverity severity;
  final String? badgeLabel;
  final String? meta;
  final String? highlight;
  final List<InsightAction> actions;

  const Insight({
    required this.title,
    required this.body,
    required this.severity,
    this.badgeLabel,
    this.meta,
    this.highlight,
    this.actions = const [],
  });

  @override
  List<Object?> get props => [
        title,
        body,
        severity,
        badgeLabel,
        meta,
        highlight,
        actions,
      ];
}
