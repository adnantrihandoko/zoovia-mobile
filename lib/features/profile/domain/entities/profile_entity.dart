import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:puskeswan_app/core/injection/provider_setup.dart';

class ProfileEntity {
  final String? id;
  final String userId;
  final String nama;
  final String email;
  final String noHp;
  final String? photoUrl;
  final File? photoFile;
  final String? address;

  ProfileEntity({
    this.id,
    required this.userId,
    required this.nama,
    required this.email,
    required this.noHp,
    this.photoUrl,
    this.photoFile,
    this.address,
  });

  String? get fullPhotoUrl {
    if (photoUrl == null) return null;
    debugPrint('${imageUrl}storage/${photoUrl!}');
    return '${imageUrl}storage/${photoUrl!}';
  }

  /// Untuk serialisasi form fields (tanpa file)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'nama': nama,
      'email': email,
      'no_hp': noHp,
      if (address != null) 'address': address,
    };
  }

  /// Untuk multipart/form-data upload (termasuk file jika ada)
  Future<FormData> toFormData() async {
    final data = toJson();
    if (photoFile != null) {
      final multipart = await MultipartFile.fromFile(
        photoFile!.path,
        filename: photoFile!.path.split(Platform.pathSeparator).last,
      );
      data['photo'] = multipart;
    }
    return FormData.fromMap(data);
  }
}
