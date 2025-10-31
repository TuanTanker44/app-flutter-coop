import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import '../widgets/sidebar.dart';
import '../pages/home_page.dart';
import '../pages/search_page.dart';
import '../pages/library_page.dart';
import '../pages/premium_page.dart';
import '../main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    SearchPage(),
    LibraryPage(),
    PremiumPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final userName = currentUser?['name'] ?? 'Người dùng';
    return Scaffold(
      backgroundColor: Colors.black,

      drawer: const Sidebar(),

      body: Stack(
        children: [
          BottomNavBar(
            pages: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),

          // 🟦 Avatar cố định thay cho AppBar
          if (_currentIndex != 3 && _currentIndex != 4)
            Positioned(
              top: 20,
              left: 16,
              child: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage('assets/images/avatar.jpg'),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}


