// lib/core/errors/failures.dart
enum ErrorType {
  business,
  logic,
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

class LogicFailure extends Failure {
  LogicFailure()
      : super('Terjadi kesalahan internal. Tim kami sudah diberi tahu.');
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure([String message = 'Kesalahan tak terduga.'])
      : super(message);
}
