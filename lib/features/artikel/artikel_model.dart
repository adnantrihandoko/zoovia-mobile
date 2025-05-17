// lib/features/artikel/data/artikel_model.dart
class ArtikelModel {
  final int id;
  final String judul;
  final String deskripsi;
  final String penulis;
  final String? thumbnail;
  final DateTime tanggal;
  final DateTime createdAt;
  final DateTime updatedAt;

  ArtikelModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.penulis,
    this.thumbnail,
    required this.tanggal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ArtikelModel.fromJson(Map<String, dynamic> json) {
    return ArtikelModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      penulis: json['penulis'],
      thumbnail: json['thumbnail'],
      tanggal: DateTime.parse(json['tanggal']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'penulis': penulis,
      'thumbnail': thumbnail,
      'tanggal': tanggal.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper to format the date
  String get formattedDate {
    return '${tanggal.day} ${_getMonthName(tanggal.month)} ${tanggal.year}';
  }

  // Helper method to get month name
  String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }
}