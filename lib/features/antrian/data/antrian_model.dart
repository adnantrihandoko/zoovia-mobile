// lib/features/antrian/data/antrian_model.dart
class AntrianModel {
  final int id;
  final String nama;
  final String keluhan;
  final String status; // Menambahkan status
  final int idLayanan;
  final int idUser;
  final int idHewan;
  final String namaLayanan;
  final String namaHewan;
  final DateTime createdAt;
  final DateTime updatedAt;

  AntrianModel({
    required this.id,
    required this.nama,
    required this.keluhan,
    required this.status,
    required this.idLayanan,
    required this.idUser,
    required this.idHewan,
    required this.namaLayanan,
    required this.namaHewan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AntrianModel.fromJson(Map<String, dynamic> json) {
    return AntrianModel(
      id: json['id'],
      nama: json['nama'],
      keluhan: json['keluhan'],
      status: json['status'] ?? 'menunggu',
      idLayanan: json['id_layanan'],
      idUser: json['id_user'],
      idHewan: json['id_hewan'],
      namaLayanan: json['layanan']?['nama_layanan'] ?? 'Tidak ada layanan',
      namaHewan: json['hewan']?['nama_hewan'] ?? 'Tidak ada hewan',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'keluhan': keluhan,
      'status': status,
      'id_layanan': idLayanan,
      'id_user': idUser,
      'id_hewan': idHewan,
      'layanan': {'nama_layanan': namaLayanan},
      'hewan': {'nama_hewan': namaHewan},
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}