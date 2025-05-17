// lib/features/rekam_medis/presentation/controller/rekam_medis_controller.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_model.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_usecase.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

enum RekamMedisStatus { initial, loading, loaded, error }

class RekamMedisProvider extends ChangeNotifier {
  final RekamMedisUseCase _rekamMedisUseCase;
  final AppFlutterSecureStorage _secureStorage;

  RekamMedisStatus _status = RekamMedisStatus.initial;
  List<RekamMedisModel> _rekamMedisList = [];
  String _errorMessage = '';
  RekamMedisModel? _selectedRekamMedis;

  RekamMedisProvider(
    this._rekamMedisUseCase,
    this._secureStorage,
  );

  // Getters
  RekamMedisStatus get status => _status;
  List<RekamMedisModel> get rekamMedisList => _rekamMedisList;
  String get errorMessage => _errorMessage;
  RekamMedisModel? get selectedRekamMedis => _selectedRekamMedis;

  // Get all medical records
  Future<void> getAllRekamMedis() async {
    _status = RekamMedisStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      _rekamMedisList = await _rekamMedisUseCase.getAllRekamMedis(token);
      _status = RekamMedisStatus.loaded;
    } catch (e) {
      _status = RekamMedisStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // Get medical records by animal ID
  Future<void> getRekamMedisByHewanId(int hewanId) async {
    _status = RekamMedisStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      _rekamMedisList = await _rekamMedisUseCase.getRekamMedisByHewanId(hewanId, token);
      _status = RekamMedisStatus.loaded;
    } catch (e) {
      _status = RekamMedisStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // Get medical record by ID
  Future<void> getRekamMedisById(int rekamMedisId) async {
    _status = RekamMedisStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      _selectedRekamMedis = await _rekamMedisUseCase.getRekamMedisById(rekamMedisId, token);
      _status = RekamMedisStatus.loaded;
    } catch (e) {
      _status = RekamMedisStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // Create new medical record
  Future<bool> createRekamMedis({
    required int idHewan,
    required int idDokter,
    required String deskripsi,
  }) async {
    _status = RekamMedisStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      final rekamMedis = await _rekamMedisUseCase.createRekamMedis(
        idHewan: idHewan,
        idDokter: idDokter,
        deskripsi: deskripsi,
        token: token,
      );

      _rekamMedisList.add(rekamMedis);
      _status = RekamMedisStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _status = RekamMedisStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update medical record
  Future<bool> updateRekamMedis({
    required int id,
    int? idHewan,
    int? idDokter,
    String? deskripsi,
  }) async {
    _status = RekamMedisStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      final updatedRekamMedis = await _rekamMedisUseCase.updateRekamMedis(
        id: id,
        idHewan: idHewan,
        idDokter: idDokter,
        deskripsi: deskripsi,
        token: token,
      );

      // Update list
      final index = _rekamMedisList.indexWhere((record) => record.id == id);
      if (index != -1) {
        _rekamMedisList[index] = updatedRekamMedis;
      }

      // Update selected record if it's the same
      if (_selectedRekamMedis?.id == id) {
        _selectedRekamMedis = updatedRekamMedis;
      }

      _status = RekamMedisStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _status = RekamMedisStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete medical record
  Future<bool> deleteRekamMedis(int id) async {
    _status = RekamMedisStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      final success = await _rekamMedisUseCase.deleteRekamMedis(id, token);

      if (success) {
        _rekamMedisList.removeWhere((record) => record.id == id);

        if (_selectedRekamMedis?.id == id) {
          _selectedRekamMedis = null;
        }
      }

      _status = RekamMedisStatus.loaded;
      notifyListeners();
      return success;
    } catch (e) {
      _status = RekamMedisStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Reset state
  void reset() {
    _status = RekamMedisStatus.initial;
    _rekamMedisList = [];
    _errorMessage = '';
    _selectedRekamMedis = null;
    notifyListeners();
  }
}