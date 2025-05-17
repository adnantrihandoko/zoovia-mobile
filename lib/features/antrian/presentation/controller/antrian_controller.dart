// lib/features/antrian/presentation/controller/antrian_controller.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:puskeswan_app/features/antrian/data/antrian_model.dart';
import 'package:puskeswan_app/features/antrian/usecase/antrian_usecase.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

enum AntrianStatus { initial, loading, loaded, error }

class AntrianProvider with ChangeNotifier {
  final AntrianUseCase _antrianUseCase;
  final AppFlutterSecureStorage _appFlutterSecureStorage;
  final PusherChannelsFlutter _pusherChannelsFlutter;

  QueueSummary? _queueSummary;
  AntrianModel? _userActiveQueue;
  int? _currentUserId;

  QueueSummary? get queueSummary => _queueSummary;
  AntrianModel? get userActiveQueue => _userActiveQueue;

  // Konstanta untuk channel dan event
  static const String _channelName = 'antrian';

  // Variabel state
  AntrianStatus _status = AntrianStatus.initial;
  List<AntrianModel> _antrians = [];
  String _errorMessage = '';
  bool _isConnected = false;

  // Getters
  List<AntrianModel> get antrians => _antrians;
  AntrianStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isConnected => _isConnected;

  AntrianProvider(
    this._antrianUseCase,
    this._appFlutterSecureStorage,
    this._pusherChannelsFlutter,
  );

