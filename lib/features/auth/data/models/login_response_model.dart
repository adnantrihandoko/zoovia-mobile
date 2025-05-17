// lib/features/auth/data/models/login_response_model.dart

import 'package:puskeswan_app/features/auth/domain/entities/auth_entity.dart';

class LoginResponseModel {
  final String email;
  final String token;
  final String name;
  final String id;

  LoginResponseModel(
      {required this.email,
      required this.token,
      required this.name,
      required this.id});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['status'] == 'success') {
      print('masuk sini');
      final data = json['data'] as Map<String, dynamic>;
      return LoginResponseModel(
        email: data['user']['name'],
        token: data['token'],
        name: data['user']['name'],
        id: data['user']['id'].toString(),
      );
    }

    return LoginResponseModel(
      name: json['user']['name'],
      email: json['user']['email'],
      token: json['token'],
      id: json['user']['id'].toString(),
    );
  }

  AuthEntity toEntity() =>
      AuthEntity(email: email, name: name, token: token, id: id);
}
