import 'dart:async';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart' as livekit;
import 'package:logging/logging.dart';

import '../services/token_service_cloud.dart';

// Connection states
enum LiveKitConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  disconnecting,
}

// Screen states
enum AppScreenState {
  welcome,
  agent,
}

enum AgentScreenState {
  agent,
  transcription,
}

// Real LiveKit App Controller for BlueGuard Marine Assistant
class AppCtrl extends ChangeNotifier {
  static final _logger = Logger('AppCtrl');

  AppScreenState _appScreenState = AppScreenState.welcome;
  AgentScreenState _agentScreenState = AgentScreenState.agent;
  LiveKitConnectionState _connectionState = LiveKitConnectionState.disconnected;

  bool _isUserCameEnabled = false;

  // LiveKit room instance
  livekit.Room? _room;
  final TokenService _tokenService = TokenService();

  // Connection timer for timeout
  Timer? _connectionTimer;

  AppScreenState get appScreenState => _appScreenState;
  AgentScreenState get agentScreenState => _agentScreenState;
  LiveKitConnectionState get connectionState => _connectionState;
  bool get isUserCameEnabled => _isUserCameEnabled;
  livekit.Room? get room => _room;

  AppCtrl() {
    // Configure logging
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.time}: ${record.message}');
    });

    // Initialize LiveKit
    _initializeLiveKit();
  }

  // Initialize LiveKit with proper setup
  void _initializeLiveKit() {
    try {
      // LiveKit initialization happens automatically when creating a Room
      _logger.info('LiveKit ready to initialize');
    } catch (e) {
      _logger.severe('Failed to initialize LiveKit: $e');
    }
  } // Connect to LiveKit room

  Future<void> connect() async {
    if (_connectionState == LiveKitConnectionState.connecting ||
        _connectionState == LiveKitConnectionState.connected) {
      return;
    }

    _connectionState = LiveKitConnectionState.connecting;
    notifyListeners();

    try {
      // Create room instance with options
      _room = livekit.Room(
        roomOptions: const livekit.RoomOptions(
          adaptiveStream: true,
          dynacast: true,
        ),
      );

      // Set up event listeners
      _room!.addListener(_onRoomUpdate);

      _logger.info('Requesting connection details from LiveKit cloud...');

      // Get connection details using LiveKit cloud API
      // Let the cloud API generate room and participant names
      final connectionDetails = await _tokenService.fetchConnectionDetails();

      _logger.info(
          'Connected to room: ${connectionDetails.roomName} as ${connectionDetails.participantName}');
      _logger.info('Server URL: ${connectionDetails.serverUrl}');

      // Start connection timeout timer
      _connectionTimer = Timer(const Duration(seconds: 10), () {
        if (_connectionState == LiveKitConnectionState.connecting) {
          _logger.warning('Connection timeout');
          disconnect();
        }
      });

      // Connect to LiveKit
      await _room!.connect(
        connectionDetails.serverUrl,
        connectionDetails.participantToken,
        connectOptions: const livekit.ConnectOptions(
          autoSubscribe: true,
        ),
      );

      _logger.info('Connected to LiveKit room successfully');

      // Enable microphone by default
      await _room!.localParticipant?.setMicrophoneEnabled(true);

      _connectionState = LiveKitConnectionState.connected;
      _appScreenState = AppScreenState.agent;
      _connectionTimer?.cancel();
      notifyListeners();
    } catch (error) {
      _logger.severe('Failed to connect to LiveKit: $error');
      _connectionState = LiveKitConnectionState.disconnected;
      _appScreenState = AppScreenState.welcome;
      _connectionTimer?.cancel();
      notifyListeners();
    }
  }

  // Disconnect from LiveKit room
  Future<void> disconnect() async {
    if (_connectionState == LiveKitConnectionState.disconnected ||
        _connectionState == LiveKitConnectionState.disconnecting) {
      return;
    }

    _connectionState = LiveKitConnectionState.disconnecting;
    notifyListeners();

    try {
      _connectionTimer?.cancel();
      _connectionTimer = null;

      if (_room != null) {
        _room!.removeListener(_onRoomUpdate);
        await _room!.disconnect();
        _room = null;
      }

      _connectionState = LiveKitConnectionState.disconnected;
      _appScreenState = AppScreenState.welcome;
      _isUserCameEnabled = false;
      _agentScreenState = AgentScreenState.agent;
      notifyListeners();

      _logger.info('Disconnected from LiveKit room');
    } catch (error) {
      _logger.severe('Error during disconnect: $error');
      _connectionState = LiveKitConnectionState.disconnected;
      _appScreenState = AppScreenState.welcome;
      notifyListeners();
    }
  }

  // Handle room updates
  void _onRoomUpdate() {
    if (_room != null) {
      if (_room!.connectionState == livekit.ConnectionState.connected) {
        if (_connectionState != LiveKitConnectionState.connected) {
          _connectionState = LiveKitConnectionState.connected;
          _appScreenState = AppScreenState.agent;
          _connectionTimer?.cancel();
          notifyListeners();
        }
      } else if (_room!.connectionState ==
          livekit.ConnectionState.disconnected) {
        if (_connectionState != LiveKitConnectionState.disconnected) {
          _connectionState = LiveKitConnectionState.disconnected;
          _appScreenState = AppScreenState.welcome;
          notifyListeners();
        }
      }
    }
  }

  // Toggle user camera
  Future<void> toggleUserCamera() async {
    if (_room?.localParticipant != null) {
      try {
        _isUserCameEnabled = !_isUserCameEnabled;
        await _room!.localParticipant!.setCameraEnabled(_isUserCameEnabled);
        notifyListeners();
        _logger.info('Camera ${_isUserCameEnabled ? 'enabled' : 'disabled'}');
      } catch (error) {
        _logger.warning('Failed to toggle camera: $error');
      }
    }
  }

  // Toggle microphone
  Future<void> toggleMicrophone() async {
    if (_room?.localParticipant != null) {
      try {
        final isEnabled = _room!.localParticipant!.isMicrophoneEnabled();
        await _room!.localParticipant!.setMicrophoneEnabled(!isEnabled);
        _logger.info('Microphone ${!isEnabled ? 'enabled' : 'disabled'}');
      } catch (error) {
        _logger.warning('Failed to toggle microphone: $error');
      }
    }
  }

  // Toggle agent screen mode
  void toggleAgentScreenMode() {
    _agentScreenState = _agentScreenState == AgentScreenState.agent
        ? AgentScreenState.transcription
        : AgentScreenState.agent;
    notifyListeners();
    _logger.info('Agent screen mode: ${_agentScreenState.name}');
  }

  @override
  void dispose() {
    _connectionTimer?.cancel();
    if (_room != null) {
      _room!.removeListener(_onRoomUpdate);
      _room!.disconnect();
    }
    super.dispose();
  }
}
