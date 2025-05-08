// lib/features/layanan/data/layanan_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/layanan/data/layanan_model.dart';

class LayananRemoteDatasource {
  final Dio _dio;

  LayananRemoteDatasource(this._dio);

  // Mendapatkan semua layanan
  Future<List<LayananModel>> getLayanans(String token) async {
    try {
      final response = await _dio.get(
        '/layanans',
        options: Options(headers: {"Authorization": "Bearer $token"})
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> layananList = data['data'];
          return layananList.map((json) => LayananModel.fromJson(json)).toList();
        } else {
          throw ServerFailure(data['message'] ?? 'Gagal mengambil data layanan');
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