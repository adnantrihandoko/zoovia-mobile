// lib/features/rekam_medis/usecase/rekam_medis_usecase.dart
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_datasource.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_model.dart';

class RekamMedisUseCase {
  final RekamMedisRemoteDatasource _remoteDataSource;

  RekamMedisUseCase(this._remoteDataSource);

  // Get all medical records
  Future<List<RekamMedisModel>> getAllRekamMedis(String token) async {
    try {
      return await _remoteDataSource.getAllRekamMedis(token);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Get medical records by animal ID
  Future<List<RekamMedisModel>> getRekamMedisByHewanId(int hewanId, String token) async {
    try {
      return await _remoteDataSource.getRekamMedisByHewanId(hewanId, token);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Get medical record by ID
  Future<RekamMedisModel> getRekamMedisById(int rekamMedisId, String token) async {
    try {
      return await _remoteDataSource.getRekamMedisById(rekamMedisId, token);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Create new medical record
  Future<RekamMedisModel> createRekamMedis({
    required int idHewan,
    required int idDokter,
    required String deskripsi,
    required String token,
  }) async {
    try {
      // Validate description length
      if (deskripsi.trim().isEmpty) {
        throw BusinessException('Deskripsi tidak boleh kosong');
      }

      if (deskripsi.length > 1000) {
        throw BusinessException('Deskripsi terlalu panjang (maksimal 1000 karakter)');
      }

      return await _remoteDataSource.createRekamMedis(
        idHewan: idHewan,
        idDokter: idDokter,
        deskripsi: deskripsi,
        token: token,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Update medical record
  Future<RekamMedisModel> updateRekamMedis({
    required int id,
    int? idHewan,
    int? idDokter,
    String? deskripsi,
    required String token,
  }) async {
    try {
      // Validate description length if provided
      if (deskripsi != null) {
        if (deskripsi.trim().isEmpty) {
          throw BusinessException('Deskripsi tidak boleh kosong');
        }

        if (deskripsi.length > 1000) {
          throw BusinessException('Deskripsi terlalu panjang (maksimal 1000 karakter)');
        }
      }

      return await _remoteDataSource.updateRekamMedis(
        id: id,
        idHewan: idHewan,
        idDokter: idDokter,
        deskripsi: deskripsi,
        token: token,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Delete medical record
  Future<bool> deleteRekamMedis(int id, String token) async {
    try {
      return await _remoteDataSource.deleteRekamMedis(id, token);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling helper
  Exception _handleError(dynamic error) {
    if (error is BusinessException || error is ServerFailure || error is NetworkFailure) {
      return error;
    }
    return BusinessException('Terjadi kesalahan: ${error.toString()}');
  }
}

// Custom exception for business logic errors
class BusinessException implements Exception {
  final String message;
  
  BusinessException(this.message);
  
  @override
  String toString() => message;
}