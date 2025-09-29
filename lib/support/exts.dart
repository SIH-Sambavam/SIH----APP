import 'package:livekit_client/livekit_client.dart' as sdk;

// Ext for Participant
extension ParticipantAgentExt on sdk.Participant {
  bool get isAgent => kind == sdk.ParticipantKind.AGENT;

  Map<String, dynamic> get agentAttributes {
    try {
      return attributes;
    } catch (e) {
      return {};
    }
  }
}
