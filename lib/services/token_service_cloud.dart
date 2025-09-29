import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

/// Data class representing the connection details needed to join a LiveKit room
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
      serverUrl: json['serverUrl'] ?? json['server_url'] ?? '',
      roomName: json['roomName'] ?? json['room_name'] ?? '',
      participantName:
          json['participantName'] ?? json['participant_name'] ?? '',
      participantToken:
          json['participantToken'] ?? json['participant_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serverUrl': serverUrl,
      'roomName': roomName,
      'participantName': participantName,
      'participantToken': participantToken,
    };
  }

  @override
  String toString() {
    return 'ConnectionDetails(serverUrl: $serverUrl, roomName: $roomName, participantName: $participantName, token: ${participantToken.substring(0, 20)}...)';
  }
}

/// Token service for BlueGuard LiveKit integration using cloud token API
class TokenService {
  static final _logger = Logger('TokenService');

  // LiveKit Cloud API endpoint for blueguard-tejjfg sandbox
  static const String _tokenApiUrl =
      'https://cloud-api.livekit.io/api/sandbox/connection-details';
  static const String _sandboxId = 'blueguard-tejjfg';

  /// Main method to get connection details using LiveKit cloud token API
  Future<ConnectionDetails> fetchConnectionDetails({
    String? roomName,
    String? participantName,
  }) async {
    try {
      _logger.info('Requesting connection details from LiveKit cloud API');

      // Prepare request body
      final requestBody = <String, dynamic>{};
      if (roomName != null) {
        requestBody['room_name'] = roomName;
      }
      if (participantName != null) {
        requestBody['participant_name'] = participantName;
      }

      // Make request to LiveKit cloud API
      final response = await http.post(
        Uri.parse(_tokenApiUrl),
        headers: {
          'X-Sandbox-ID': _sandboxId,
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      _logger.info('LiveKit API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        _logger.info('Successfully received connection details');

        final connectionDetails = ConnectionDetails.fromJson(responseData);
        _logger.info('Connection details: $connectionDetails');

        return connectionDetails;
      } else {
        final errorMessage =
            'Failed to get connection details. Status: ${response.statusCode}, Body: ${response.body}';
        _logger.severe(errorMessage);
        throw Exception(errorMessage);
      }
    } catch (error) {
      _logger.severe('Error fetching connection details: $error');
      rethrow;
    }
  }

  /// Alternative method with explicit room and participant names
  Future<ConnectionDetails> getConnectionDetails({
    required String roomName,
    required String participantName,
  }) async {
    return fetchConnectionDetails(
      roomName: roomName,
      participantName: participantName,
    );
  }

  /// Get connection details with random room and participant names
  Future<ConnectionDetails> getRandomConnectionDetails() async {
    return fetchConnectionDetails();
  }
}
