// lib\core\errors\failures.dart

abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([String message = 'Server error']) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure([String message = 'Kesalahan Jaringan']) : super(message);
}

class GoogleSignInFailure extends Failure {
  GoogleSignInFailure() : super('Gagal login dengan Google');
}

class BusinessException implements Exception{
  final String message;
  
  BusinessException(this.message);
  
  @override
  String toString() => message;
}