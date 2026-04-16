import 'package:equatable/equatable.dart';

class InsightAction extends Equatable {
  final String label;
  final bool primary;

  const InsightAction({
    required this.label,
    this.primary = false,
  });

  @override
  List<Object?> get props => [label, primary];
}
