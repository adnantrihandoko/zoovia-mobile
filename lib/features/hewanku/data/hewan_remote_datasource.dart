import 'dart:io';

import 'package:dio/dio.dart';
import 'package:puskeswan_app/features/hewanku/data/hewan_model.dart';

class HewanRemoteDatasource {
  final Dio _dio;

  HewanRemoteDatasource(
    this._dio,
  );

  // Mendapatkan daftar hewan berdasarkan user ID
  Future<List<Hewan>> getHewanByUserId(int userId, String token) async {
    try {
      final response = await _dio.get('/hewan/user/$userId', options: Options(headers: {"Authorization":"Bearer $token"}));
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> hewanList = data['data'];
          return hewanList.map((json) => Hewan.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Gagal mengambil data hewan');
        }
      } else {
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Terjadi kesalahan jaringan: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Menambahkan hewan baru
  Future<Hewan> addHewan(Map<String, dynamic> data, File? imageFile, String token) async {
    try {
      FormData formData;
      if (imageFile != null) {
        formData = FormData.fromMap({
          ...data,
          'foto_hewan': await MultipartFile.fromFile(
            imageFile.path,
            filename: 'foto_hewan.jpg',
          ),
        });
      } else {
        formData = FormData.fromMap(data);
      }

      final response = await _dio.post(
        '/hewan/create',
        data: formData,
        options: Options(headers: {"Authorization":"Bearer $token"})
      );

      if (response.statusCode == 201) {
        final data = response.data;
        if (data['status'] == 'success') {
          return Hewan.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Gagal menambahkan hewan');
        }
      } else {
        throw Exception('Gagal menambahkan data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Edit data hewan
  Future<Hewan> updateHewan(
      int id, Map<String, dynamic> data, File? imageFile, String token) async {
    try {
      FormData formData;

      if (imageFile != null) {
        formData = FormData.fromMap({
          ...data,
          'foto_hewan': await MultipartFile.fromFile(
            imageFile.path,
            filename: 'foto_hewan.jpg',
          ),
        });
      } else {
        formData = FormData.fromMap(data);
      }

      final response = await _dio.post(
        '/hewan/$id',
        data: formData,
        options: Options(headers: {"Authorization":"Bearer $token"})
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 'success') {
          return Hewan.fromJson(responseData['data']);
        } else {
          throw Exception(responseData['message'] ?? 'Gagal mengupdate hewan');
        }
      } else {
        throw Exception('Gagal mengupdate data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Menghapus data hewan
  Future<bool> deleteHewan(int id, String token) async {
    try {
      final response = await _dio.delete('/hewan/$id', options: Options(headers: {"Authorization":"Bearer $token"}));

      if (response.statusCode == 200) {
        final data = response.data;
        return data['success'] == true;
      } else {
        throw Exception('Gagal menghapus data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
