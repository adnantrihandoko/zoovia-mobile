// lib/features/profile/data/models/profile_model.dart
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.userId,
    required super.photo,
    required super.address,
    required super.name,
    required super.email,
    required super.phoneNumber,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final userProfile = json['data']['profile'];
    final user = json['data']['user'];
    return ProfileModel(
      id: userProfile['id'].toString(),
      userId: user['id'].toString(),
      name: user['nama'],
      email: user['email'],
      phoneNumber: user['no_hp'],
      photo: userProfile['photo'] ?? '',
      address: userProfile['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'photo': photo,
      'address': address,
    };
  }

  // Convert to domain entity
  ProfileEntity toEntity() {
    print("Converting ProfileModel to ProfileEntity: $id, $name, $email, $phoneNumber, $photo, $address");
    return ProfileEntity(
      id: id,
      userId: userId,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      photo: photo,
      address: address,
    );
  }
}
