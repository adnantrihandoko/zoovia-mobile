// lib\features\auth\domain\entities\auth_entity.dart

class   AuthEntity {
  final String email;
  final String name;
  final String token;
  final String id;

  AuthEntity({required this.email, required this.name,required this.token, required this.id});
}
