import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:crypto/crypto.dart';

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

  // Sandbox ID from .env file with fallback
  static const String _fallbackSandboxId = 'blueguard-tejjfg';

  String get sandboxId =>
      dotenv.env['LIVEKIT_SANDBOX_ID'] ?? _fallbackSandboxId;

  // Get credentials from environment variables
  String get apiKey => dotenv.env['LIVEKIT_API_KEY'] ?? 'API4oeZuqm7msUc';
  String get apiSecret =>
      dotenv.env['LIVEKIT_API_SECRET'] ??
      '459I9M50On3fB5Hgk116VNegOzer7WVPovPKgVDy7H1A';
  String get serverUrl =>
      dotenv.env['LIVEKIT_URL'] ?? 'wss://blueguard-tejjfg.livekit.cloud';

  /// Main method to get connection details with proper JWT token
  Future<ConnectionDetails> fetchConnectionDetails({
    required String roomName,
    required String participantName,
  }) async {
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
