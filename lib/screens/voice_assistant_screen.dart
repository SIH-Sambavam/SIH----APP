import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_ctrl_blueguard.dart';

// Main Voice Assistant Screen
class VoiceAssistantScreen extends StatelessWidget {
  const VoiceAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppCtrl>(
      create: (context) => AppCtrl(),
      child: Consumer<AppCtrl>(
        builder: (ctx, appCtrl, _) => AppLayoutSwitcher(
          frontBuilder: (ctx) => const WelcomeScreen(),
          backBuilder: (ctx) => const AgentScreen(),
          isFront: appCtrl.appScreenState == AppScreenState.welcome,
        ),
      ),
    );
  }
}

// Welcome Screen Component
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext ctx) => Material(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF005A7C),
                Color(0xFF00799F),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // BlueGuard Icon
                  const SizedBox(height: 20),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.waves,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Title and description
                  Column(
                    children: [
                      const Text(
                        'BlueGuard Marine AI Assistant',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Start a voice conversation with our marine biology AI assistant. Ask about fish species, ocean ecosystems, and underwater conservation!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Start Call Button
                  Builder(
                    builder: (ctx) {
                      final isProgressing = [
                        LiveKitConnectionState.connecting,
                        LiveKitConnectionState.connected,
                      ].contains(ctx.watch<AppCtrl>().connectionState);

                      return ElevatedButton(
                        onPressed: isProgressing
                            ? null
                            : () => ctx.read<AppCtrl>().connect(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF005A7C),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isProgressing) ...[
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: 15),
                            ] else ...[
                              const Icon(Icons.mic, size: 20),
                              const SizedBox(width: 10),
                            ],
                            Text(
                              isProgressing
                                  ? 'Connecting...'
                                  : 'Start Voice Session',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Features list
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '🐠 What you can ask about:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFeatureItem('🐟 Fish species identification'),
                            _buildFeatureItem('🌊 Ocean ecosystem information'),
                            _buildFeatureItem('🐠 Marine conservation topics'),
                            _buildFeatureItem('📊 Fishing data and trends'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

// Agent Screen - Main conversation interface
class AgentScreen extends StatelessWidget {
  const AgentScreen({super.key});

  @override
  Widget build(BuildContext ctx) => Material(
        color: const Color(0xFF1a1a1a),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF005A7C),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => ctx.read<AppCtrl>().disconnect(),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BlueGuard Marine Assistant',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Voice conversation active',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 8),
                          SizedBox(width: 6),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main content area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Agent visualization area
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2a2a2a),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color(0xFF005A7C)
                                  .withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.graphic_eq,
                                  size: 80,
                                  color: Color(0xFF005A7C),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Marine AI Assistant',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Connected and ready to chat!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Consumer<AppCtrl>(
                                  builder: (context, appCtrl, _) => Text(
                                    appCtrl.room?.remoteParticipants
                                                .isNotEmpty ==
                                            true
                                        ? '🤖 AI Agent Connected'
                                        : '⏳ Waiting for AI Agent...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: appCtrl.room?.remoteParticipants
                                                  .isNotEmpty ==
                                              true
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Instructions area
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2a2a2a),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🎤 Voice Commands Available:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '• Ask about fish species: "Tell me about mackerel"',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                              Text(
                                '• Ocean questions: "What affects ocean temperature?"',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                              Text(
                                '• Conservation: "How can we protect marine life?"',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                              Text(
                                '• Fishing data: "Show me fishing trends"',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Control buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Microphone toggle
                          Consumer<AppCtrl>(
                            builder: (ctx, appCtrl, _) => _buildControlButton(
                              icon: appCtrl.room?.localParticipant
                                          ?.isMicrophoneEnabled() ==
                                      true
                                  ? Icons.mic
                                  : Icons.mic_off,
                              isActive: appCtrl.room?.localParticipant
                                      ?.isMicrophoneEnabled() ==
                                  true,
                              onTap: () => appCtrl.toggleMicrophone(),
                            ),
                          ),

                          // Camera toggle
                          Consumer<AppCtrl>(
                            builder: (ctx, appCtrl, _) => _buildControlButton(
                              icon: appCtrl.isUserCameEnabled
                                  ? Icons.videocam
                                  : Icons.videocam_off,
                              isActive: appCtrl.isUserCameEnabled,
                              onTap: () => appCtrl.toggleUserCamera(),
                            ),
                          ),

                          // Screen mode toggle
                          Consumer<AppCtrl>(
                            builder: (ctx, appCtrl, _) => _buildControlButton(
                              icon: appCtrl.agentScreenState ==
                                      AgentScreenState.transcription
                                  ? Icons.chat_bubble
                                  : Icons.graphic_eq,
                              isActive: appCtrl.agentScreenState ==
                                  AgentScreenState.transcription,
                              onTap: () => appCtrl.toggleAgentScreenMode(),
                            ),
                          ),

                          // Disconnect button
                          _buildControlButton(
                            icon: Icons.call_end,
                            isActive: false,
                            color: Colors.red,
                            onTap: () => ctx.read<AppCtrl>().disconnect(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    Color? color,
  }) {
    final buttonColor =
        color ?? (isActive ? const Color(0xFF005A7C) : const Color(0xFF4a4a4a));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

// App Layout Switcher
class AppLayoutSwitcher extends StatelessWidget {
  final bool isFront;
  final Widget Function(BuildContext context) frontBuilder;
  final Widget Function(BuildContext context) backBuilder;

  final Duration animationDuration;
  final Curve animationCurve;

  const AppLayoutSwitcher({
    super.key,
    this.isFront = true,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOutSine,
    required this.frontBuilder,
    required this.backBuilder,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              ignoring: isFront,
              child: AnimatedOpacity(
                opacity: isFront ? 0.0 : 1.0,
                duration: animationDuration,
                curve: animationCurve,
                child: backBuilder(context),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !isFront,
              child: AnimatedOpacity(
                opacity: isFront ? 1.0 : 0.0,
                duration: animationDuration,
                curve: animationCurve,
                child: frontBuilder(context),
              ),
            ),
          ),
        ],
      );
}
