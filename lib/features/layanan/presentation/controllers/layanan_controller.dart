// lib/features/layanan/presentation/controller/layanan_controller.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/features/layanan/data/layanan_model.dart';
import 'package:puskeswan_app/features/layanan/usecase/layanan_usecase.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

enum LayananStatus { initial, loading, loaded, error }

class LayananProvider with ChangeNotifier {
  final LayananUseCase _layananUseCase;
  final AppFlutterSecureStorage _secureStorage;
  
  LayananStatus _status = LayananStatus.initial;
  List<LayananModel> _layanan = [];
  String _errorMessage = '';
  
  // Getters
  List<LayananModel> get layanan => _layanan;
  LayananStatus get status => _status;
  String get errorMessage => _errorMessage;

  LayananProvider(this._layananUseCase, this._secureStorage);

  // Ambil daftar layanan
  Future<void> loadLayanan() async {
    _status = LayananStatus.loading;
    notifyListeners();

    try {
      final token = await _secureStorage.getData('token');
      final layanan = await _layananUseCase.getAllLayanan(token);
      
      _layanan = layanan;
      _status = LayananStatus.loaded;
    } catch (e) {
      _status = LayananStatus.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
}