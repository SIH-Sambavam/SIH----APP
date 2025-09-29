import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart' as sdk;
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import '../services/token_service.dart';

enum AppScreenState { welcome, agent }

enum AgentScreenState { visualizer, transcription }

enum LiveKitConnectionState { disconnected, connecting, connected }

class AppCtrl extends ChangeNotifier {
  static const uuid = Uuid();
  static final _logger = Logger('AppCtrl');

  // States
  AppScreenState appScreenState = AppScreenState.welcome;
  LiveKitConnectionState connectionState = LiveKitConnectionState.disconnected;
  AgentScreenState agentScreenState = AgentScreenState.visualizer;

  // Camera and screen share controls
  bool isUserCameEnabled = false;
  bool isScreenshareEnabled = false;

  final messageCtrl = TextEditingController();
  final messageFocusNode = FocusNode();

  late final sdk.Room room =
      sdk.Room(roomOptions: const sdk.RoomOptions(enableVisualizer: true));

  final tokenService = TokenService();

  bool isSendButtonEnabled = false;

  // Timer for checking agent connection
  Timer? _agentConnectionTimer;

  AppCtrl() {
    // configure logs for debugging
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.time}: ${record.message}');
    });

    messageCtrl.addListener(() {
      final newValue = messageCtrl.text.isNotEmpty;
      if (newValue != isSendButtonEnabled) {
        isSendButtonEnabled = newValue;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    messageCtrl.dispose();
    _cancelAgentTimer();
    super.dispose();
  }

  void sendMessage() async {
    isSendButtonEnabled = false;

    final text = messageCtrl.text;
    messageCtrl.clear();
    notifyListeners();

    final lp = room.localParticipant;
    if (lp == null) return;

    await lp.sendText(text, options: sdk.SendTextOptions(topic: 'lk.chat'));
  }

  void toggleUserCamera() {
    isUserCameEnabled = !isUserCameEnabled;
    if (isUserCameEnabled) {
      room.localParticipant?.setCameraEnabled(true);
    } else {
      room.localParticipant?.setCameraEnabled(false);
    }
    notifyListeners();
  }

  void toggleScreenShare() {
    isScreenshareEnabled = !isScreenshareEnabled;
    notifyListeners();
  }

  void toggleAgentScreenMode() {
    agentScreenState = agentScreenState == AgentScreenState.visualizer
        ? AgentScreenState.transcription
        : AgentScreenState.visualizer;
    notifyListeners();
  }

  void connect() async {
    _logger.info("Connect....");
    connectionState = LiveKitConnectionState.connecting;
    notifyListeners();

    try {
      // Generate room and participant names for BlueGuard
      final roomName =
          'blueguard-room-${(1000 + DateTime.now().millisecondsSinceEpoch % 9000)}';
      final participantName =
          'blueguard-user-${(1000 + DateTime.now().millisecondsSinceEpoch % 9000)}';

      // Get connection details from token service
      final connectionDetails = await tokenService.fetchConnectionDetails(
        roomName: roomName,
        participantName: participantName,
      );

      _logger.info(
          "Fetched Connection Details: $connectionDetails, connecting to room...");

      await room.connect(
        connectionDetails.serverUrl,
        connectionDetails.participantToken,
      );

      _logger.info("Connected to room");

      await room.localParticipant?.setMicrophoneEnabled(true);

      _logger.info("Microphone enabled");

      connectionState = LiveKitConnectionState.connected;
      appScreenState = AppScreenState.agent;

      // Start the 20-second timer to check for AGENT participant
      _startAgentConnectionTimer();

      notifyListeners();
    } catch (error) {
      _logger.severe('Connection error: $error');

      connectionState = LiveKitConnectionState.disconnected;
      appScreenState = AppScreenState.welcome;
      notifyListeners();
    }
  }

  void disconnect() async {
    _logger.info("Disconnect....");

    _cancelAgentTimer();

    await room.disconnect();
    connectionState = LiveKitConnectionState.disconnected;
    appScreenState = AppScreenState.welcome;
    notifyListeners();
  }

  void _startAgentConnectionTimer() {
    _cancelAgentTimer();
    _agentConnectionTimer = Timer(const Duration(seconds: 20), () {
      _logger.warning('Agent connection check after 20 seconds');
      // Could check for agent participants here if API available
    });
  }

  void _cancelAgentTimer() {
    _agentConnectionTimer?.cancel();
    _agentConnectionTimer = null;
  }
}
