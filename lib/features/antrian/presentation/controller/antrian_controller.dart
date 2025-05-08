// // lib/features/antrian/presentation/controller/antrian_controller.dart
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
// import 'package:puskeswan_app/features/antrian/data/antrian_model.dart';
// import 'package:puskeswan_app/features/antrian/usecase/antrian_usecase.dart';
// import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

// enum AntrianStatus { initial, loading, loaded, error }

// class AntrianProvider with ChangeNotifier {
//   final AntrianUseCase _antrianUseCase;
//   final AppFlutterSecureStorage _secureStorage;
//   final PusherChannelsFlutter _pusherChannelsFlutter;

//   // Konstanta untuk channel dan event
//   static const String _channelName = 'antrian';
//   static const String _createEventName = 'antrian.create';
//   static const String _updateEventName = 'antrian.update';
//   static const String _deleteEventName = 'antrian.delete';

//   // Variabel state
//   AntrianStatus _status = AntrianStatus.initial;
//   List<AntrianModel> _antrians = [];
//   String _errorMessage = '';
//   bool _isConnected = false;

//   // Getters
//   List<AntrianModel> get antrians => _antrians;
//   AntrianStatus get status => _status;
//   String get errorMessage => _errorMessage;
//   bool get isConnected => _isConnected;

//   AntrianProvider(
//     this._antrianUseCase,
//     this._secureStorage,
//     this._pusherChannelsFlutter,
//   );

//   /// Menginisialisasi koneksi WebSocket dan subscribe ke channel antrian
//   Future<void> membuatKoneksi() async {
//     try {
//       await _pusherChannelsFlutter.init(
//         apiKey: "e5c82108dec6c8942c45",
//         cluster: "ap1",
//         onConnectionStateChange: (koneksi, kode) {
//           print("Koneksi saat ini: $koneksi $kode");
//         },
//       );

//       await _pusherChannelsFlutter.subscribe(
//         channelName: _channelName,
//         onSubscriptionSucceeded: (subcsription) {
//           print("Subscription sukes? $subcsription");
//         },
//         onEvent: (event) {
//           print("Event ketrigger: $event Data: ${event.data}");
//         },
//       );
//       await _pusherChannelsFlutter.connect();
//       _isConnected = true;
//       notifyListeners();
//     } catch (e) {
//       print("Error koneksi Pusher: $e");
//       _isConnected = false;
//       notifyListeners();
//     }
//   }

//   /// Load semua data antrian dari API
//   Future<void> loadAntrians({String? status}) async {
//     _status = AntrianStatus.loading;
//     notifyListeners();

//     try {
//       final token = await _secureStorage.getData('token');
//       final antrians =
//           await _antrianUseCase.getAllAntrian(token, status: status);

//       _antrians = antrians;
//       _status = AntrianStatus.loaded;
//     } catch (e) {
//       _errorMessage = e.toString();
//       _status = AntrianStatus.error;
//       print("Error loading antrian: $e");
//     }

//     notifyListeners();
//   }

//   /// Load antrian berdasarkan user ID
//   Future<void> loadAntriansByUser({String? status}) async {
//     _status = AntrianStatus.loading;
//     notifyListeners();

//     try {
//       final token = await _secureStorage.getData('token');
//       final userId = await _secureStorage.getData('id');

//       if (userId.isEmpty) {
//         throw Exception('User ID tidak ditemukan');
//       }

//       final antrians = await _antrianUseCase
//           .getAntrianByUserId(int.parse(userId), token, status: status);

//       _antrians = antrians;
//       _status = AntrianStatus.loaded;
//     } catch (e) {
//       _errorMessage = e.toString();
//       _status = AntrianStatus.error;
//       print("Error loading antrian user: $e");
//     }

//     notifyListeners();
//   }

//   /// Clean up resource saat widget di-dispose
//   void disconnectPusher() {
//     try {
//       _pusherChannelsFlutter.unsubscribe(channelName: _channelName);
//       _pusherChannelsFlutter.disconnect();
//     } catch (e) {
//       print("Error menutup koneksi Pusher: $e");
//     }
//   }
// }

// lib/features/antrian/presentation/controller/antrian_controller.dart
import 'package:flutter/foundation.dart';
import 'package:puskeswan_app/features/antrian/data/antrian_model.dart';
import 'package:puskeswan_app/features/antrian/usecase/antrian_usecase.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';
import 'package:puskeswan_app/utils/pusher_service.dart';

enum AntrianStatus { initial, loading, loaded, error }

class AntrianProvider with ChangeNotifier {
  final AntrianUseCase _antrianUseCase;
  final AppFlutterSecureStorage _secureStorage;
  final PusherService _pusherService;

  // Konstanta untuk channel dan event - gunakan "my-channel" untuk menyesuaikan dengan konfigurasi server
  static const String _channelName = 'my-channel';
  // Satu nama event untuk menangani semua actions (create, update, delete)
  static const String _mainEventName = 'antrian.updated';

