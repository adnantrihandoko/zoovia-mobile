// lib/features/dokter/presentation/controller/dokter_controller.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/features/dokter/dokter_model.dart';
import 'package:puskeswan_app/features/dokter/dokter_usecase.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

enum DokterStatus { initial, loading, loaded, error }

class DokterProvider extends ChangeNotifier {
  final DokterUseCase _dokterUseCase;
  final AppFlutterSecureStorage _secureStorage;

  DokterStatus _status = DokterStatus.initial;
  List<DokterModel> _dokterList = [];
  String _errorMessage = '';
  DokterModel? _selectedDokter;

  DokterProvider(
    this._dokterUseCase,
    this._secureStorage,
  );

  // Getters
  DokterStatus get status => _status;
  List<DokterModel> get dokterList => _dokterList;
  String get errorMessage => _errorMessage;
  DokterModel? get selectedDokter => _selectedDokter;

  // Get all doctors
  Future<void> getAllDokter() async {
    _status = DokterStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      _dokterList = await _dokterUseCase.getAllDokter(token);
      _status = DokterStatus.loaded;
    } catch (e) {
      _status = DokterStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // Get doctors by layanan ID
  Future<void> getDokterByLayananId(int layananId) async {
    _status = DokterStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      _dokterList = await _dokterUseCase.getDokterByLayananId(layananId, token);
      _status = DokterStatus.loaded;
    } catch (e) {
      _status = DokterStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // Create new doctor
  Future<bool> createDokter({
    required String namaDokter,
    required int idLayanan,
    dynamic fotoFile,
  }) async {
    _status = DokterStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      final dokter = await _dokterUseCase.createDokter(
        namaDokter: namaDokter,
        idLayanan: idLayanan,
        fotoFile: fotoFile,
        token: token,
      );

      _dokterList.add(dokter);
      _status = DokterStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _status = DokterStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update doctor
  Future<bool> updateDokter({
    required int id,
    String? namaDokter,
    int? idLayanan,
    dynamic fotoFile,
  }) async {
    _status = DokterStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      final updatedDokter = await _dokterUseCase.updateDokter(
        id: id,
        namaDokter: namaDokter,
        idLayanan: idLayanan,
        fotoFile: fotoFile,
        token: token,
      );

      // Update list
      final index = _dokterList.indexWhere((dokter) => dokter.id == id);
      if (index != -1) {
        _dokterList[index] = updatedDokter;
      }

      // Update selected doctor if it's the same
      if (_selectedDokter?.id == id) {
        _selectedDokter = updatedDokter;
      }

      _status = DokterStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _status = DokterStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete doctor
  Future<bool> deleteDokter(int id) async {
    _status = DokterStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      final success = await _dokterUseCase.deleteDokter(id, token);

      if (success) {
        _dokterList.removeWhere((dokter) => dokter.id == id);

        if (_selectedDokter?.id == id) {
          _selectedDokter = null;
        }
      }

      _status = DokterStatus.loaded;
      notifyListeners();
      return success;
    } catch (e) {
      _status = DokterStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Set selected doctor
  void setSelectedDokter(DokterModel dokter) {
    _selectedDokter = dokter;
    notifyListeners();
  }

  // Reset state
  void reset() {
    _status = DokterStatus.initial;
    _dokterList = [];
    _errorMessage = '';
    _selectedDokter = null;
    notifyListeners();
  }
}