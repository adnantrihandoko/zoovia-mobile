// lib/features/dokter/usecase/dokter_usecase.dart
import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/dokter/dokter_model.dart';
import 'package:puskeswan_app/features/dokter/dokter_remote_datasource.dart';

class DokterUseCase {
  final DokterRemoteDatasource _remoteDataSource;

  DokterUseCase(this._remoteDataSource);

  // Get all doctors
  Future<List<DokterModel>> getAllDokter(String token) async {
    try {
      return await _remoteDataSource.getAllDokter(token);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Get doctors by layanan ID
  Future<List<DokterModel>> getDokterByLayananId(int layananId, String token) async {
    try {
      return await _remoteDataSource.getDokterByLayananId(layananId, token);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Create new doctor
  Future<DokterModel> createDokter({
    required String namaDokter,
    required int idLayanan,
    dynamic fotoFile,
    required String token,
  }) async {
    try {
      // Validate doctor name
      if (namaDokter.trim().isEmpty) {
        throw ValidationFailure('Nama dokter tidak boleh kosong');
      }

      FormData? formData;
      
      // Process photo if provided
      if (fotoFile != null) {
        formData = FormData();
        formData.files.add(
          MapEntry(
            'foto_dokter',
            MultipartFile.fromFileSync(
              fotoFile.path,
              filename: fotoFile.path.split('/').last,
            ),
          ),
        );
      }

      return await _remoteDataSource.createDokter(
        namaDokter: namaDokter,
        idLayanan: idLayanan,
        fotoDokter: formData,
        token: token,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Update doctor
  Future<DokterModel> updateDokter({
    required int id,
    String? namaDokter,
    int? idLayanan,
    dynamic fotoFile,
    required String token,
  }) async {
    try {
      // Validate doctor name if provided
      if (namaDokter != null && namaDokter.trim().isEmpty) {
        throw ValidationFailure('Nama dokter tidak boleh kosong');
      }

      FormData? formData;
      
      // Process photo if provided
      if (fotoFile != null) {
        formData = FormData();
        formData.files.add(
          MapEntry(
            'foto_dokter',
            MultipartFile.fromFileSync(
              fotoFile.path,
              filename: fotoFile.path.split('/').last,
            ),
          ),
        );
      }

      return await _remoteDataSource.updateDokter(
        id: id,
        namaDokter: namaDokter,
        idLayanan: idLayanan,
        fotoDokter: formData,
        token: token,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Delete doctor
  Future<bool> deleteDokter(int id, String token) async {
    try {
      return await _remoteDataSource.deleteDokter(id, token);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling helper
  Exception _handleError(dynamic error) {
    if (error is ValidationFailure || error is ServerFailure || error is NetworkFailure) {
      return error;
    }
    return Exception('Terjadi kesalahan: ${error.toString()}');
  }
}