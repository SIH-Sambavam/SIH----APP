import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/dashboard_screen.dart';
import 'screens/fish_info_screen.dart';
import 'screens/voice_assistant_screen.dart';
import 'screens/chat_assistant_screen.dart';
import 'services/permission_helper.dart';

// Main function to run the app
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    // Try different paths for .env file
    await dotenv.load(fileName: ".env");
    debugPrint("Environment variables loaded successfully from .env");
  } catch (e) {
    debugPrint("Could not load .env file: $e");
    debugPrint(
        "This is normal for web deployment - using cloud token API instead");
  }

  runApp(const BlueGuardApp());
}

// Root widget of the application
class BlueGuardApp extends StatelessWidget {
  const BlueGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlueGuard',
      theme: ThemeData(
        // Define the overall theme of the app
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(
          0xFFF0F4F8,
        ), // Light grey-blue background
        textTheme: const TextTheme(
          // Define text styles for consistency
          bodyLarge: TextStyle(color: Color(0xFF333333)),
          bodyMedium: TextStyle(color: Color(0xFF555555)),
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF005A7C),
          ),
        ),
        appBarTheme: const AppBarTheme(
          // Style for all AppBars
          backgroundColor: Color(0xFF00799F),
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          // Style for the bottom navigation bar
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF00799F),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
      debugShowCheckedModeBanner: false, // Hide the debug banner
      home: const MainScreen(),
    );
  }
}

// This widget manages the main screens with a bottom navigation bar
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // State variable to track the selected tab

  @override
  void initState() {
    super.initState();
    // Request permissions when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PermissionHelper.requestRequiredPermissions(context);
    });
  }

  // List of the screens to be displayed
  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    const FishInfoScreen(),
    const VoiceAssistantScreen(),
    const ChatAssistantScreen(),
  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(
          _selectedIndex,
        ), // Show the selected screen
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensure all tabs are visible
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phishing_outlined),
            activeIcon: Icon(Icons.phishing),
            label: 'Fish Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic_none),
            activeIcon: Icon(Icons.mic),
            label: 'Voice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_outlined),
            activeIcon: Icon(Icons.psychology),
            label: 'Chat AI',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Call the handler on tap
      ),
    );
  }
}
