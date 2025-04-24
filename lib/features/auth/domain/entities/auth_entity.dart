// lib\features\auth\domain\entities\auth_entity.dart

class AuthEntity {
  final String email;
  final String? token;

  AuthEntity({required this.email, this.token});
}