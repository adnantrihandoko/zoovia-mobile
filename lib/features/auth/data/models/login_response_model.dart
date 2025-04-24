// lib\features\auth\data\models\login_response_model.dart

import 'package:puskeswan_app/features/auth/domain/entities/auth_entity.dart';

class LoginResponseModel {
  final String email;
  final String token;

  LoginResponseModel({required this.email, required this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      email: json['email'],
      token: json['token'],
    );
  }

  AuthEntity toEntity() => AuthEntity(email: email, token: token);
}