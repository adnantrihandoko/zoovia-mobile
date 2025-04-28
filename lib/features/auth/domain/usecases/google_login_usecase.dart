// lib/features/auth/domain/usecases/google_login_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/data/datasources/google_auth_service.dart';
import 'package:puskeswan_app/features/auth/domain/entities/auth_entity.dart';
import 'package:puskeswan_app/features/auth/domain/repositories/auth_repository.dart';

class GoogleLoginUseCase {
  final AuthRepository repository;
  final GoogleAuthService googleAuthService;

  GoogleLoginUseCase(this.repository, this.googleAuthService);

  Future<Either<Failure, AuthEntity>> execute() async {
    try {
      
      // 1. Jalankan proses sign in dengan Google
      final auth = await googleAuthService.signIn();
      
      if (auth == null) {
        return Left(ServerFailure('Login dibatalkan'));
      }
      
      // 2. Prioritaskan Access Token karena ID Token sering null di Android
      final token = auth.idToken;
      
      if (token == null || token.isEmpty) {
        return Left(ServerFailure('Gagal mendapatkan token autentikasi'));
      }
      
      // 3. Kirim token ke server dan dapatkan info user
      final account = await googleAuthService.getCurrentUser();
      if (account == null) {
        return Left(ServerFailure('Tidak dapat mendapatkan info pengguna'));
      }
      
      // 4. Tambahkan email untuk membantu server
      final result = await repository.loginWithGoogle(
        token,
      );
      
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}