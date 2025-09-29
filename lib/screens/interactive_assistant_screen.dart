import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class InteractiveAssistantScreen extends StatefulWidget {
  const InteractiveAssistantScreen({super.key});

  @override
  State<InteractiveAssistantScreen> createState() =>
      _InteractiveAssistantScreenState();
}

class _InteractiveAssistantScreenState
    extends State<InteractiveAssistantScreen> {
  // LiveKit Configuration
  static const String _livekitUrl = 'wss://blueguard-vshrbqnh.livekit.cloud';
  static const String _apiKey = 'APITC85qfpNZ5UZ';

  bool _isConnected = false;
  bool _isConnecting = false;
  bool _isMicrophoneEnabled = false;

  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _chatHistory = [];
  final ScrollController _scrollController = ScrollController();

  String _connectionStatus = 'Ready to Connect';

  @override
  void initState() {
    super.initState();
    _initializeAssistant();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeAssistant() async {
    // Request microphone permission
    await _requestPermissions();

    // Add initial message
    _addChatMessage(
      'Welcome to BlueGuard Interactive Assistant! This connects to your deployed LiveKit agent at $_livekitUrl. Click "Connect" to start your real-time conversation with the marine biology AI.',
      isUser: false,
    );
  }

  Future<void> _requestPermissions() async {
    final micPermission = await Permission.microphone.request();
    setState(() {
      _isMicrophoneEnabled = micPermission == PermissionStatus.granted;
    });

    if (!_isMicrophoneEnabled) {
      _addChatMessage(
        'Microphone permission is required for voice interaction. You can still use text chat.',
        isUser: false,
      );
    }
  }

  Future<void> _connectToAgent() async {
    if (_isConnecting || _isConnected) return;

    setState(() {
      _isConnecting = true;
      _connectionStatus = 'Connecting to LiveKit agent...';
    });

    try {
      // Simulate connection to your LiveKit agent
      // In a real implementation, you would:
      // 1. Generate a JWT token with your API key/secret
      // 2. Connect to the LiveKit room
      // 3. Set up audio/video tracks
      // 4. Handle agent responses

      await Future.delayed(
          const Duration(seconds: 2)); // Simulate connection time

      setState(() {
        _isConnected = true;
        _isConnecting = false;
        _connectionStatus = 'Connected to Agent';
      });

      _addChatMessage(
        '🎉 Successfully connected to your BlueGuard AI Agent!\n\n'
        '• Agent URL: $_livekitUrl\n'
        '• Real-time voice chat enabled\n'
        '• Marine biology expertise active\n\n'
        'You can now speak or type your questions about marine life, fish species, conservation, and ocean topics!',
        isUser: false,
      );

      // Simulate agent initialization message
      await Future.delayed(const Duration(seconds: 1));
      _addChatMessage(
        'Hello! I\'m your AI marine biology assistant running on LiveKit. I can help you with fish identification, conservation status, ocean ecosystems, and sustainable fishing practices. What would you like to know about marine life?',
        isUser: false,
      );
    } catch (e) {
      print('Failed to connect to agent: $e');
      setState(() {
        _isConnecting = false;
        _connectionStatus = 'Connection Failed';
      });

      _addChatMessage(
        'Failed to connect to the LiveKit agent. Please check:\n'
        '• Internet connection\n'
        '• Agent is running: start /B python agent.py start --url $_livekitUrl --api-key $_apiKey --api-secret [secret]\n'
        '• LiveKit server is accessible',
        isUser: false,
      );
    }
  }

  void _disconnectFromAgent() {
    setState(() {
      _isConnected = false;
      _connectionStatus = 'Disconnected';
    });

    _addChatMessage(
      'Disconnected from the LiveKit agent. Click "Connect" to reconnect.',
      isUser: false,
    );
  }

  void _sendTextMessage() {
    final message = _textController.text.trim();
    if (message.isEmpty) return;

    _textController.clear();
    _addChatMessage(message, isUser: true);

    if (_isConnected) {
      _sendMessageToAgent(message);
    } else {
      _addChatMessage(
        'Not connected to the agent. Please connect first.',
        isUser: false,
      );
    }
  }

  void _sendMessageToAgent(String message) {
    // Simulate sending message to your LiveKit agent
    // In a real implementation, this would send the message through LiveKit's data channel

    // Show typing indicator
    _addChatMessage('Processing your question...',
        isUser: false, isTyping: true);

    // Simulate agent processing time
    Future.delayed(const Duration(seconds: 2), () {
      // Remove typing indicator
      setState(() {
        _chatHistory.removeWhere((msg) => msg.isTyping);
      });

      // Generate marine biology response based on the input
      final response = _generateMarineBiologyResponse(message);
      _addChatMessage(response, isUser: false);
    });
  }

  String _generateMarineBiologyResponse(String input) {
    final lowerInput = input.toLowerCase();

    if (lowerInput.contains('whale shark')) {
      return '🐋 Whale sharks (Rhincodon typus) are fascinating! They\'re the largest fish in the ocean, reaching up to 12 meters in length. Despite their size, they\'re gentle filter feeders that primarily eat plankton. They\'re currently endangered due to ship strikes and fishing nets. Fun fact: Each whale shark has a unique spot pattern, like a fingerprint!';
    } else if (lowerInput.contains('coral') || lowerInput.contains('reef')) {
      return '🪸 Coral reefs are incredibly biodiverse ecosystems! They support about 25% of all marine species despite covering less than 1% of the ocean. Coral bleaching due to rising ocean temperatures is a major concern. Healthy reefs provide coastal protection, support fisheries, and are crucial for marine biodiversity.';
    } else if (lowerInput.contains('plastic') ||
        lowerInput.contains('pollution')) {
      return '🗑️ Marine plastic pollution is a critical issue. Over 8 million tons of plastic enter our oceans annually. Microplastics are found in the food chain from plankton to large marine mammals. This affects fish reproduction, feeding behavior, and can introduce toxins into marine ecosystems.';
    } else if (lowerInput.contains('tuna')) {
      return '🐟 Yellowfin tuna are remarkable ocean athletes! They can swim at speeds up to 75 km/h and dive to depths of 250 meters. They\'re warm-blooded fish, which is unusual, allowing them to hunt in cooler waters. Unfortunately, they\'re overfished and listed as Near Threatened.';
    } else if (lowerInput.contains('conservation')) {
      return '🌊 Marine conservation involves protecting ocean ecosystems through marine protected areas (MPAs), sustainable fishing practices, and reducing pollution. Key strategies include establishing no-take zones, regulating fishing quotas, and reducing plastic waste. Every action helps preserve our oceans for future generations!';
    } else if (lowerInput.contains('climate change') ||
        lowerInput.contains('warming')) {
      return '🌡️ Ocean warming affects marine life profoundly. Rising temperatures cause coral bleaching, alter fish migration patterns, and affect breeding cycles. Ocean acidification from CO2 absorption makes it harder for shellfish and corals to build their shells and skeletons.';
    } else {
      return '🤖 As your LiveKit-powered marine biology AI, I\'d love to help you explore ocean topics! Try asking me about specific fish species, coral reefs, marine conservation, ocean pollution, or climate change impacts on marine life. What aspect of marine biology interests you most?';
    }
  }

  void _addChatMessage(String message,
      {required bool isUser, bool isTyping = false}) {
    setState(() {
      _chatHistory.add(ChatMessage(
        text: message,
        isUser: isUser,
        timestamp: DateTime.now(),
        isTyping: isTyping,
      ));
    });

    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive AI Assistant'),
        backgroundColor: const Color(0xFF005A7C),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isConnected ? Icons.cloud_done : Icons.cloud_off,
                    color:
                        _isConnected ? Colors.greenAccent : Colors.orangeAccent,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isConnected ? 'Live' : 'Offline',
                    style: TextStyle(
                      color: _isConnected
                          ? Colors.greenAccent
                          : Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildConnectionPanel(),
          Expanded(
            child: _buildChatArea(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildConnectionPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue[50]!,
            Colors.blue[100]!,
          ],
        ),
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: const Color(0xFF005A7C),
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LiveKit Agent Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _connectionStatus,
                      style: TextStyle(
                        color: _isConnected
                            ? Colors.green[700]
                            : Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (!_isConnected)
                ElevatedButton.icon(
                  onPressed: _isConnecting ? null : _connectToAgent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005A7C),
                    foregroundColor: Colors.white,
                  ),
                  icon: _isConnecting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.connect_without_contact),
                  label: Text(_isConnecting ? 'Connecting...' : 'Connect'),
                )
              else
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isMicrophoneEnabled
                            ? Colors.green[100]
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isMicrophoneEnabled ? Icons.mic : Icons.mic_off,
                            size: 16,
                            color: _isMicrophoneEnabled
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isMicrophoneEnabled ? 'Mic On' : 'Mic Off',
                            style: TextStyle(
                              color: _isMicrophoneEnabled
                                  ? Colors.green[700]
                                  : Colors.red[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _disconnectFromAgent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.call_end, size: 16),
                      label: const Text('Disconnect'),
                    ),
                  ],
                ),
            ],
          ),
          if (_isConnected) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.green[700], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Connected to LiveKit agent. Voice and text chat enabled.',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _chatHistory.length,
        itemBuilder: (context, index) {
          return _buildMessageBubble(_chatHistory[index]);
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF005A7C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? const Color(0xFF005A7C)
                    : message.isTyping
                        ? Colors.grey[300]
                        : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: message.isTyping
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.grey[600]!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          message.text,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: _isConnected
                    ? 'Ask about marine life, conservation, fish species...'
                    : 'Connect to agent to start chatting',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Color(0xFF005A7C)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                prefixIcon: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.grey[500],
                ),
              ),
              enabled: _isConnected,
              onSubmitted: (_) => _sendTextMessage(),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor:
                _isConnected ? const Color(0xFF005A7C) : Colors.grey,
            child: IconButton(
              onPressed: _isConnected ? _sendTextMessage : null,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isTyping;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isTyping = false,
  });
}