  // Variabel state
  AntrianStatus _status = AntrianStatus.initial;
  List<AntrianModel> _antrians = [];
  String _errorMessage = '';
  bool _isInitialized = false;

  // Getters
  List<AntrianModel> get antrians => _antrians;
  bool get isConnected => _pusherService.isConnected;
  AntrianStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  AntrianProvider(
    this._antrianUseCase, 
    this._secureStorage,
    this._pusherService,
  );

  /// Menginisialisasi koneksi WebSocket dan subscribe ke channel antrian
  Future<void> initialize({
    required String apiKey,
    required String cluster,
  }) async {
    if (_isInitialized) return;
    
    _setLoading(true);
    
    try {
      // Inisialisasi koneksi Pusher
      await _pusherService.initialize(
        apiKey: apiKey,
        cluster: cluster,
        enableLogging: kDebugMode,
      );

      // Subscribe ke channel antrian
      await _pusherService.subscribeToChannel(_channelName);
      
      // Daftarkan callback event
      _registerEventCallbacks();
      
      _isInitialized = true;
      _clearError();
      _setLoading(false);
      
      if (kDebugMode) {
        print('AntrianProvider: Berhasil diinisialisasi dengan Pusher');
      }
    } catch (e) {
      _setError('Gagal menginisialisasi koneksi real-time: $e');
      if (kDebugMode) {
        print('AntrianProvider: Error inisialisasi - $e');
      }
    }
  }

  /// Daftarkan callback event untuk semua event antrian
  void _registerEventCallbacks() {
    // Daftarkan satu callback untuk event antrian utama
    _pusherService.registerEventCallback(_mainEventName, (data) {
      if (kDebugMode) {
        print('AntrianProvider: Menerima event update antrian');
        print('AntrianProvider: Data: $data');
      }
      
      // Proses event berdasarkan field action
      _handleWebSocketMessage(data);
    });
  }
  
