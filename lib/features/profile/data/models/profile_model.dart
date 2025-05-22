import 'dart:io';

import 'package:dio/dio.dart';
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    String? id,
    required String userId,
    required String nama,
    required String email,
    required String noHp,
    String? photoUrl,
    File? photoFile,
    String? address,
  }) : super(
          id: id,
          userId: userId,
          nama: nama,
          email: email,
          noHp: noHp,
          photoUrl: photoUrl,
          photoFile: photoFile,
          address: address,
        );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['data']['user'];
    final profile = json['data']['profile'];

    return ProfileModel(
      id: user['id']?.toString(),
      userId: user['id']?.toString() ?? '',
      nama: user['nama'] ?? '',
      email: user['email'] ?? '',
      noHp: user['no_hp'] ?? '',
      photoUrl: profile['photo'] as String? ?? '',
      address: profile['address'] as String? ?? '',
    );
  }

  /// Bila perlu request tanpa foto
  @override
  Map<String, dynamic> toJson() => super.toJson();

  /// Bisa override jika mau menjaga chaining
  @override
  Future<FormData> toFormData() => super.toFormData();
}