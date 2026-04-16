import '../../domain/entities/insight.dart';
import '../../domain/entities/insight_action.dart';
import '../../domain/entities/insight_severity.dart';

class InsightModel extends Insight {
  const InsightModel({
    required super.title,
    required super.body,
    required super.severity,
    super.badgeLabel,
    super.meta,
    super.highlight,
    super.actions,
  });

  factory InsightModel.fromJson(Map<String, dynamic> json) {
    return InsightModel(
      title: json['title'] as String,
      body: json['body'] as String,
      severity: _severityFromJson(json['severity'] as String?),
      badgeLabel: json['badge_label'] as String?,
      meta: json['meta'] as String?,
      highlight: json['highlight'] as String?,
      actions: ((json['actions'] as List<dynamic>?) ?? const [])
          .map((item) => _actionFromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

InsightSeverity _severityFromJson(String? value) {
  return switch (value) {
    'priority' => InsightSeverity.priority,
    'positive' => InsightSeverity.positive,
    'risk' => InsightSeverity.risk,
    _ => InsightSeverity.info,
  };
}

InsightAction _actionFromJson(Map<String, dynamic> json) {
  return InsightAction(
    label: json['label'] as String,
    primary: json['primary'] as bool? ?? false,
  );
}
