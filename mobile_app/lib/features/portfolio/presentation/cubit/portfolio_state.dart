part of 'portfolio_cubit.dart';

/// Sealed state — UI must handle every case exhaustively via `switch`.
sealed class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

class PortfolioInitial extends PortfolioState {
  const PortfolioInitial();
}

class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

class PortfolioLoaded extends PortfolioState {
  final Portfolio portfolio;
  const PortfolioLoaded(this.portfolio);

  @override
  List<Object?> get props => [portfolio];
}

class PortfolioError extends PortfolioState {
  final String message;
  const PortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}
