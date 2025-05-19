// lib/features/dokter/data/dokter_model.dart
import 'package:puskeswan_app/core/injection/provider_setup.dart';
import 'package:puskeswan_app/features/layanan/data/layanan_model.dart';

class DokterModel {
  final int id;
  final String namaDokter;
  final int? idLayanan;
  final String? fotoDokter;
  final String? createdAt;
  final String? updatedAt;
  
  // Relasi
  final LayananModel? layanan;

  DokterModel({
    required this.id,
    required this.namaDokter,
    this.idLayanan,
    this.fotoDokter,
    this.createdAt,
    this.updatedAt,
    this.layanan,
  });

  factory DokterModel.fromJson(Map<String, dynamic> json) {
    return DokterModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      namaDokter: json['nama_dokter'],
      idLayanan: json['id_layanan'] != null ? 
        (json['id_layanan'] is String ? int.parse(json['id_layanan']) : json['id_layanan']) : null,
      fotoDokter: imageUrl+"storage/"+json['foto_dokter'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      layanan: json['layanan'] != null ? LayananModel.fromJson(json['layanan']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_dokter': namaDokter,
      'id_layanan': idLayanan,
      'foto_dokter': fotoDokter,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}