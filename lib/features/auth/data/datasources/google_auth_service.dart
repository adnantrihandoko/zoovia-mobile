// lib/features/auth/data/datasources/google_auth_service.dart

import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '',
    scopes: [
      'email',
      'openid',
      'profile',
    ],
  );

  Future<GoogleSignInAuthentication?> signIn() async {
    try {
      
      // Reset status sign-in terlebih dahulu
      await _googleSignIn.signOut();
      
      // Mulai proses sign in
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      
      if (account == null) {
        throw Exception('Login dibatalkan oleh pengguna');
      }
      
      // Dapatkan informasi autentikasi
      final GoogleSignInAuthentication auth = await account.authentication;
      
      return auth;
    } catch (error) {
      throw Exception('Gagal login dengan Google: $error');
    }
  }

  Future<GoogleSignInAccount?> getCurrentUser() async {
    return _googleSignIn.currentUser;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}