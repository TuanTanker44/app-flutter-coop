import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app_flutter/pages/mini_player.dart';
import '../widgets/navigation.dart';
import '../widgets/sidebar.dart';
import '../widgets/mini_player.dart';
import '../pages/home_page.dart';
import '../pages/search_page.dart';
import '../pages/library_page.dart';
import '../pages/premium_page.dart';
import '../pages/player_page.dart';
import '../core/supabase_client.dart';

Map<String, dynamic>? currentUser;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final AudioPlayer _player = AudioPlayer();
  MusicItem? _currentSong;
  bool _isPlaying = false;
  late List<Widget> _pages;
  bool isLoadingAvatar = true;

  String userName = "Người dùng";
  String avatarUrl = "";

  @override
  void initState() {
    super.initState();

    // 🔹 Lắng nghe thay đổi đăng nhập của Supabase
    SupabaseManager.client.auth.onAuthStateChange.listen((event) {
      _loadUserData();
    });

    // 🔹 Load thông tin người dùng
    _loadUserData();

    // 🔹 Khởi tạo danh sách trang
    _pages = [
      const HomePage(),
      const SearchPage(),
      LibraryPage(onSongSelected: _playSong),
      const PremiumPage(),
    ];
  }

  // 🔹 Phát bài hát
  void _playSong(MusicItem song) async {
    setState(() {
      _currentSong = song;
    });

    try {
      await _player.setAsset(song.audioUrl);
      await _player.play();

      _player.playerStateStream.listen((state) {
        setState(() {
          _isPlaying = state.playing;
        });
      });
    } catch (e) {
      debugPrint("Lỗi phát nhạc: $e");
    }
  }

  // 🔹 Dừng / phát nhạc
  void _togglePlay() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  // 🔹 Mở trang phát nhạc đầy đủ
  void _openPlayerPage() {
    if (_currentSong == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerPage(
          title: _currentSong!.title,
          imageUrl: _currentSong!.imageUrl,
          audioUrl: _currentSong!.audioUrl,
          author: _currentSong!.author,
          existingPlayer: _player,
          onClose: () {
            setState(() {
              _currentSong = null;
            });
          },
        ),
      ),
    );
  }

  // 🔹 Load thông tin người dùng từ Supabase
  Future<void> _loadUserData() async {
    if (!mounted) return;

    final supabase = SupabaseManager.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
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
          publicUrl += "?v=${DateTime.now().millisecondsSinceEpoch}";
        }
      } catch (_) {}

      if (mounted) {
        if (publicUrl != null) {
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
  void dispose() {
    _player.dispose();
    super.dispose();
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

          // 🔹 Avatar mở Drawer
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

          // 🔹 Mini Player chung toàn app
          if (_currentSong != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: kBottomNavigationBarHeight,
              child: MiniPlayer(
                player: _player,
                currentSong: _currentSong,
                isPlaying: _isPlaying,
                onTogglePlay: _togglePlay,
                onTap: _openPlayerPage,
              ),
            ),
        ],
      ),
    );
  }
}
