// lib/features/artikel/usecase/artikel_usecase.dart
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/artikel/artikel_model.dart';
import 'package:puskeswan_app/features/artikel/artikel_remote_datasource.dart';

class ArtikelUsecase {
  final ArtikelRemoteDatasource _artikelRemoteDatasource;
  
  ArtikelUsecase(this._artikelRemoteDatasource);
  
  // Get all articles
  Future<List<ArtikelModel>> getAllArtikels(String token) async {
    try {
      final artikels = await _artikelRemoteDatasource.getArtikels(token);
      
      // Sort by date (newest first)
      artikels.sort((a, b) => b.tanggal.compareTo(a.tanggal));
      
      return artikels;
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: $e');
    }
  }
  
  // Get article detail by ID
  Future<ArtikelModel> getArtikelById(int id, String token) async {
    try {
      return await _artikelRemoteDatasource.getArtikelById(id, token);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: $e');
    }
  }
}