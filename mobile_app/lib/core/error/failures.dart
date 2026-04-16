import 'package:equatable/equatable.dart';

/// Domain-layer failure. UI switches on subtypes to render messages.
sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error. Please try again.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong.']);
}
