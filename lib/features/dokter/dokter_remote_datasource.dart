// lib/features/dokter/data/dokter_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/dokter/dokter_model.dart';

class DokterRemoteDatasource {
  final Dio _dio;

  DokterRemoteDatasource(this._dio);

  // Get all doctors
  Future<List<DokterModel>> getAllDokter(String token) async {
    try {
      final response = await _dio.get(
        '/dokters',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> dokterList = data['data'];
          return dokterList.map((json) => DokterModel.fromJson(json)).toList();
        } else {
          throw ServerFailure(data['message'] ?? 'Gagal mengambil data dokter');
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

  // Get doctors by layanan ID
  Future<List<DokterModel>> getDokterByLayananId(int layananId, String token) async {
    try {
      final response = await _dio.get(
        '/dokter/layanan/$layananId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> dokterList = data['data'];
          return dokterList.map((json) => DokterModel.fromJson(json)).toList();
        } else {
          throw ServerFailure(data['message'] ?? 'Gagal mengambil data dokter');
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

  // Create new doctor
  Future<DokterModel> createDokter({
    required String namaDokter,
    required int idLayanan,
    FormData? fotoDokter,
    required String token,
  }) async {
    try {
      final formData = FormData.fromMap({
        'nama_dokter': namaDokter,
        'id_layanan': idLayanan,
        if (fotoDokter != null) 'foto_dokter': fotoDokter,
      });

      final response = await _dio.post(
        '/dokter/create',
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          return DokterModel.fromJson(data['data']);
        } else {
          throw ServerFailure(data['message'] ?? 'Gagal membuat dokter');
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

  // Update doctor
  Future<DokterModel> updateDokter({
    required int id,
    String? namaDokter,
    int? idLayanan,
    FormData? fotoDokter,
    required String token,
  }) async {
    try {
      final formData = FormData();
      
      if (namaDokter != null) formData.fields.add(MapEntry('nama_dokter', namaDokter));
      if (idLayanan != null) formData.fields.add(MapEntry('id_layanan', idLayanan.toString()));
      if (fotoDokter != null) formData.files.addAll(fotoDokter.files);

      final response = await _dio.post(
        '/dokter/$id',
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return DokterModel.fromJson(responseData['data']);
        } else {
          throw ServerFailure(responseData['message'] ?? 'Gagal mengupdate dokter');
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

  // Delete doctor
  Future<bool> deleteDokter(int id, String token) async {
    try {
      final response = await _dio.delete(
        '/dokter/$id',
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