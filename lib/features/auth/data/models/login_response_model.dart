// lib/features/auth/data/models/login_response_model.dart

import 'package:puskeswan_app/features/auth/domain/entities/auth_entity.dart';

class LoginResponseModel {
  final String email;
  final String token;
  final String name;

  LoginResponseModel({required this.email, required this.token, required this.name});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    
    // Email berada di dalam objek user
    final user = json['user'] as Map<String, dynamic>;
    
    return LoginResponseModel(
      email: user['email'],
      token: user['token'],
      name: user['nama'],
    );
  }

  AuthEntity toEntity() => AuthEntity(email: email, name: name,token: token);
}