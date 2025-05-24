// lib/core/errors/error_handler.dart

import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/errors/failures.dart';

class ErrorHandler {
  /// Pemetaan Exception atau DioException → Failure
  static Failure handleException(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return NetworkFailure();
      }
      final resp = error.response;
      if (resp != null) {
        final code = resp.statusCode ?? 0;
        final data = resp.data;
        if (code == 422 && data['errors'] != null) {
          final firstError = (data['errors'] as Map).values.first[0];
          return ValidationFailure(firstError);
        }
        if (code >= 400 && code < 500) {
          final msg = data['message'] ?? 'Input tidak valid.';
          return ValidationFailure(msg);
        }
        if (code >= 500) {
          return ServerFailure();
        }
      }
      return NetworkFailure();
    }
    if (error is Failure) {
      return error;
    }
    // LogicException kalau kamu pakai
    return UnexpectedFailure(error.toString());
  }

  /// Pemetaan Failure → AppError untuk UI
  static AppError handleFailure(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return AppError(failure.message, ErrorType.network);
      case ValidationFailure:
        return AppError(failure.message, ErrorType.business);
      case ServerFailure:
        return AppError(failure.message, ErrorType.server);
      case LogicFailure:
        return AppError(failure.message, ErrorType.logic);
      default:
        return AppError(failure.message, ErrorType.unexpected);
    }
  }
}
