// lib\core\errors\failures.dart

abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([String message = 'Server error']) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('No internet connection');
}

class GoogleSignInFailure extends Failure {
  GoogleSignInFailure() : super('Gagal login dengan Google');
}