// lib/features/profile/data/models/profile_model.dart
import 'package:puskeswan_app/core/injection/provider_setup.dart';
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.userId,
    required super.photo,
    required super.address,
    required super.nama,
    required super.email,
    required super.no_hp,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final userProfile = json['data']['profile'];
    final user = json['data']['user'];
    return ProfileModel(
      id: userProfile['id'].toString(),
      userId: user['id'].toString(),
      nama: user['nama'],
      email: user['email'],
      no_hp: user['no_hp'] ?? '',
      photo: userProfile['photo'] ?? '' ,
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
    return ProfileEntity(
      id: id,
      userId: userId,
      nama: nama,
      email: email,
      no_hp: no_hp,
      photo: imageUrl+photo,
      address: address,
    );
  }
}
