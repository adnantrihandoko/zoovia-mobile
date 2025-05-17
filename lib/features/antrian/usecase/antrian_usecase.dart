// lib/features/antrian/usecase/antrian_usecase.dart
import 'package:puskeswan_app/features/antrian/data/antrian_model.dart';
import 'package:puskeswan_app/features/antrian/data/antrian_remote_datasource.dart';
import 'package:puskeswan_app/core/errors/failures.dart';

class AntrianUseCase {
  final AntrianRemoteDatasource _remoteDatasource;

  AntrianUseCase(this._remoteDatasource);
  // Fungsi untuk memeriksa apakah pengguna sudah memiliki antrian
  Future<bool> isAntrianAlreadyExists(int userId, String token) async {
    try {
      final antrianListMenunggu = await _remoteDatasource
          .getAntriansByUserId(userId, token, status: 'menunggu');
      final antrianListDiproses = await _remoteDatasource
          .getAntriansByUserId(userId, token, status: 'diproses');
      final result =
          antrianListMenunggu.isNotEmpty && antrianListDiproses.isNotEmpty || antrianListMenunggu.isNotEmpty && antrianListDiproses.isEmpty || antrianListMenunggu.isEmpty && antrianListDiproses.isNotEmpty;
      print("Hasil isAntrianAlreadyExist di antrian_usecase: $result");
      return result;
    } catch (e) {
      throw Exception('Error checking antrian: $e');
    }
  }

  // Mendapatkan semua antrian
  Future<List<AntrianModel>> getAllAntrian(String token,
      {String? status}) async {
    try {
      return await _remoteDatasource.getAntrians(token, status: status);
    } catch (e) {
      throw BusinessException('Gagal mengambil data antrian: ${e.toString()}');
    }
  }

  // Mendapatkan antrian berdasarkan user ID
  Future<List<AntrianModel>> getAntrianByUserId(int userId, String token,
      {String? status}) async {
    try {
      if (userId <= 0) {
        throw BusinessException('ID pengguna tidak valid');
      }
      return await _remoteDatasource.getAntriansByUserId(userId, token,
          status: status);
    } catch (e) {
      if (e is BusinessException) {
        rethrow;
      }
      throw BusinessException(
          'Gagal mengambil data antrian user: ${e.toString()}');
    }
  }

  // antrian_usecase.dart - tambahkan metode baru
  Future<QueueSummary> getQueueSummary(String token) async {
    try {
      return await _remoteDatasource.getQueueSummary(token);
    } catch (e) {
      if (e is BusinessException) {
        rethrow;
      }
      throw BusinessException(
          'Gagal mengambil ringkasan antrian: ${e.toString()}');
    }
  }

// Metode untuk mendapatkan antrian milik user yang sedang aktif (menunggu atau diproses)
  Future<AntrianModel?> getUserActiveQueue(int userId, String token) async {
    try {
      final antrianList = await _remoteDatasource.getAntriansByUserId(
          userId, token,
          status: 'menunggu,diproses' // Menggunakan format yang didukung API
          );

      if (antrianList.isEmpty) {
        return null;
      }

      // Prioritaskan yang sedang diproses, jika tidak ada pilih yang menunggu
      final diproses =
          antrianList.where((a) => a.status == 'diproses').toList();
      if (diproses.isNotEmpty) {
        return diproses.first;
      }

      return antrianList.first;
    } catch (e) {
      if (e is BusinessException) {
        rethrow;
      }
      throw BusinessException(
          'Gagal mengambil antrian aktif user: ${e.toString()}');
    }
  }

  // Membuat antrian baru
  Future<AntrianModel> createAntrian({
    required String token,
    required String nama,
    required String keluhan,
    required int idLayanan,
    required int idUser,
    required int idHewan,
  }) async {
    try {
      // Validasi data
      if (nama.trim().isEmpty) {
        throw BusinessException('Nama tidak boleh kosong');
      }

      if (keluhan.trim().isEmpty) {
        throw BusinessException('Keluhan tidak boleh kosong');
      }

      if (idLayanan <= 0) {
        throw BusinessException('Layanan tidak valid');
      }

      if (idHewan <= 0) {
        throw BusinessException('Hewan tidak valid');
      }

      // Proses data
      final data = {
        'nama': nama.trim(),
        'keluhan': keluhan.trim(),
        'id_layanan': idLayanan,
        'id_user': idUser,
        'id_hewan': idHewan,
        'status': 'menunggu', // Default status
      };

      return await _remoteDatasource.createAntrian(data, token);
    } catch (e) {
      if (e is BusinessException) {
        rethrow;
      }
      throw BusinessException('Gagal membuat antrian: ${e.toString()}');
    }
  }

  // Mengupdate antrian
  Future<AntrianModel> updateAntrian({
    required int id,
    required String token,
    String? nama,
    String? keluhan,
    int? idLayanan,
    int? idHewan,
    String? status,
  }) async {
    try {
      if (id <= 0) {
        throw BusinessException('ID antrian tidak valid');
      }

      final data = <String, dynamic>{};

      if (nama != null) {
        if (nama.trim().isEmpty) {
          throw BusinessException('Nama tidak boleh kosong');
        }
        data['nama'] = nama.trim();
      }

      if (keluhan != null) {
        if (keluhan.trim().isEmpty) {
          throw BusinessException('Keluhan tidak boleh kosong');
        }
        data['keluhan'] = keluhan.trim();
      }

      if (idLayanan != null) {
        if (idLayanan <= 0) {
          throw BusinessException('Layanan tidak valid');
        }
        data['id_layanan'] = idLayanan;
      }

      if (idHewan != null) {
        if (idHewan <= 0) {
          throw BusinessException('Hewan tidak valid');
        }
        data['id_hewan'] = idHewan;
      }

      if (status != null) {
        if (!['menunggu', 'diproses', 'selesai'].contains(status)) {
          throw BusinessException('Status tidak valid');
        }
        data['status'] = status;
      }

      if (data.isEmpty) {
        throw BusinessException('Tidak ada data yang diubah');
      }

      return await _remoteDatasource.updateAntrian(id, data, token);
    } catch (e) {
      if (e is BusinessException) {
        rethrow;
      }
      throw BusinessException('Gagal mengupdate antrian: ${e.toString()}');
    }
  }

  // Mengubah status antrian
  Future<AntrianModel> updateAntrianStatus({
    required int id,
    required String status,
    required String token,
  }) async {
    try {
      if (id <= 0) {
        throw BusinessException('ID antrian tidak valid');
      }

      if (!['menunggu', 'diproses', 'selesai'].contains(status)) {
        throw BusinessException(
            'Status tidak valid. Gunakan: menunggu, diproses, atau selesai');
      }

      return await _remoteDatasource.updateAntrianStatus(id, status, token);
    } catch (e) {
      if (e is BusinessException) {
        rethrow;
      }
      throw BusinessException(
          'Gagal mengupdate status antrian: ${e.toString()}');
    }
  }

  // Menghapus antrian
  Future<bool> deleteAntrian(int id, String token) async {
    try {
      if (id <= 0) {
        throw BusinessException('ID antrian tidak valid');
      }

      return await _remoteDatasource.deleteAntrian(id, token);
    } catch (e) {
      if (e is BusinessException) {
        rethrow;
      }
      throw BusinessException('Gagal menghapus antrian: ${e.toString()}');
    }
  }
}
