// lib\features\auth\domain\entities\auth_entity.dart

class AuthEntity {
  final String email;
  final String name;
  final String? token;

  AuthEntity({required this.email, required this.name, this.token});
}
