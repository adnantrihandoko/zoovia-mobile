// lib/features/layanan/data/layanan_model.dart
class LayananModel {
  final int id;
  final String namaLayanan;
  final String hargaLayanan;
  final String deskripsiLayanan;
  final String? fotoLayanan;
  final String createdAt;
  final String updatedAt;

  LayananModel({
    required this.id,
    required this.namaLayanan,
    required this.hargaLayanan,
    required this.deskripsiLayanan,
    this.fotoLayanan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LayananModel.fromJson(Map<String, dynamic> json) {
    return LayananModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      namaLayanan: json['nama_layanan'],
      hargaLayanan: json['harga_layanan'],
      deskripsiLayanan: json['deskripsi_layanan'],
      fotoLayanan: json['foto_layanan'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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