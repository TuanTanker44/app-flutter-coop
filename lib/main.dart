import 'package:flutter/material.dart';
import 'package:music_app_flutter/pages/login_page.dart';
import 'package:music_app_flutter/pages/register_page.dart';
import 'screens/main_screen.dart';
import 'core/supabase_client.dart';

Map<String, dynamic>? currentUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseManager.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.green,
      ),
      home: _buildHome(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MainScreen(),
      },
    );
  }
  Widget _buildHome() {
    if (currentUser == null) {
      return const LoginPage();
    } else {
      return const MainScreen();
    }
  }
}