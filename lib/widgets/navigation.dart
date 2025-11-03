import 'package:flutter/material.dart';
import '../core/supabase_client.dart';

class BottomNavBar extends StatefulWidget {
  final List<Widget> pages;
  final Function(int)? onPageChanged;

  const BottomNavBar({
    super.key,
    required this.pages,
    required this.onPageChanged,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: widget.pages,
          ),
        ),
        BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            // Nếu là nút "Tạo" (chỗ index 4), mở menu tạo
            if (index == 4) {
              _showCreateDialog(context);
              return;
            }

            setState(() {
              _selectedIndex = index;
              widget.onPageChanged?.call(index);
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF2C2C2C),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Tìm kiếm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music_outlined),
              activeIcon: Icon(Icons.library_music),
              label: 'Thư viện',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.workspace_premium_outlined),
              activeIcon: Icon(Icons.workspace_premium),
              label: 'Premium',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_outlined),
              activeIcon: Icon(Icons.cancel_outlined),
              label: 'Tạo',
            ),
          ],
        ),
      ],
    );
  }

  void _showCreateDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282828),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.playlist_add, color: Colors.white),
              title: const Text(
                'Tạo playlist',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
                _showCreatePlaylistDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_outlined, color: Colors.white),
              title: const Text(
                'Tạo thư mục playlist',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
                // hiện tại không implement tạo thư mục — có thể mở dialog tương tự
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chức năng chưa được hỗ trợ')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final supabase = SupabaseManager.client;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Nhập tên playlist',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Playlist mới',
            hintStyle: TextStyle(color: Colors.grey[600]),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy", style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              Navigator.pop(context); // đóng dialog

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập tên playlist')),
                );
                return;
              }

              final session = supabase.auth.currentSession;
              final user = session?.user;

              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bạn chưa đăng nhập')),
                );
                return;
              }

              try {
                final insertRes = await supabase.from('playlists').insert({
                  'name': name,
                  'user_id': user.id,
                  'song_count': 0,
                }).select().maybeSingle();

                if (insertRes == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tạo playlist thất bại')),
                  );
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Playlist "$name" đã được tạo!')),
                );

                // chuyển sang tab Thư viện
                setState(() {
                  _selectedIndex = 2;
                });
                widget.onPageChanged?.call(2);
              } catch (e) {
                debugPrint("Lỗi tạo playlist: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lỗi kết nối Supabase')),
                );
              }
            }
            ,
            child: const Text("Tạo", style: TextStyle(color: Colors.greenAccent)),
          ),
        ],
      ),
    );
  }
}
