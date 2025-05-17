// lib/features/layanan/data/layanan_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/dokter/dokter_model.dart';
import 'package:puskeswan_app/features/layanan/data/layanan_model.dart';

class LayananRemoteDatasource {
  final Dio _dio;

  LayananRemoteDatasource(this._dio);

  // Get all layanan
  Future<List<LayananModel>> getLayanans(String token) async {
    try {
      final response = await _dio.get('/layanans',
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        final data = response.data;
        print('API Response: $data'); // Untuk debugging

        if (data['success'] == true) {
          final List<dynamic> layananList = data['data'];
          return layananList
              .map((json) => LayananModel.fromJson(json))
              .toList();
        } else {
          throw ServerFailure(
              data['message'] ?? 'Gagal mengambil data layanan');
        }
      } else {
        throw ServerFailure('Gagal mengambil data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}, Response: ${e.response?.data}');
      throw NetworkFailure('Terjadi kesalahan jaringan: ${e.message}');
    } catch (e) {
      print('Error: $e');
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: $e');
    }
  }

  // Get layanan by ID
  Future<LayananModel> getLayananById(int id, String token) async {
    try {
      final response = await _dio.get('/layanan/$id',
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return LayananModel.fromJson(data['data']);
        } else {
          throw ServerFailure(
              data['message'] ?? 'Gagal mengambil data layanan');
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

  // Get dokter by layanan ID
  Future<List<DokterModel>> getDokterByLayananId(
      int layananId, String token) async {
    try {
      final response = await _dio.get('/dokter/layanan/$layananId',
          options: Options(headers: {"Authorization": "Bearer $token"}));

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
}
