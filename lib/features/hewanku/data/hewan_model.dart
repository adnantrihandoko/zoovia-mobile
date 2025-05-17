// lib/models/hewan_model.dart
import 'package:puskeswan_app/core/injection/provider_setup.dart';

class Hewan {
  final int id;
  final int idUser;
  final String namaHewan;
  final String jenisHewan;
  final String? ras;
  final int umur;
  final String? fotoHewan;
  final String createdAt;
  final String updatedAt;

  Hewan({
    required this.id,
    required this.idUser,
    required this.namaHewan,
    required this.jenisHewan,
    this.ras,
    required this.umur,
    this.fotoHewan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Hewan.fromJson(Map<String, dynamic> json) {
  return Hewan(
    id: json['id'] is String ? int.parse(json['id']) : json['id'],
    idUser: json['id_user'] is String ? int.parse(json['id_user']) : json['id_user'],
    namaHewan: json['nama_hewan'],
    jenisHewan: json['jenis_hewan'],
    ras: json['ras'],
    umur: json['umur'] is String ? int.parse(json['umur']) : json['umur'],
    fotoHewan: json['foto_hewan'] == null ? '' : imageUrl+json['foto_hewan'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user': idUser,
      'nama_hewan': namaHewan,
      'jenis_hewan': jenisHewan,
      'ras': ras,
      'umur': umur,
      'foto_hewan': fotoHewan,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}