  // Memulai koneksi dan inisialisasi data
  Future<void> initializeAntrianData() async {
    _status = AntrianStatus.loading;
    notifyListeners();

    try {
      await membuatKoneksi();
      await loadQueueSummary();
      await loadUserActiveQueue();
      await loadAntriansByUser();
      print('NGEPRINT ANTRIAN SUMMARY: $queueSummary');
      _status = AntrianStatus.loaded;
    } catch (e) {
      _status = AntrianStatus.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Menginisialisasi koneksi WebSocket dan subscribe ke channel antrian
  Future<void> membuatKoneksi() async {
    try {
      final idUser = await _appFlutterSecureStorage.getData('id');
      final idUserInt = int.parse(idUser);
      _currentUserId = idUserInt; // Simpan ID user saat ini
      
      await _pusherChannelsFlutter.init(
        apiKey: "e5c82108dec6c8942c45",
        cluster: "ap1",
        onConnectionStateChange: (koneksi, kode) {
          print("Koneksi saat ini: $koneksi $kode");
        },
      );

      await _pusherChannelsFlutter.subscribe(
        channelName: _channelName,
        onSubscriptionSucceeded: (subcsription) {
          print("Subscription sukses: $subcsription");
        },
        onEvent: (event) {
          _handlePusherEvent(event);
        },
      );
      
      await _pusherChannelsFlutter.connect();
      _isConnected = true;
      notifyListeners();
    } catch (e) {
      print("Error koneksi Pusher: $e");
      _isConnected = false;
      notifyListeners();
    }
  }

  // Method baru untuk menangani event Pusher
  void _handlePusherEvent(PusherEvent event) {
    try {
      final data = jsonDecode(event.data);
      final queueSummaryJson = data['queueSummary'];
      
      // Selalu update ringkasan antrian
      if (queueSummaryJson != null) {
        _queueSummary = QueueSummary.fromJson(queueSummaryJson);
      }

      // Hanya proses antrian jika ada data antrian
      if (data['antrian'] != null) {
        final antrianJson = data['antrian'];
        final antrianModel = AntrianModel.fromJson(antrianJson);
        final String action = data['action'] ?? '';
        
        // Hanya proses antrian milik user saat ini
        if (antrianModel.idUser == _currentUserId) {
          _processAntrianEvent(action, antrianModel);
        } else {
          // Jika bukan milik user saat ini, hanya update ringkasan queue
          // dan tidak perlu memperbarui daftar antrian
          print("Menerima event untuk antrian user lain: ${antrianModel.idUser}");
        }
      }
      
      // Notifikasi perubahan untuk memperbarui UI
      notifyListeners();
    } catch (e) {
      print("Terjadi error saat memproses event pusher: ${e.toString()}");
    }
  }

  // Method untuk memproses event antrian berdasarkan jenisnya
  void _processAntrianEvent(String action, AntrianModel antrianModel) {
    switch (action) {
      case 'create':
        _handleCreateEvent(antrianModel);
        break;
      case 'update':
      case 'update-status':
        _handleUpdateEvent(antrianModel);
        break;
      case 'delete':
        _handleDeleteEvent(antrianModel);
        break;
      default:
        print("Tipe event tidak dikenal: $action");
    }
  }

  // Handler untuk event pembuatan antrian baru
  void _handleCreateEvent(AntrianModel antrianModel) {
    // Periksa apakah antrian sudah ada dalam daftar
    final existingIndex = _antrians.indexWhere((a) => a.id == antrianModel.id);
    if (existingIndex == -1) {
      // Jika tidak ada, tambahkan ke daftar
      _antrians.add(antrianModel);
      _userActiveQueue = antrianModel; // Update antrian aktif user
      print("Antrian baru ditambahkan: ${antrianModel.id}");
    }
  }

  // Handler untuk event update antrian
  void _handleUpdateEvent(AntrianModel antrianModel) {
    // Cari antrian di daftar
    final existingIndex = _antrians.indexWhere((a) => a.id == antrianModel.id);
    if (existingIndex != -1) {
      // Jika ditemukan, update antrian dengan data baru
      _antrians[existingIndex] = antrianModel;
      // Jika ini adalah antrian aktif, update juga data antrian aktif
      if (_userActiveQueue != null && _userActiveQueue!.id == antrianModel.id) {
        _userActiveQueue = antrianModel;
      }
      print("Antrian diperbarui: ${antrianModel.id}, status: ${antrianModel.status}");
    } else {
      // Jika tidak ditemukan dalam daftar, mungkin ini adalah antrian baru
      // Untuk berjaga-jaga, tambahkan ke daftar
      _antrians.add(antrianModel);
      print("Antrian baru ditambahkan melalui update: ${antrianModel.id}");
    }
  }

  // Handler untuk event penghapusan antrian
  void _handleDeleteEvent(AntrianModel antrianModel) {
    // Hapus antrian dari daftar
    _antrians.removeWhere((a) => a.id == antrianModel.id);
    // Jika ini adalah antrian aktif, kosongkan antrian aktif
    if (_userActiveQueue != null && _userActiveQueue!.id == antrianModel.id) {
      _userActiveQueue = null;
    }
    print("Antrian dihapus: ${antrianModel.id}");
  }

  /// Load semua data antrian dari API
  Future<void> loadAntrians({String? status}) async {
    _status = AntrianStatus.loading;
    notifyListeners();

    try {
      final token = await _appFlutterSecureStorage.getData('token');
      final antrians =
          await _antrianUseCase.getAllAntrian(token, status: status);

      _antrians = antrians;
      _status = AntrianStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AntrianStatus.error;
      print("Error loading antrian: $e");
    }

    notifyListeners();
  }

  /// Load antrian berdasarkan user ID
  Future<void> loadAntriansByUser({String? status}) async {
    _status = AntrianStatus.loading;
    notifyListeners();

    try {
      final token = await _appFlutterSecureStorage.getData('token');
      final userId = await _appFlutterSecureStorage.getData('id');

      if (userId.isEmpty) {
        throw Exception('User ID tidak ditemukan');
      }

      _currentUserId = int.parse(userId); // Simpan ID user saat ini
      final antrians = await _antrianUseCase
          .getAntrianByUserId(_currentUserId!, token, status: status);

      _antrians = antrians;
      _status = AntrianStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AntrianStatus.error;
      print("Error loading antrian user: $e");
    }

    notifyListeners();
  }

  /// Clean up resource saat widget di-dispose
  void disconnectPusher() {
    try {
      _pusherChannelsFlutter.unsubscribe(channelName: _channelName);
      _pusherChannelsFlutter.disconnect();
    } catch (e) {
      print("Error menutup koneksi Pusher: $e");
    }
  }

  Future<bool> createAntrian(
      String nama, String keluhan, int idLyanan, int idHewan) async {
    final token = await _appFlutterSecureStorage.getData('token');
    final idUser = await _appFlutterSecureStorage.getData('id');
    final idUserInt = int.parse(idUser);
    _currentUserId = idUserInt; // Pastikan ID user saat ini diperbarui
    
    final isAlreadyExist =
        await _antrianUseCase.isAntrianAlreadyExists(idUserInt, token);
    try {
      if (isAlreadyExist) {
        _errorMessage = "Antrian hanya bisa dibuat satu kali";
        return false;
      }
      final antrian = await _antrianUseCase.createAntrian(
          token: token,
          nama: nama,
          keluhan: keluhan,
          idLayanan: idLyanan,
          idUser: idUserInt,
          idHewan: idHewan);
      return true;
    } catch (e) {
      print("Error di antrian_controller/createAntrian: ${e.toString()}");
      _errorMessage = e.toString();
      return false;
    }
  }

  // Muat ringkasan antrian
  Future<void> loadQueueSummary() async {
    try {
      final token = await _appFlutterSecureStorage.getData('token');
      _queueSummary = await _antrianUseCase.getQueueSummary(token);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      print("Error loading queue summary: $e");
    }
  }

  // Muat antrian aktif user
  Future<void> loadUserActiveQueue() async {
    try {
      final token = await _appFlutterSecureStorage.getData('token');
      final userId = await _appFlutterSecureStorage.getData('id');

      if (userId.isEmpty) {
        throw Exception('User ID tidak ditemukan');
      }

      _currentUserId = int.parse(userId); // Simpan ID user saat ini
      _userActiveQueue =
          await _antrianUseCase.getUserActiveQueue(_currentUserId!, token);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      print("Error loading user active queue: $e");
    }
  }
}