import 'package:flutter/material.dart';
import '../core/supabase_client.dart';
import 'screens/main_screen.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../screens/profile_screen.dart';
import '../pages/recent_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Supabase
  await SupabaseManager.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = SupabaseManager.client;
    final currentUser = supabase.auth.currentUser;

    return MaterialApp(
      title: 'Spotify Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.green,
      ),

      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => StreamBuilder(
          stream: SupabaseManager.client.auth.onAuthStateChange,
          builder: (context, snapshot) {
            final session = snapshot.data?.session;

            if (session == null) {
              return const LoginPage();
            }

            return const MainScreen();
          }),
        '/profile': (context) => const ProfileScreen(),
        '/recent': (context) => const RecentPage(),
      },

      // ✅ Trang khởi động tuỳ theo trạng thái đăng nhập
      initialRoute: currentUser == null ? '/login' : '/home',
    );
  }
}
