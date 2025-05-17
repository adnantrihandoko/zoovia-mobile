// lib/features/artikel/data/artikel_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/artikel/artikel_model.dart';

class ArtikelRemoteDatasource {
  final Dio _dio;

  ArtikelRemoteDatasource(this._dio);

  // Get all articles
  Future<List<ArtikelModel>> getArtikels(String token) async {
    try {
      final response = await _dio.get(
        '/artikels',
        options: Options(headers: {"Authorization": "Bearer $token"})
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> artikelList = data['data'];
          return artikelList.map((json) => ArtikelModel.fromJson(json)).toList();
        } else {
          throw ServerFailure(data['message'] ?? 'Gagal mengambil data artikel');
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

  // Get article by ID
  Future<ArtikelModel> getArtikelById(int id, String token) async {
    try {
      final response = await _dio.get(
        '/artikel/$id',
        options: Options(headers: {"Authorization": "Bearer $token"})
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return ArtikelModel.fromJson(data['data']);
        } else {
          throw ServerFailure(data['message'] ?? 'Gagal mengambil detail artikel');
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