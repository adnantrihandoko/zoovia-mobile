// lib/features/profile/data/models/profile_model.dart
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.phoneNumber,
    super.profileImageUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone'],
      profileImageUrl: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phoneNumber,
      'profile_image': profileImageUrl,
    };
  }

  // Convert to domain entity
  ProfileEntity toEntity() => ProfileEntity(
        id: id,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
      );
}