  /// Proses pesan WebSocket berdasarkan tipe action
  void _handleWebSocketMessage(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        // Ekstrak action dan data antrian
        final action = data['action'];
        final antrianData = data['antrian'];
        
        if (kDebugMode) {
          print('AntrianProvider: Action: $action');
          print('AntrianProvider: Data antrian: $antrianData');
        }
        
        if (action == null || antrianData == null) {
          print('AntrianProvider: Action atau data antrian tidak ditemukan');
          return;
        }
        
        switch (action) {
          case 'create':
            print('AntrianProvider: Menangani action create');
            _addAntrian(AntrianModel.fromJson(antrianData));
            break;
          case 'update':
          case 'update-status':
            print('AntrianProvider: Menangani action update');
            _updateAntrian(AntrianModel.fromJson(antrianData));
            break;
          case 'delete':
            print('AntrianProvider: Menangani action delete');
            _removeAntrian(antrianData['id']);
            break;
          default:
            print('AntrianProvider: Action tidak dikenal: $action');
        }
      } else {
        print('AntrianProvider: Data bukan Map: $data');
      }
    } catch (e) {
      print('AntrianProvider: Error memproses pesan WebSocket: $e');
      print('AntrianProvider: Data mentah: $data');
    }
  }

  /// Bersihkan koneksi WebSocket dan callback event
  @override
  void dispose() {
    if (_isInitialized) {
      _pusherService.clearEventCallbacks(_mainEventName);
      _pusherService.unsubscribeFromChannel(_channelName);
      _pusherService.disconnect();
    }
    super.dispose();
  }

  /// Muat semua data antrian
  Future<void> loadAntrians({String? status}) async {
    _setLoading(true);

    try {
      final token = await _secureStorage.getData('token');
      final antrians = await _antrianUseCase.getAllAntrian(token, status: status);

      _antrians = antrians;
      _clearError();
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  /// Muat data antrian untuk user saat ini
  Future<void> loadAntriansByUser({String? status}) async {
    _setLoading(true);

    try {
      final token = await _secureStorage.getData('token');
      final userId = await _secureStorage.getData('id');

      if (userId.isEmpty) {
        throw Exception('User ID tidak ditemukan');
      }

      final antrians = await _antrianUseCase.getAntrianByUserId(
        int.parse(userId), 
        token, 
        status: status
      );

      _antrians = antrians;
      _clearError();
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  /// Buat antrian baru
  Future<bool> createAntrian({
    required String nama,
    required String keluhan,
    required int idLayanan,
    required int idHewan,
  }) async {
    _setLoading(true);

    try {
      final token = await _secureStorage.getData('token');
      final userId = await _secureStorage.getData('id');

      if (userId.isEmpty) {
        throw Exception('User ID tidak ditemukan');
      }

      await _antrianUseCase.createAntrian(
        token: token,
        nama: nama,
        keluhan: keluhan,
        idLayanan: idLayanan,
        idUser: int.parse(userId),
        idHewan: idHewan,
      );

      // Kita akan mendapatkan update melalui WebSocket
      _clearError();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update antrian yang sudah ada
  Future<bool> updateAntrian({
    required int id,
    String? nama,
    String? keluhan,
    int? idLayanan,
    int? idHewan,
  }) async {
    _setLoading(true);

    try {
      final token = await _secureStorage.getData('token');

      await _antrianUseCase.updateAntrian(
        id: id,
        token: token,
        nama: nama,
        keluhan: keluhan,
        idLayanan: idLayanan,
        idHewan: idHewan,
      );

      // Kita akan mendapatkan update melalui WebSocket
      _clearError();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update status antrian
  Future<bool> updateAntrianStatus({
    required int id,
    required String status,
  }) async {
    _setLoading(true);

    try {
      final token = await _secureStorage.getData('token');

      await _antrianUseCase.updateAntrianStatus(
        id: id,
        status: status,
        token: token,
      );

      // Kita akan mendapatkan update melalui WebSocket
      _clearError();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Hapus antrian
  Future<bool> deleteAntrian(int id) async {
    _setLoading(true);

    try {
      final token = await _secureStorage.getData('token');
      final success = await _antrianUseCase.deleteAntrian(id, token);

      // Kita akan mendapatkan update melalui WebSocket jika berhasil
      _clearError();
      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Tambahkan antrian baru ke dalam list
  void _addAntrian(AntrianModel antrian) {
    try {
      // Cek apakah antrian sudah ada
      final existingIndex = _antrians.indexWhere((item) => item.id == antrian.id);
      
      if (existingIndex == -1) {
        // Tambahkan ke list jika belum ada
        _antrians.add(antrian);
        // Urutkan berdasarkan waktu pembuatan
        _antrians.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        
        if (kDebugMode) {
          print('AntrianProvider: Menambahkan antrian baru #${antrian.id}');
        }
        
        // Beritahu listener untuk update UI
        notifyListeners();
      } else {
        if (kDebugMode) {
          print('AntrianProvider: Antrian #${antrian.id} sudah ada, tidak ditambahkan');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('AntrianProvider: Error menambahkan antrian - $e');
      }
    }
  }

  /// Update antrian yang sudah ada dalam list
  void _updateAntrian(AntrianModel updatedAntrian) {
    try {
      // Cari item di dalam list
      final index = _antrians.indexWhere((item) => item.id == updatedAntrian.id);
      
      if (index != -1) {
        // Update item jika sudah ada
        _antrians[index] = updatedAntrian;
        
        if (kDebugMode) {
          print('AntrianProvider: Update antrian #${updatedAntrian.id}');
        }
        
        // Beritahu listener untuk update UI
        notifyListeners();
      } else {
        // Tambahkan jika belum ada
        _antrians.add(updatedAntrian);
        // Urutkan berdasarkan waktu pembuatan
        _antrians.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        
        if (kDebugMode) {
          print('AntrianProvider: Menambahkan antrian yang hilang #${updatedAntrian.id} setelah update');
        }
        
        // Beritahu listener untuk update UI
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('AntrianProvider: Error update antrian - $e');
      }
    }
  }

  /// Hapus antrian dari list berdasarkan ID
  void _removeAntrian(int id) {
    try {
      // Dapatkan panjang saat ini untuk memeriksa apakah ada yang dihapus
      final previousLength = _antrians.length;
      
      // Hapus antrian dengan ID yang cocok
      _antrians.removeWhere((item) => item.id == id);
      
      // Hanya beritahu jika ada yang benar-benar dihapus
      if (previousLength != _antrians.length) {
        if (kDebugMode) {
          print('AntrianProvider: Menghapus antrian #$id');
        }
        
        // Beritahu listener untuk update UI
        notifyListeners();
      } else {
        if (kDebugMode) {
          print('AntrianProvider: Antrian #$id tidak ditemukan untuk dihapus');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('AntrianProvider: Error menghapus antrian - $e');
      }
    }
  }

  /// Set item secara langsung (berguna untuk testing atau data awal)
  void setAntrians(List<AntrianModel> antrians) {
    _antrians = antrians;
    notifyListeners();
  }

  /// Dapatkan antrian berdasarkan status
  List<AntrianModel> getAntriansByStatus(String status) {
    return _antrians.where((antrian) => antrian.status == status).toList();
  }

  /// Set status loading
  void _setLoading(bool isLoading) {
    _status = isLoading ? AntrianStatus.loading : AntrianStatus.loaded;
    notifyListeners();
  }

  /// Set pesan error
  void _setError(String message) {
    _errorMessage = message;
    _status = AntrianStatus.error;
    notifyListeners();
    
    if (kDebugMode) {
      print('AntrianProvider: ERROR - $message');
    }
  }

  /// Bersihkan pesan error
  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}