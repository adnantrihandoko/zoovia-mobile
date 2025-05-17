// lib/features/layanan/presentation/controllers/layanan_controller.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/features/dokter/dokter_model.dart';
import 'package:puskeswan_app/features/layanan/data/layanan_model.dart';
import 'package:puskeswan_app/features/layanan/usecase/layanan_usecase.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

enum LayananStatus { initial, loading, loaded, error }

class LayananProvider extends ChangeNotifier {
  final LayananUseCase _layananUseCase;
  final AppFlutterSecureStorage _secureStorage;

  LayananStatus _status = LayananStatus.initial;
  List<LayananModel> _layanan = [];
  List<DokterModel> _dokterList = [];
  String _errorMessage = '';

  // Getters
  LayananStatus get status => _status;
  List<LayananModel> get layanan => _layanan;
  List<DokterModel> get dokterList => _dokterList;
  String get errorMessage => _errorMessage;

  LayananProvider(
    this._layananUseCase,
    this._secureStorage,
  );

  // Load daftar layanan
  Future<void> loadLayanan() async {
    _status = LayananStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      _layanan = await _layananUseCase.getLayanan(token);
      print(_layanan.first.dokters?.length);
      _status = LayananStatus.loaded;
    } catch (e) {
      _status = LayananStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // Ambil detail layanan berdasarkan ID
  Future<LayananModel?> getLayananById(int id) async {
    try {
      final token = await _secureStorage.getData('token');
      final layanan = await _layananUseCase.getLayananById(id, token);
      return layanan;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    }
  }

  // Ambil daftar dokter berdasarkan ID layanan
  Future<void> getDokterByLayananId(int layananId) async {
    _status = LayananStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      _dokterList =
          await _layananUseCase.getDokterByLayananId(layananId, token);
      _status = LayananStatus.loaded;
    } catch (e) {
      _status = LayananStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // Reset state
  void reset() {
    _status = LayananStatus.initial;
    _layanan = [];
    _dokterList = [];
    _errorMessage = '';
    notifyListeners();
  }
}
