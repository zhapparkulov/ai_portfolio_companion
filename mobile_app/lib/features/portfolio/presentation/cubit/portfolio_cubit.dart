import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/portfolio.dart';
import '../../domain/usecases/get_portfolio.dart';

part 'portfolio_state.dart';

/// Owns the portfolio screen's state.
/// Only knows about the use case — never touches Dio or repositories directly.
class PortfolioCubit extends Cubit<PortfolioState> {
  final GetPortfolio _getPortfolio;

  PortfolioCubit(this._getPortfolio) : super(const PortfolioInitial());

  Future<void> load() async {
    emit(const PortfolioLoading());
    final result = await _getPortfolio();

    if (result.portfolio != null) {
      emit(PortfolioLoaded(result.portfolio!));
    } else {
      emit(PortfolioError(
        result.failure?.message ?? 'Unable to load portfolio.',
      ));
    }
  }

  Future<void> refresh() => load();
}
