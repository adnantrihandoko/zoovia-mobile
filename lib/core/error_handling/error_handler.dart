enum ErrorType {
  business,
  logic,
  network,
  server,
  unexpected,
}

class AppError {
  final String message;
  final ErrorType type;

  AppError(this.message, this.type);
}

class ErrorHandler {
  static AppError handleError(dynamic error) {
    // Contoh implementasi sederhana, sesuaikan dengan kebutuhan
    if (error is NetworkException) {
      return AppError(
          'Terjadi masalah jaringan. Silakan coba lagi.', ErrorType.network);
    } else if (error is ServerException) {
      return AppError('Terjadi kesalahan server. Silakan coba lagi nanti.',
          ErrorType.server);
    } else if (error is BusinessException) {
      return AppError(error.message, ErrorType.business);
    } else if (error is LogicException) {
      return AppError('Terjadi kesalahan logika aplikasi.', ErrorType.logic);
    } else {
      return AppError('Terjadi kesalahan tak terduga.', ErrorType.unexpected);
    }
  }
}

// Contoh exception khusus
class NetworkException implements Exception {}

class ServerException implements Exception {}

class BusinessException implements Exception {
  final String message;
  BusinessException(this.message);
}

class LogicException implements Exception {}
