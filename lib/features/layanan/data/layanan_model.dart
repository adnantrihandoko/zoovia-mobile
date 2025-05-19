// lib/features/layanan/data/layanan_model.dart
import 'package:puskeswan_app/core/injection/provider_setup.dart';
import 'package:puskeswan_app/features/dokter/dokter_model.dart';

class LayananModel {
  final int id;
  final String namaLayanan;
  final String hargaLayanan;
  final String deskripsiLayanan;
  final String? fotoLayanan;
  final String? createdAt;
  final String? updatedAt;
  
  // Relasi
  final List<DokterModel>? dokters;

  LayananModel({
    required this.id,
    required this.namaLayanan,
    required this.hargaLayanan,
    required this.deskripsiLayanan,
    this.fotoLayanan,
    this.createdAt,
    this.updatedAt,
    this.dokters,
  });

  factory LayananModel.fromJson(Map<String, dynamic> json) {
    // Handle dokters jika ada
    List<DokterModel>? doktersList;
    if (json['dokters'] != null) {
      doktersList = (json['dokters'] as List)
          .map((dokter) => DokterModel.fromJson(dokter))
          .toList();
    }
    
    return LayananModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      namaLayanan: json['nama_layanan'],
      hargaLayanan: json['harga_layanan'],
      deskripsiLayanan: json['deskripsi_layanan'],
      fotoLayanan: json['foto_layanan'] == null ? '' : imageUrl+"storage/"+json['foto_layanan'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      dokters: doktersList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_layanan': namaLayanan,
      'harga_layanan': hargaLayanan,
      'deskripsi_layanan': deskripsiLayanan,
      'foto_layanan': fotoLayanan,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}