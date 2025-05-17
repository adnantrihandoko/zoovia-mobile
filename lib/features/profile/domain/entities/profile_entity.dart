// lib/features/profile/domain/entities/profile_entity.dart
class ProfileEntity {
  final String? id;
  final String userId;
  final String nama;
  final String email;
  final String no_hp;
  final String photo;
  final String? address;

  ProfileEntity({
    this.id,
    required this.nama,
    required this.email,
    required this.no_hp,
    required this.userId,
    required this.photo,
    this.address,
  });
}
