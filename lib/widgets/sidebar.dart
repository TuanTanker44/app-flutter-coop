import 'package:flutter/material.dart';
import '../core/supabase_client.dart';
import '../pages/feed_page.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String username = '';
  String avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final supabase = SupabaseManager.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      // Lấy dữ liệu user từ bảng "profiles" (nếu bạn có bảng này)
      final response = await supabase
          .from('users')
          .select('username')
          .eq('id', user.id)
          .maybeSingle();

      setState(() {
        username = response?['username'] ?? 'Người dùng Spotify';

        avatarUrl = supabase.storage
            .from('avatars')
            .getPublicUrl('${user.id}.jpeg');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF121212),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: avatarUrl.startsWith('http')
                        ? NetworkImage(avatarUrl)
                        : AssetImage(avatarUrl) as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  // Tên + nút "Xem hồ sơ"
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/profile');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 24),
                        ),
                        child: const Text(
                          "Xem hồ sơ",
                          style: TextStyle(color: Color(0xFF1ED760)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
              height: 1,
              thickness: 0.5,
            ),
            // Body
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_add, color: Colors.white),
                    title: const Text("Thêm tài khoản",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.newspaper, color: Colors.white),
                    title: const Text("Nội dung mới",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context); // đóng Drawer trước
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.white),
                    title: const Text("Gần đây",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/recent');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: const Text("Cài đặt và riêng tư",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/settings');
                      // TODO: xử lý cài đặt
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
