// lib/services/pusher_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

/// Service class that handles WebSocket connections using Pusher Channels
class PusherService {
  // Singleton implementation
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;
  PusherService._internal();

  // Pusher instance
  late PusherChannelsFlutter _pusher;
  
  // Connection state tracking
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  // Event callback registry
  final Map<String, List<Function(dynamic)>> _eventCallbacks = {};

  /// Initialize the Pusher connection with credentials
  Future<void> initialize({
    required String apiKey,
    required String cluster,
    String? authEndpoint,
    bool enableLogging = kDebugMode,
  }) async {
    try {
      _pusher = PusherChannelsFlutter.getInstance();

      // Configure Pusher options
      await _pusher.init(
        apiKey: apiKey,
        cluster: cluster,
        onConnectionStateChange: _handleConnectionStateChange,
        onError: _handleError,
        authEndpoint: authEndpoint,
        logToConsole: enableLogging,
      );

      // Connect to Pusher
      await _pusher.connect();
      if (kDebugMode) {
        print('PusherService: Initialization complete');
      }
    } catch (e) {
      if (kDebugMode) {
        print('PusherService: Error initializing - $e');
      }
      rethrow;
    }
  }

  /// Subscribe to a Pusher channel
  Future<void> subscribeToChannel(String channelName) async {
    try {
      await _pusher.subscribe(
        channelName: channelName,
        onEvent: _handleEvent,
      );
      if (kDebugMode) {
        print('PusherService: Subscribed to channel $channelName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('PusherService: Error subscribing to channel $channelName - $e');
      }
      rethrow;
    }
  }

  /// Unsubscribe from a Pusher channel
  Future<void> unsubscribeFromChannel(String channelName) async {
    try {
      await _pusher.unsubscribe(channelName: channelName);
      if (kDebugMode) {
        print('PusherService: Unsubscribed from channel $channelName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('PusherService: Error unsubscribing from channel $channelName - $e');
      }
      rethrow;
    }
  }

  /// Register a callback for a specific event
  void registerEventCallback(String eventName, Function(dynamic) callback) {
    if (!_eventCallbacks.containsKey(eventName)) {
      _eventCallbacks[eventName] = [];
    }
    
    _eventCallbacks[eventName]!.add(callback);
    if (kDebugMode) {
      print('PusherService: Registered callback for event $eventName');
    }
  }

  /// Remove a callback for a specific event
  void unregisterEventCallback(String eventName, Function(dynamic) callback) {
    if (_eventCallbacks.containsKey(eventName)) {
      _eventCallbacks[eventName]!.remove(callback);
      if (kDebugMode) {
        print('PusherService: Unregistered callback for event $eventName');
      }
    }
  }

  /// Clear all callbacks for a specific event
  void clearEventCallbacks(String eventName) {
    _eventCallbacks.remove(eventName);
    if (kDebugMode) {
      print('PusherService: Cleared all callbacks for event $eventName');
    }
  }

  /// Disconnect from Pusher
  Future<void> disconnect() async {
    try {
      await _pusher.disconnect();
      _isConnected = false;
      if (kDebugMode) {
        print('PusherService: Disconnected');
      }
    } catch (e) {
      if (kDebugMode) {
        print('PusherService: Error disconnecting - $e');
      }
      rethrow;
    }
  }

  /// Handle connection state changes
  dynamic _handleConnectionStateChange(String currentState, String previousState) {
    if (kDebugMode) {
      print('PusherService: Connection state changed from $previousState to $currentState');
    }
    
    _isConnected = currentState == "CONNECTED";
    return null;
  }

  /// Handle Pusher errors
  dynamic _handleError(String message, int? code, dynamic error) {
    if (kDebugMode) {
      print('PusherService: Error - $message, code: $code, error: $error');
    }
    return null;
  }

  /// Handle incoming events and route to registered callbacks
  void _handleEvent(PusherEvent event) {
    if (kDebugMode) {
      print('PusherService: Received event - ${event.eventName} with data: ${event.data}');
    }

    // Process the event if we have registered callbacks
    if (_eventCallbacks.containsKey(event.eventName)) {
      try {
        // Parse the data
        final dynamic parsedData = event.data != null 
          ? jsonDecode(event.data!) 
          : null;
        
        // Notify all callbacks registered for this event
        for (final callback in _eventCallbacks[event.eventName]!) {
          callback(parsedData);
        }
      } catch (e) {
        if (kDebugMode) {
          print('PusherService: Error processing event data - $e');
          print('PusherService: Raw event data - ${event.data}');
        }
      }
    }
  }
}