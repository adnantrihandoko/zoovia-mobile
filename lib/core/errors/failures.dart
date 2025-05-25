// lib/core/errors/failures.dart
enum ErrorType {
  business,
  network,
  server,
  unexpected,
}

abstract class Failure {
  final String message;
  Failure(this.message);
}

class AppError {
  final String message;
  final ErrorType type;

  AppError(this.message, this.type);
}

class NetworkFailure extends Failure {
  NetworkFailure([String message = 'Tidak ada koneksi. Periksa internet Anda.'])
      : super(message);
}

class ServerFailure extends Failure {
  ServerFailure([String message = 'Server bermasalah. Coba lagi nanti.'])
      : super(message);
}

class ValidationFailure extends Failure {
  ValidationFailure(String message) : super(message);
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure([String message = 'Terjadi kesalahan teknis. Tim kami segera memperbaikinya.'])
      : super(message);
}
