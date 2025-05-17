// lib/features/layanan/usecase/layanan_usecase.dart
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/dokter/dokter_model.dart';
import 'package:puskeswan_app/features/layanan/data/layanan_model.dart';
import 'package:puskeswan_app/features/layanan/data/layanan_remote_datasource.dart';

class LayananUseCase {
  final LayananRemoteDatasource _layananRemoteDatasource;

  LayananUseCase(this._layananRemoteDatasource);

  // Get all layanan
  Future<List<LayananModel>> getLayanan(String token) async {
    try {
      return await _layananRemoteDatasource.getLayanans(token);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Get layanan by ID
  Future<LayananModel> getLayananById(int id, String token) async {
    try {
      return await _layananRemoteDatasource.getLayananById(id, token);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Get dokter by layanan ID
  Future<List<DokterModel>> getDokterByLayananId(int layananId, String token) async {
    try {
      return await _layananRemoteDatasource.getDokterByLayananId(layananId, token);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: ${e.toString()}');
    }
  }
}