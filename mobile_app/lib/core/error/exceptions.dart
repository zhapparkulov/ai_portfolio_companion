/// Data-layer exceptions. Repositories catch these and map to Failures
/// so domain and presentation never see raw transport errors.
class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error']);
}

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error']);
}
