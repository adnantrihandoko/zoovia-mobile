// lib/features/rekam_medis/data/rekam_medis_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_model.dart';

class RekamMedisRemoteDatasource {
  final Dio _dio;

  RekamMedisRemoteDatasource(this._dio);

  // Get all medical records
  Future<List<RekamMedisModel>> getAllRekamMedis(String token) async {
    try {
      final response = await _dio.get(
        '/rekam-medis',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> rekamMedisList = data['data'];
          return rekamMedisList.map((json) => RekamMedisModel.fromJson(json)).toList();
        } else {
          throw ServerFailure(data['message'] ?? 'Gagal mengambil data rekam medis');
        }
      } else {
        throw ServerFailure('Gagal mengambil data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw NetworkFailure('Terjadi kesalahan jaringan: ${e.message}');
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: $e');
    }
  }

  // Get medical records by animal ID
  Future<List<RekamMedisModel>> getRekamMedisByHewanId(int hewanId, String token) async {
    try {
      final response = await _dio.get(
        '/rekam-medis/hewan/$hewanId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> rekamMedisList = data['data'];
          return rekamMedisList.map((json) => RekamMedisModel.fromJson(json)).toList();
        } else {
          throw ServerFailure(data['message'] ?? 'Gagal mengambil data rekam medis');
        }
      } else {
        throw ServerFailure('Gagal mengambil data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw NetworkFailure('Terjadi kesalahan jaringan: ${e.message}');
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: $e');
    }
  }

  // Get medical record by ID
  Future<RekamMedisModel> getRekamMedisById(int rekamMedisId, String token) async {
    try {
      final response = await _dio.get(
        '/rekam-medis/$rekamMedisId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return RekamMedisModel.fromJson(data['data']);
        } else {
          throw ServerFailure(data['message'] ?? 'Gagal mengambil data rekam medis');
        }
      } else {
        throw ServerFailure('Gagal mengambil data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw NetworkFailure('Terjadi kesalahan jaringan: ${e.message}');
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: $e');
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
      final response = await _dio.post(
        '/rekam-medis',
        data: {
          'id_hewan': idHewan,
          'id_dokter': idDokter,
          'deskripsi': deskripsi,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          return RekamMedisModel.fromJson(data['data']);
        } else {
          throw ServerFailure(data['message'] ?? 'Gagal membuat rekam medis');
        }
      } else {
        throw ServerFailure('Gagal membuat data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        // Validation errors
        final errors = e.response?.data['errors'];
        final messages = errors is Map ? errors.values.join(', ') : 'Validasi gagal';
        throw ServerFailure(messages);
      }
      throw NetworkFailure('Terjadi kesalahan jaringan: ${e.message}');
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: $e');
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
      final data = <String, dynamic>{};
      
      if (idHewan != null) data['id_hewan'] = idHewan;
      if (idDokter != null) data['id_dokter'] = idDokter;
      if (deskripsi != null) data['deskripsi'] = deskripsi;

      final response = await _dio.put(
        '/rekam-medis/$id',
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return RekamMedisModel.fromJson(responseData['data']);
        } else {
          throw ServerFailure(responseData['message'] ?? 'Gagal mengupdate rekam medis');
        }
      } else {
        throw ServerFailure('Gagal mengupdate data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        // Validation errors
        final errors = e.response?.data['errors'];
        final messages = errors is Map ? errors.values.join(', ') : 'Validasi gagal';
        throw ServerFailure(messages);
      }
      throw NetworkFailure('Terjadi kesalahan jaringan: ${e.message}');
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: $e');
    }
  }

  // Delete medical record
  Future<bool> deleteRekamMedis(int id, String token) async {
    try {
      final response = await _dio.delete(
        '/rekam-medis/$id',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['success'] == true;
      } else {
        throw ServerFailure('Gagal menghapus data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw NetworkFailure('Terjadi kesalahan jaringan: ${e.message}');
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: $e');
    }
  }
}