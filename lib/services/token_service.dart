import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

/// Data class representing the connection details needed to join a LiveKit room
/// This includes the server URL, room name, participant info, and auth token
class ConnectionDetails {
  final String serverUrl;
  final String roomName;
  final String participantName;
  final String participantToken;

  ConnectionDetails({
    required this.serverUrl,
    required this.roomName,
    required this.participantName,
    required this.participantToken,
  });

  factory ConnectionDetails.fromJson(Map<String, dynamic> json) {
    return ConnectionDetails(
      serverUrl: json['serverUrl'],
      roomName: json['roomName'],
      participantName: json['participantName'],
      participantToken: json['participantToken'],
    );
  }

  @override
  String toString() {
    return 'ConnectionDetails(serverUrl: $serverUrl, roomName: $roomName, participantName: $participantName)';
  }
}

/// Token service for BlueGuard LiveKit integration
///
/// For BlueGuard production usage with your credentials:
/// - Set `hardcodedServerUrl` and `hardcodedToken` below with your BlueGuard LiveKit credentials
///
/// For LiveKit Cloud sandbox (development only):
/// - Create .env file with your LIVEKIT_SANDBOX_ID or set sandboxId manually
///
/// See https://docs.livekit.io/home/get-started/authentication for more information
class TokenService {
  static final _logger = Logger('TokenService');

  // For BlueGuard LiveKit Cloud credentials 
  final String? hardcodedServerUrl = 'wss://blueguard-vshrbqnh.livekit.cloud';
  final String? hardcodedToken = 'demo-token-blueguard-marine-assistant'; // TODO: Replace with actual BlueGuard token

  // Sandbox ID - for development and testing
  final String? sandboxId = 'blueguard-marine-assistant'; // BlueGuard sandbox ID

  // LiveKit Cloud sandbox API endpoint
  final String sandboxUrl =
      'https://cloud-api.livekit.io/api/sandbox/connection-details';

  /// Main method to get connection details
  /// First tries hardcoded credentials, then falls back to sandbox
  Future<ConnectionDetails> fetchConnectionDetails({
    required String roomName,
    required String participantName,
  }) async {
    final hardcodedDetails = fetchHardcodedConnectionDetails(
      roomName: roomName,
      participantName: participantName,
    );

    if (hardcodedDetails != null) {
      return hardcodedDetails;
    }

    if (sandboxId != null) {
      return await fetchConnectionDetailsFromSandbox(
        roomName: roomName,
        participantName: participantName,
      );
    }

    throw Exception(
        'No hardcoded credentials or sandbox ID provided. Please configure your LiveKit credentials.');
  }

  Future<ConnectionDetails> fetchConnectionDetailsFromSandbox({
    required String roomName,
    required String participantName,
  }) async {
    if (sandboxId == null) {
      throw Exception(
          'Sandbox ID is not set and no hardcoded credentials provided');
    }

    final uri = Uri.parse(sandboxUrl).replace(queryParameters: {
      'roomName': roomName,
      'participantName': participantName,
    });

    try {
      final response = await http.post(
        uri,
        headers: {'X-Sandbox-ID': sandboxId!},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final data = jsonDecode(response.body);
          return ConnectionDetails.fromJson(data);
        } catch (e) {
          _logger.severe(
              'Error parsing connection details from LiveKit Cloud sandbox, response: ${response.body}');
          throw Exception(
              'Error parsing connection details from LiveKit Cloud sandbox');
        }
      } else {
        _logger.severe(
            'Error from LiveKit Cloud sandbox: ${response.statusCode}, response: ${response.body}');
        throw Exception('Error from LiveKit Cloud sandbox');
      }
    } catch (e) {
      _logger.severe('Failed to connect to LiveKit Cloud sandbox: $e');
      throw Exception('Failed to connect to LiveKit Cloud sandbox');
    }
  }

  ConnectionDetails? fetchHardcodedConnectionDetails({
    required String roomName,
    required String participantName,
  }) {
    if (hardcodedServerUrl == null || hardcodedToken == null) {
      return null;
    }

    return ConnectionDetails(
      serverUrl: hardcodedServerUrl!,
      roomName: roomName,
      participantName: participantName,
      participantToken: hardcodedToken!,
    );
  }
}
