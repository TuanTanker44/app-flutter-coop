import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import '../widgets/sidebar.dart';
import '../pages/home_page.dart';
import '../pages/search_page.dart';
import '../pages/library_page.dart';
import '../pages/premium_page.dart';

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
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: (_currentIndex != 3 && _currentIndex != 4)
          ? AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 18, // kích thước avatar
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
              ),
            );
          },
        ),
        title: const Text(
          "Spotify Clone",
          style: TextStyle(color: Colors.white),
        ),
      )
          : null,
      drawer: const Sidebar(),

      body: BottomNavBar(
        pages: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}


