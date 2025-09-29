import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatAssistantScreen extends StatefulWidget {
  const ChatAssistantScreen({super.key});

  @override
  State<ChatAssistantScreen> createState() => _ChatAssistantScreenState();
}

class _ChatAssistantScreenState extends State<ChatAssistantScreen> {
  static const String _geminiApiKey = "AIzaSyBLTuvYnme3_Stl0ETvvvPLSH83K-0RyTw";
  static const String _geminiApiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addMessage(ChatMessage(
      text:
          "🌊 Hello! I'm MarineAI, your specialized marine biology assistant powered by Google's Gemini 2.0 Flash. I can help you with:\n\n• Fish species identification\n• Marine conservation status\n• Ocean ecosystems and biodiversity\n• Sustainable fishing practices\n• Marine pollution and climate change\n• Oceanography and marine habitats\n• Marine wildlife behavior\n\nWhat would you like to know about marine life today?",
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
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

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();
    _addMessage(ChatMessage(text: text, isUser: true));

    setState(() {
      _isLoading = true;
    });

    try {
      print('🔄 Getting Gemini response for: $text');
      final response = await _getGeminiResponse(text);
      print('✅ Received response: $response');

      setState(() {
        _isLoading = false;
      });

      _addMessage(ChatMessage(
        text: response,
        isUser: false,
      ));
    } catch (e) {
      print('❌ Error getting response: $e');
      setState(() {
        _isLoading = false;
      });

      String errorMessage =
          "I'm having trouble connecting to my AI brain right now. ";

      // Provide more specific error messages
      if (e.toString().contains('SocketException')) {
        errorMessage += "Please check your internet connection and try again!";
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage += "The request took too long. Please try again!";
      } else if (e.toString().contains('403')) {
        errorMessage +=
            "There's an issue with API access. Please try again later.";
      } else if (e.toString().contains('429')) {
        errorMessage +=
            "Too many requests. Please wait a moment and try again.";
      } else {
        errorMessage +=
            "Please try again or rephrase your question about marine life.";
      }

      _addMessage(ChatMessage(
        text: errorMessage,
        isUser: false,
      ));
    }
  }

  Future<String> _getGeminiResponse(String userInput) async {
    try {
      print('🚀 Making Gemini API call for: $userInput');

      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text':
                    'As MarineAI, a specialized marine biology assistant, answer this question briefly and concisely: $userInput'
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 300, // Reduced to save on free tier usage
          'topP': 0.8,
          'topK': 10,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      };

      print('📤 Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse('$_geminiApiUrl?key=$_geminiApiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('📊 Parsed data: $data');

        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          print('🎯 Candidate: $candidate');

          // Check if content was blocked
          if (candidate['finishReason'] == 'SAFETY') {
            print('🚫 Content blocked by safety filters');
            return "I can help you with marine biology questions! Please ask about fish species, ocean conservation, or marine ecosystems.";
          }

          // Get the response text
          if (candidate['content'] != null &&
              candidate['content']['parts'] != null &&
              candidate['content']['parts'].isNotEmpty) {
            final aiResponse = candidate['content']['parts'][0]['text'];
            print('✅ AI Response: $aiResponse');

            if (aiResponse != null && aiResponse.trim().isNotEmpty) {
              return aiResponse;
            }
          }
        }

        print('⚠️ Unexpected response structure');
        return "I apologize, but I couldn't generate a proper response. Please try asking about specific marine topics!";
      } else {
        print('❌ API request failed with status: ${response.statusCode}');
        print('❌ Error body: ${response.body}');

        // Handle specific error cases
        if (response.statusCode == 400) {
          final errorData = jsonDecode(response.body);
          if (errorData['error'] != null &&
              errorData['error']['message'] != null) {
            print('❌ Error message: ${errorData['error']['message']}');
            return "I'm having trouble understanding your question. Please try rephrasing it or ask about marine biology topics.";
          }
        } else if (response.statusCode == 403) {
          return "I'm currently experiencing API limitations. Please try again later.";
        } else if (response.statusCode == 429) {
          return "I'm receiving too many requests right now. Please wait a moment and try again.";
        }

        throw Exception(
            'API request failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('💥 Exception in Gemini API call: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MarineAI Chat'),
        backgroundColor: const Color(0xFF005A7C),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.cyan.shade50,
            ],
          ),
        ),
        child: Column(
          children: [
            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isLoading) {
                    return const _TypingIndicator();
                  }
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),

            // Input section
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF005A7C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xFF005A7C) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 8,
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Ask about marine life...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Color(0xFF005A7C)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                onSubmitted: _handleSubmitted,
                textInputAction: TextInputAction.send,
                maxLines: null,
                enabled: !_isLoading,
              ),
            ),
            const SizedBox(width: 12),
            FloatingActionButton(
              onPressed: _isLoading
                  ? null
                  : () => _handleSubmitted(_textController.text),
              backgroundColor:
                  _isLoading ? Colors.grey.shade400 : const Color(0xFF005A7C),
              elevation: 2,
              mini: true,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF005A7C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600.withValues(
                            alpha: 0.3 +
                                0.7 *
                                    (((_controller.value * 3) - index)
                                        .clamp(0, 1)),
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
