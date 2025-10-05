import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import '../pages/home_page.dart';
import '../pages/search_page.dart';
import '../pages/library_page.dart';
import '../pages/premium_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BottomNavBar(
        pages: const [
          HomePage(),
          SearchPage(),
          LibraryPage(),
          PremiumPage(),
        ],
      ),
    );
  }
}
