class AntrianModel {
  final int id;
  final String nama;
  final String keluhan;
  final int idLayanan;
  final int idUser;
  final int idHewan;
  final String status;
  final int nomorAntrian;
  final DateTime tanggalAntrian;
  final String namaLayanan;
  final String namaHewan;
  final DateTime createdAt;

  AntrianModel({
    required this.id,
    required this.nama,
    required this.keluhan,
    required this.idLayanan,
    required this.idUser,
    required this.idHewan,
    required this.status,
    required this.nomorAntrian,
    required this.tanggalAntrian,
    required this.namaLayanan,
    required this.namaHewan,
    required this.createdAt,
  });

  factory AntrianModel.fromJson(Map<String, dynamic> json) {
    return AntrianModel(
      id: json['id'],
      nama: json['nama'],
      keluhan: json['keluhan'],
      idLayanan: json['id_layanan'],
      idUser: json['id_user'],
      idHewan: json['id_hewan'],
      status: json['status'],
      nomorAntrian: json['nomor_antrian'] ?? 0,
      tanggalAntrian: DateTime.parse(json['tanggal_antrian']),
      namaLayanan: json['layanan']?['nama_layanan'] ?? 'Tidak ada layanan',
      namaHewan: json['hewan']?['nama_hewan'] ?? 'Tidak ada hewan',
      createdAt: DateTime.parse(json['created_at']),
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
    };
  }
}

// Queue summary model
class QueueSummary {
  final int total;
  final int waiting;
  final int processing;
  final int completed;
  final int currentNumber;
  final int nextNumber;

  QueueSummary({
    required this.total,
    required this.waiting,
    required this.processing,
    required this.completed,
    required this.currentNumber,
    required this.nextNumber,
  });

  factory QueueSummary.fromJson(Map<String, dynamic> json) {
    return QueueSummary(
      total: json['total'] ?? 0,
      waiting: json['waiting'] ?? 0,
      processing: json['processing'] ?? 0,
      completed: json['completed'] ?? 0,
      currentNumber: json['current_number'],
      nextNumber: json['next_number'] ?? 0,
    );
  }
}
