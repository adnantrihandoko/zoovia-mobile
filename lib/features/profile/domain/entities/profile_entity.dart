// lib/features/profile/domain/entities/profile_entity.dart
class ProfileEntity {
  final String? id;
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String photo;
  final String? address;

  ProfileEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.userId,
    required this.photo,
    this.address,
  });
}
