import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String username = "Người dùng Spotify";
  String avatarPath = "assets/images/avatar.jpg";

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
              color: Color(0xFF121212),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(avatarPath),
                  ),
                  const SizedBox(width: 12),
                  // Tên + nút "Xem hồ sơ"
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          // TODO: đi đến trang hồ sơ
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
                      // TODO: xử lý thêm tài khoản
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.library_add, color: Colors.white),
                    title: const Text("Nội dung mới",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: xử lý nội dung mới
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.white),
                    title: const Text("Gần đây",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: xử lý gần đây
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: const Text("Cài đặt và riêng tư",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
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
