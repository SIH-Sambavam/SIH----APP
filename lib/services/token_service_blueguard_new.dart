import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
}

/// Token service for BlueGuard LiveKit integration using LiveKit Cloud API
class TokenService {
  static final _logger = Logger('TokenService');

  // LiveKit Cloud API endpoint for sandbox token generation
  static const String _tokenApiUrl =
      'https://cloud-api.livekit.io/api/sandbox/connection-details';

  // Sandbox ID from .env file with fallback
  static const String _fallbackSandboxId = 'blueguard-tejjfg';

  String get sandboxId =>
      dotenv.env['LIVEKIT_SANDBOX_ID'] ?? _fallbackSandboxId;

  /// Main method to get connection details using LiveKit Cloud API
  Future<ConnectionDetails> fetchConnectionDetails({
    required String roomName,
    required String participantName,
  }) async {
    try {
      _logger
          .info('Requesting token from LiveKit Cloud API for room: $roomName');

      // Prepare the request
      final response = await http.post(
        Uri.parse(_tokenApiUrl),
        headers: {
          'X-Sandbox-ID': sandboxId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'room_name': roomName,
          'participant_name': participantName,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        _logger.info(
            'Successfully received connection details from LiveKit Cloud');
        _logger.info('Server URL: ${jsonData['serverUrl']}');

        return ConnectionDetails.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to get connection details: ${response.statusCode} ${response.body}');
      }
    } catch (error) {
      _logger.severe('Error fetching connection details: $error');
      rethrow;
    }
  }
}
