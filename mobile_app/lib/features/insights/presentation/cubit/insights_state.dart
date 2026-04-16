part of 'insights_cubit.dart';

sealed class InsightsState extends Equatable {
  const InsightsState();

  @override
  List<Object?> get props => [];
}

class InsightsInitial extends InsightsState {
  const InsightsInitial();
}

class InsightsLoading extends InsightsState {
  const InsightsLoading();
}

class InsightsLoaded extends InsightsState {
  final List<Insight> insights;

  const InsightsLoaded(this.insights);

  @override
  List<Object?> get props => [insights];
}

class InsightsEmpty extends InsightsState {
  const InsightsEmpty();
}

class InsightsError extends InsightsState {
  final String message;

  const InsightsError(this.message);

  @override
  List<Object?> get props => [message];
}
