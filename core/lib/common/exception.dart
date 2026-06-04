class ServerException implements Exception {
  final String message;

  ServerException([this.message = 'An error occurred while communicating with the server.']);
}

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}
