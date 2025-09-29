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
  static const String _tokenApiUrl = 'https://cloud-api.livekit.io/api/sandbox/connection-details';
  
  // Sandbox ID from .env file with fallback
  static const String _fallbackSandboxId = 'blueguard-tejjfg';

  String get sandboxId => dotenv.env['LIVEKIT_SANDBOX_ID'] ?? _fallbackSandboxId;

  /// Main method to get connection details using LiveKit Cloud API
  Future<ConnectionDetails> fetchConnectionDetails({
    required String roomName,
    required String participantName,
  }) async {
    try {
      _logger.info('Requesting token from LiveKit Cloud API for room: $roomName');
      
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
        
        _logger.info('Successfully received connection details from LiveKit Cloud');
        _logger.info('Server URL: ${jsonData['serverUrl']}');
        
        return ConnectionDetails.fromJson(jsonData);
      } else {
        throw Exception('Failed to get connection details: ${response.statusCode} ${response.body}');
      }
    } catch (error) {
      _logger.severe('Error fetching connection details: $error');
      rethrow;
    }
  }
}

  /// Main method to get connection details with proper JWT token
  Future<ConnectionDetails> fetchConnectionDetails({
    required String roomName,
    required String participantName,
  }) async {
    // Validate credentials
    if (apiKey == 'YOUR_ACTUAL_API_KEY_HERE' ||
        apiSecret == 'YOUR_ACTUAL_API_SECRET_HERE') {
      throw Exception('''
LiveKit credentials not configured properly!

To fix this:
1. Go to LiveKit Cloud dashboard: https://cloud.livekit.io/
2. Find your sandbox "blueguard-tejjfg"
3. Get the API Key and API Secret for this sandbox
4. Update the credentials in token_service_blueguard.dart

Your sandbox URL is: $serverUrl
''');
    }

    try {
      // Generate proper JWT token
      final token = _generateJWTToken(
        apiKey: apiKey,
        apiSecret: apiSecret,
        room: roomName,
        identity: participantName,
      );

      _logger.info(
          'Generated JWT token for room: $roomName, participant: $participantName');
      _logger.info('Using server URL: $serverUrl');

      return ConnectionDetails(
        serverUrl: serverUrl,
        roomName: roomName,
        participantName: participantName,
        participantToken: token,
      );
    } catch (error) {
      _logger.severe('Error generating connection details: $error');
      rethrow;
    }
  }

  /// Generate proper JWT token for LiveKit authentication
  String _generateJWTToken({
    required String apiKey,
    required String apiSecret,
    required String room,
    required String identity,
  }) {
    // JWT Header
    final header = {
      'alg': 'HS256',
      'typ': 'JWT',
    };

    // JWT Payload with LiveKit permissions
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final exp = now + (6 * 60 * 60); // 6 hours expiry

    final payload = {
      'iss': apiKey,
      'sub': identity,
      'iat': now,
      'exp': exp,
      'room': room,
      'video': {
        'room': room,
        'roomJoin': true,
        'canPublish': true,
        'canSubscribe': true,
        'canPublishData': true,
      },
    };

    // Encode header and payload
    final encodedHeader = _base64UrlEncode(utf8.encode(json.encode(header)));
    final encodedPayload = _base64UrlEncode(utf8.encode(json.encode(payload)));

    // Create signature
    final message = '$encodedHeader.$encodedPayload';
    final key = utf8.encode(apiSecret);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(utf8.encode(message));
    final signature = _base64UrlEncode(digest.bytes);

    return '$message.$signature';
  }

  /// Helper method for base64url encoding without padding
  String _base64UrlEncode(List<int> bytes) {
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}
