// lib/features/profile/domain/entities/profile_entity.dart
class ProfileEntity {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
  });
}