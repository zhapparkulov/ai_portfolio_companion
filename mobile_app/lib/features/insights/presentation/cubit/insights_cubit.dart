import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/insight.dart';
import '../../domain/usecases/get_insights.dart';

part 'insights_state.dart';

class InsightsCubit extends Cubit<InsightsState> {
  final GetInsights _getInsights;

  InsightsCubit(this._getInsights) : super(const InsightsInitial());

  Future<void> load() async {
    emit(const InsightsLoading());
    final result = await _getInsights();

    if (result.insights != null) {
      final insights = result.insights!;
      emit(insights.isEmpty ? const InsightsEmpty() : InsightsLoaded(insights));
      return;
    }

    emit(InsightsError(
      result.failure?.message ?? 'Unable to load insights.',
    ));
  }

  Future<void> refresh() => load();
}
