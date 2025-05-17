// lib/features/artikel/presentation/controller/artikel_controller.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/features/artikel/artikel_model.dart';
import 'package:puskeswan_app/features/artikel/artikel_usecase.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

enum ArtikelStatus { initial, loading, loaded, error }

class ArtikelProvider extends ChangeNotifier {
  final ArtikelUsecase _artikelUsecase;
  final AppFlutterSecureStorage _secureStorage;
  
  ArtikelStatus _status = ArtikelStatus.initial;
  List<ArtikelModel> _artikels = [];
  ArtikelModel? _selectedArtikel;
  String _errorMessage = '';
  
  ArtikelProvider(this._artikelUsecase, this._secureStorage);
  
  // Getters
  ArtikelStatus get status => _status;
  List<ArtikelModel> get artikels => _artikels;
  ArtikelModel? get selectedArtikel => _selectedArtikel;
  String get errorMessage => _errorMessage;
  
  // Load all articles
  Future<void> loadArtikels() async {
    _status = ArtikelStatus.loading;
    notifyListeners();
    
    try {
      final token = await _secureStorage.getData('token');
      _artikels = await _artikelUsecase.getAllArtikels(token);
      _status = ArtikelStatus.loaded;
    } catch (e) {
      _status = ArtikelStatus.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  // Load article detail by ID
  Future<void> loadArtikelDetail(int id) async {
    _status = ArtikelStatus.loading;
    notifyListeners();
    
    try {
      final token = await _secureStorage.getData('token');
      _selectedArtikel = await _artikelUsecase.getArtikelById(id, token);
      _status = ArtikelStatus.loaded;
    } catch (e) {
      _status = ArtikelStatus.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  // Clear selected article
  void clearSelectedArtikel() {
    _selectedArtikel = null;
    notifyListeners();
  }
  
  // Reset state
  void reset() {
    _status = ArtikelStatus.initial;
    _artikels = [];
    _selectedArtikel = null;
    _errorMessage = '';
    notifyListeners();
  }
}