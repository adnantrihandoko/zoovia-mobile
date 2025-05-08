// lib/features/auth/data/models/login_response_model.dart

import 'package:puskeswan_app/features/auth/domain/entities/auth_entity.dart';

class LoginResponseModel {
  final String email;
  final String token;
  final String name;
  final String id;

  LoginResponseModel({required this.email, required this.token, required this.name, required this.id});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    
    // Email berada di dalam objek user
    final data = json['data'] as Map<String, dynamic>;
    
    return LoginResponseModel(
      name: data['user']['name'],
      email: data['user']['email'],
      token: data['token'],
      id: data['user']['id'].toString(),
    );
  }

  AuthEntity toEntity() => AuthEntity(email: email, name: name,token: token, id: id);
}