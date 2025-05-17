// lib/providers/hewan_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:puskeswan_app/features/hewanku/data/hewan_model.dart';
import 'package:puskeswan_app/features/hewanku/usecase/hewanku_usecase.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

enum HewanStatus { initial, loading, loaded, error }

class HewanProvider extends ChangeNotifier {
  final HewanUseCase _hewanUseCase;
  final AppFlutterSecureStorage _appFlutterSecureStorage;

  HewanStatus _status = HewanStatus.initial;
  List<Hewan> _hewanList = [];
  String _errorMessage = '';
  Hewan? _selectedHewan;

  HewanProvider(
    this._hewanUseCase,
    this._appFlutterSecureStorage,
  );

  // Getters
  HewanStatus get status => _status;
  List<Hewan> get hewanList => _hewanList;
  String get errorMessage => _errorMessage;
  Hewan? get selectedHewan => _selectedHewan;

  // Set hewan yang dipilih
  void setSelectedHewan(Hewan hewan) {
    _selectedHewan = hewan;
    notifyListeners();
  }

  // Mengambil daftar hewan berdasarkan user ID
  Future<bool> getHewanByUserId() async {
    final userId = await _appFlutterSecureStorage.getData('id');
    final token = await _appFlutterSecureStorage.getData('token');
    try {
      _status = HewanStatus.loading;
      notifyListeners();

      _hewanList =
          await _hewanUseCase.getHewanByUserId(int.parse(userId), token);
      if (_hewanList.isEmpty) {
        _status = HewanStatus.loaded;
        notifyListeners();
        return false;
      }

      _status = HewanStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _status = HewanStatus.error;
      _errorMessage = e.toString();
      return false;
    }
  }

  // Menambahkan hewan baru
  Future<bool> addHewan({
    required String namaHewan,
    required String jenisHewan,
    required String ras,
    required int umur,
    File? fotoHewan,
  }) async {
    final userId = await _appFlutterSecureStorage.getData('id');
    final token = await _appFlutterSecureStorage.getData('token');
    try {
      _status = HewanStatus.loading;
      notifyListeners();

      final newHewan = await _hewanUseCase.addHewan(
        idUser: int.parse(userId),
        token: token,
        namaHewan: namaHewan,
        jenisHewan: jenisHewan,
        ras: ras,
        umur: umur,
        fotoHewan: fotoHewan,
      );

      _hewanList.add(newHewan);
      _status = HewanStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _status = HewanStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update data hewan
  Future<bool> updateHewan({
    required int id,
    String? namaHewan,
    String? jenisHewan,
    String? ras,
    int? umur,
    File? fotoHewan,
  }) async {
    final token = await _appFlutterSecureStorage.getData('token');

    try {
      _status = HewanStatus.loading;
      notifyListeners();

      final updatedHewan = await _hewanUseCase.updateHewan(
        token: token,
        id: id,
        namaHewan: namaHewan,
        jenisHewan: jenisHewan,
        ras: ras,
        umur: umur,
        fotoHewan: fotoHewan,
      );

      // Update list item
      final index = _hewanList.indexWhere((hewan) => hewan.id == id);
      if (index != -1) {
        _hewanList[index] = updatedHewan;
      }

      // Update selected hewan jika yang diupdate adalah yang sedang dipilih
      if (_selectedHewan?.id == id) {
        _selectedHewan = updatedHewan;
      }

      _status = HewanStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _status = HewanStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Menghapus data hewan
  Future<bool> deleteHewan(int id) async {
    final token = await _appFlutterSecureStorage.getData('token');

    try {
      _status = HewanStatus.loading;
      notifyListeners();

      final success = await _hewanUseCase.deleteHewan(id, token);

      if (success) {
        _hewanList.removeWhere((hewan) => hewan.id == id);

        // Reset selected hewan jika yang dihapus adalah yang sedang dipilih
        if (_selectedHewan?.id == id) {
          _selectedHewan = null;
        }
      }

      _status = HewanStatus.loaded;
      notifyListeners();
      return success;
    } catch (e) {
      _status = HewanStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Reset state
  void reset() {
    _status = HewanStatus.initial;
    _hewanList = [];
    _errorMessage = '';
    _selectedHewan = null;
    notifyListeners();
  }
}
