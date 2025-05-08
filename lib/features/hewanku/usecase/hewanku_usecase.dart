// lib/usecases/hewan_usecase.dart
import 'dart:io';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/hewanku/data/hewan_model.dart';
import 'package:puskeswan_app/features/hewanku/data/hewan_remote_datasource.dart';

class HewanUseCase {
  final HewanRemoteDatasource _hewanRemoteDatasource;

  // Konstanta untuk aturan bisnis
  static const int _maksimumPanjangNama = 15;
  static const int _maksimumUmur = 240; // 20 tahun dalam bulan

  HewanUseCase(this._hewanRemoteDatasource);

  /// Mendapatkan daftar hewan berdasarkan user ID
  ///
  /// [userId] ID pengguna pemilik hewan
  ///
  /// Mengembalikan List<Hewan> jika berhasil
  /// Mengembalikan exception jika terjadi kesalahan
  Future<List<Hewan>> getHewanByUserId(int userId, String token) async {
    try {
      return await _hewanRemoteDatasource.getHewanByUserId(userId, token);
    } catch (e) {
      throw BusinessException('Gagal mengambil data hewan: ${e.toString()}');
    }
  }

  /// Menambahkan data hewan baru
  ///
  /// [idUser] ID pengguna pemilik hewan
  /// [namaHewan] Nama hewan (maks 15 karakter)
  /// [jenisHewan] Jenis hewan (misal: Kucing, Anjing)
  /// [ras] Ras hewan
  /// [umur] Umur hewan dalam bulan
  /// [fotoHewan] File foto hewan (opsional)
  ///
  /// Mengembalikan objek Hewan jika berhasil
  /// Mengembalikan BusinessException jika terjadi kesalahan validasi
  Future<Hewan> addHewan({
    required String token,
    required int idUser,
    required String namaHewan,
    required String jenisHewan,
    required String ras,
    required int umur,
    File? fotoHewan,
  }) async {
    try {
      // Validasi aturan bisnis
      _validateHewanName(namaHewan);
      _validateHewanUmur(umur);

      // Format data sesuai aturan bisnis
      final formattedName = _capitalizeHewanName(namaHewan);

      final data = {
        'id_user': idUser,
        'nama_hewan': formattedName,
        'jenis_hewan': jenisHewan,
        'ras': ras,
        'umur': umur,
      };

      return await _hewanRemoteDatasource.addHewan(data, fotoHewan, token);
    } catch (e) {
      if (e is BusinessException) {
        print("ini deksekusi");
        rethrow;
      }
      throw BusinessException('Gagal menambahkan hewan: ${e.toString()}');
    }
  }

  /// Mengupdate data hewan yang sudah ada
  ///
  /// [id] ID hewan yang akan diupdate
  /// [namaHewan] Nama hewan baru (opsional)
  /// [jenisHewan] Jenis hewan baru (opsional)
  /// [ras] Ras hewan baru (opsional)
  /// [umur] Umur hewan dalam bulan (opsional)
  /// [fotoHewan] File foto hewan baru (opsional)
  ///
  /// Mengembalikan objek Hewan yang telah diupdate jika berhasil
  /// Mengembalikan BusinessException jika terjadi kesalahan validasi
  Future<Hewan> updateHewan({
    required int id,
    required String token,
    String? namaHewan,
    String? jenisHewan,
    String? ras,
    int? umur,
    File? fotoHewan,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (namaHewan != null) {
        _validateHewanName(namaHewan);
        data['nama_hewan'] = _capitalizeHewanName(namaHewan);
      }

      if (jenisHewan != null) {
        data['jenis_hewan'] = jenisHewan;
      }

      if (ras != null) {
        data['ras'] = ras;
      }

      if (umur != null) {
        _validateHewanUmur(umur);
        data['umur'] = umur;
      }

      // Jika tidak ada perubahan data dan tidak ada foto baru
      if (data.isEmpty && fotoHewan == null) {
        throw BusinessException('Tidak ada data yang diubah');
      }

      return await _hewanRemoteDatasource.updateHewan(
          id, data, fotoHewan, token);
    } catch (e) {
      if (e is BusinessException) {
        rethrow;
      }
      throw BusinessException('Gagal mengupdate hewan: ${e.toString()}');
    }
  }

  /// Menghapus data hewan
  ///
  /// [id] ID hewan yang akan dihapus
  ///
  /// Mengembalikan true jika berhasil dihapus
  /// Mengembalikan BusinessException jika terjadi kesalahan
  Future<bool> deleteHewan(int id, String token) async {
    try {
      return await _hewanRemoteDatasource.deleteHewan(id, token);
    } catch (e) {
      throw BusinessException('Gagal menghapus hewan: ${e.toString()}');
    }
  }

  // ----------------------
  // PRIVATE METHODS
  // ----------------------

  /// Memvalidasi nama hewan sesuai aturan bisnis
  /// Nama tidak boleh kosong dan tidak lebih dari 15 karakter
  void _validateHewanName(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      throw BusinessException('Nama hewan tidak boleh kosong');
    }

    if (trimmedName.length > _maksimumPanjangNama) {
      throw BusinessException(
          'Nama hewan tidak boleh lebih dari $_maksimumPanjangNama karakter');
    }
  }

  /// Memvalidasi umur hewan (dalam bulan)
  /// Umur harus positif dan tidak lebih dari batas maksimum
  void _validateHewanUmur(int umurBulan) {
    if (umurBulan < 0) {
      throw BusinessException('Umur hewan tidak boleh negatif');
    }

    if (umurBulan > _maksimumUmur) {
      throw BusinessException(
          'Umur hewan tidak valid (maksimal $_maksimumUmur bulan)');
    }
  }

  /// Mengubah nama hewan menjadi format Capital Case
  /// Contoh: "milo" menjadi "Milo", "kucing hitam" menjadi "Kucing Hitam"
  String _capitalizeHewanName(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return '';
    }

    return trimmedName
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }
}
