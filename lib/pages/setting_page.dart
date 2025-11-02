import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // 🔹 Lưu trạng thái của các switch
  final Map<String, bool> _settings = {
    'dataSaver': false,
    'autoplay': true,
    'updateNotifications': true,
    'emailNotifications': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          'Cài đặt và riêng tư',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          const SizedBox(height: 10),

          _buildSectionTitle("Tài khoản"),
          _buildSettingTile(
            icon: Icons.person_outline,
            title: "Xem hồ sơ",
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          _buildSettingTile(
            icon: Icons.lock_outline,
            title: "Đổi mật khẩu",
            onTap: () {
              // TODO: Điều hướng đến trang đổi mật khẩu
            },
          ),
          const Divider(color: Colors.grey),

          _buildSectionTitle("Phát nhạc"),
          _buildSwitchTile(
            keyName: 'dataSaver',
            icon: Icons.wifi_tethering,
            title: "Tiết kiệm dữ liệu",
            subtitle: "Giảm chất lượng âm thanh khi phát qua mạng di động",
          ),
          _buildSwitchTile(
            keyName: 'autoplay',
            icon: Icons.play_circle_outline,
            title: "Tự động phát nhạc liên quan",
            subtitle: "Phát nhạc tương tự sau khi danh sách kết thúc",
          ),
          const Divider(color: Colors.grey),

          _buildSectionTitle("Thông báo"),
          _buildSwitchTile(
            keyName: 'updateNotifications',
            icon: Icons.notifications_outlined,
            title: "Thông báo cập nhật",
          ),
          _buildSwitchTile(
            keyName: 'emailNotifications',
            icon: Icons.email_outlined,
            title: "Email từ Spotify",
          ),
          const Divider(color: Colors.grey),

          _buildSectionTitle("Giới thiệu"),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: "Giới thiệu Spotify Clone",
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.logout,
            title: "Đăng xuất",
            color: Colors.redAccent,
            onTap: () {
              // TODO: Gọi Supabase.auth.signOut();
            },
          ),

          const SizedBox(height: 30),
          Center(
            child: Text(
              "Phiên bản 1.0.0",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Tiêu đề nhóm
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1ED760),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 🔹 Tile cài đặt bình thường
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    Color color = Colors.white,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13))
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }

  // 🔹 Tile có công tắc giữ trạng thái
  Widget _buildSwitchTile({
    required String keyName,
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return SwitchListTile(
      activeColor: const Color(0xFF1ED760),
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey.shade800,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13))
          : null,
      secondary: Icon(icon, color: Colors.white),
      value: _settings[keyName] ?? false,
      onChanged: (v) {
        setState(() {
          _settings[keyName] = v;
        });
      },
    );
  }
}
