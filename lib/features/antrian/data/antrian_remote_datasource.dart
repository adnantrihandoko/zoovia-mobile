// lib/features/antrian/data/antrian_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/antrian/data/antrian_model.dart';

class AntrianRemoteDatasource {
  final Dio _dio;

  AntrianRemoteDatasource(this._dio);

  // Mendapatkan daftar semua antrian
  Future<List<AntrianModel>> getAntrians(String token, {String? status}) async {
    try {
      String url = '/antrian';
      if (status != null) {
        url += '?status=$status';
      }

      final response = await _dio.get(url,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> antrianList = data['data'];
          return antrianList
              .map((json) => AntrianModel.fromJson(json))
              .toList();
        } else {
          throw ServerFailure(
              data['message'] ?? 'Gagal mengambil data antrian');
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

  // Mendapatkan daftar antrian berdasarkan user ID
  Future<List<AntrianModel>> getAntriansByUserId(int userId, String token,
      {String? status}) async {
    try {
      String url = '/antrian/user/$userId';
      if (status != null) {
        url += '?status=$status';
      }

      final response = await _dio.get(url,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> antrianList = data['data'];
          return antrianList
              .map((json) => AntrianModel.fromJson(json))
              .toList();
        } else {
          throw ServerFailure(
              data['message'] ?? 'Gagal mengambil data antrian user');
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

  // Membuat antrian baru
  Future<AntrianModel> createAntrian(
      Map<String, dynamic> data, String token) async {
    try {
      final response = await _dio.post('/antrian/create',
          data: data,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return AntrianModel.fromJson(responseData['data']);
        } else {
          throw ServerFailure(
              responseData['message'] ?? 'Gagal membuat antrian');
        }
      } else {
        throw ServerFailure('Gagal membuat antrian: ${response.statusCode}');
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

  // Mengupdate antrian
  Future<AntrianModel> updateAntrian(
      int id, Map<String, dynamic> data, String token) async {
    try {
      final response = await _dio.post('/antrian/$id',
          data: data,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return AntrianModel.fromJson(responseData['data']);
        } else {
          throw ServerFailure(
              responseData['message'] ?? 'Gagal mengupdate antrian');
        }
      } else {
        throw ServerFailure('Gagal mengupdate antrian: ${response.statusCode}');
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

  // Mengupdate status antrian
  Future<AntrianModel> updateAntrianStatus(
      int id, String status, String token) async {
    try {
      final response = await _dio.post('/antrian/$id/status',
          data: {'status': status},
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return AntrianModel.fromJson(responseData['data']);
        } else {
          throw ServerFailure(
              responseData['message'] ?? 'Gagal mengupdate status antrian');
        }
      } else {
        throw ServerFailure(
            'Gagal mengupdate status antrian: ${response.statusCode}');
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

  // antrian_remote_datasource.dart - tambahkan metode baru
  Future<QueueSummary> getQueueSummary(String token) async {
    try {
      final response = await _dio.get('/antrian/summary',
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return QueueSummary.fromJson(data['data']);
        } else {
          throw ServerFailure(
              data['message'] ?? 'Gagal mengambil ringkasan antrian');
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

  // Menghapus antrian
  Future<bool> deleteAntrian(int id, String token) async {
    try {
      final response = await _dio.delete('/antrian/$id',
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        final responseData = response.data;
        return responseData['success'] == true;
      } else {
        throw ServerFailure('Gagal menghapus antrian: ${response.statusCode}');
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
