// lib/features/rekam_medis/data/rekam_medis_model.dart
import 'package:puskeswan_app/features/dokter/dokter_model.dart';
import 'package:puskeswan_app/features/hewanku/data/hewan_model.dart';

class RekamMedisModel {
  final int id;
  final int idHewan;
  final int idDokter;
  final String? deskripsi;
  final String? createdAt;
  final String? updatedAt;
  
  // Relasi
  final Hewan? hewan;
  final DokterModel? dokter;

  RekamMedisModel({
    required this.id,
    required this.idHewan,
    required this.idDokter,
    this.deskripsi,
    this.createdAt,
    this.updatedAt,
    this.hewan,
    this.dokter,
  });

  factory RekamMedisModel.fromJson(Map<String, dynamic> json) {
    return RekamMedisModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      idHewan: json['id_hewan'] is String ? int.parse(json['id_hewan']) : json['id_hewan'],
      idDokter: json['id_dokter'] is String ? int.parse(json['id_dokter']) : json['id_dokter'],
      deskripsi: json['deskripsi'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      hewan: json['hewan'] != null ? Hewan.fromJson(json['hewan']) : null,
      dokter: json['dokter'] != null ? DokterModel.fromJson(json['dokter']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_hewan': idHewan,
      'id_dokter': idDokter,
      'deskripsi': deskripsi,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}