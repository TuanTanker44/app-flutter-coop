import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import '../widgets/sidebar.dart';
import '../pages/home_page.dart';
import '../pages/search_page.dart';
import '../pages/library_page.dart';
import '../pages/premium_page.dart';
import '../core/supabase_client.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex = 0;
  bool isLoadingAvatar = true;

  String userName = "Người dùng";
  String avatarUrl = "";

  final List<Widget> _pages = const [
    HomePage(),
    SearchPage(),
    LibraryPage(),
    PremiumPage(),
  ];

  @override
  @override
  void initState() {
    super.initState();
    SupabaseManager.client.auth.onAuthStateChange.listen((event) {
      _loadUserData();
    });
    _loadUserData();
  }


  Future<void> _loadUserData() async {
    if (!mounted) return;

    final supabase = SupabaseManager.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      // Lấy tên user từ bảng users
      final response = await supabase
          .from('users')
          .select('username')
          .eq('id', user.id)
          .maybeSingle();

      final bucket = supabase.storage.from('avatars');
      final fileName = '${user.id}.jpeg';

      String? publicUrl;

      try {
        final files = await bucket.list(path: '');
        bool exists = files.any((f) => f.name == fileName);

        if (exists) {
          publicUrl = bucket.getPublicUrl(fileName);

          // ✅ Cache busting để load avatar mới nhất
          publicUrl += "?v=${DateTime.now().millisecondsSinceEpoch}";
        }
      } catch (_) {}

      if (mounted) {
        if (publicUrl != null) {
          // Bắt Flutter xoá cache cho URL cũ
          PaintingBinding.instance.imageCache.clear();
          PaintingBinding.instance.imageCache.clearLiveImages();
        }
        setState(() {
          userName = response?['username'] ?? "Người dùng";
          avatarUrl = publicUrl ?? "assets/images/avatar.jpeg";
          isLoadingAvatar = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const Sidebar(),

      body: Stack(
        children: [
          BottomNavBar(
            pages: _pages,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
          ),

          // Avatar mở Drawer
          if (_currentIndex != 3 && _currentIndex != 4)
            Positioned(
              top: 20,
              left: 16,
              child: Builder(
                builder: (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade900,
                    child: ClipOval(
                      child: isLoadingAvatar
                          ? Image.asset(
                        "assets/images/avatar.jpeg",
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        avatarUrl,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          "assets/images/avatar.jpeg",
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                ),
              ),
            ),
        ],
      ),
    );
  }
}
