// lib/features/layanan/usecase/layanan_usecase.dart
import 'package:puskeswan_app/features/layanan/data/layanan_model.dart';
import 'package:puskeswan_app/features/layanan/data/layanan_remote_datasource.dart';
import 'package:puskeswan_app/core/errors/failures.dart';

class LayananUseCase {
  final LayananRemoteDatasource _remoteDatasource;

  LayananUseCase(this._remoteDatasource);

  // Mendapatkan semua layanan
  Future<List<LayananModel>> getAllLayanan(String token) async {
    try {
      return await _remoteDatasource.getLayanans(token);
    } catch (e) {
      throw BusinessException('Gagal mengambil data layanan: ${e.toString()}');
    }
  }
}