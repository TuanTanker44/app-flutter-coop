import 'package:flutter/material.dart';
import '../core/supabase_client.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  String email = '';
  String avatarUrl = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final supabase = SupabaseManager.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    final profile = await supabase
        .from('users')
        .select('username')
        .eq('id', user.id)
        .maybeSingle();

    setState(() {
      username = profile?['username'] ?? 'Người dùng Spotify';
      email = user.email ?? 'Không có email';
      avatarUrl =
          supabase.storage.from('avatars').getPublicUrl('${user.id}.jpeg');
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Hồ sơ",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              // Avatar
              CircleAvatar(
                radius: 60,
                backgroundImage: avatarUrl.startsWith("http")
                    ? NetworkImage(avatarUrl)
                    : const AssetImage("assets/images/avatar.jpeg"),
              ),

              const SizedBox(height: 16),

              // Username
              Text(
                username,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              // Email
              Text(
                email,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 18),

              // Row Buttons: Edit - Share - Options
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: Mở màn chỉnh sửa hồ sơ
                    },
                    child: const Text(
                      "Chỉnh sửa hồ sơ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Chia sẻ profile
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Menu options
                    },
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Logout Button
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () async {
                    await SupabaseManager.client.auth.signOut();
                    if (!context.mounted) return;
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Đăng xuất"),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
