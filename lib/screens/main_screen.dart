import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const SearchPage(),
      LibraryPage(onSongSelected: _playSong), // 🟢 gọi callback
      const PremiumPage(),
    ];
  }

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

  void _togglePlay() {
    setState(() {
      if (_isPlaying) {
        _player.pause();
      } else {
        _player.play();
      }
    });
  }

  void _openPlayerPage() {
    if (_currentSong == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerPage(
          title: _currentSong!.title,
          imageUrl: _currentSong!.imageUrl,
          audioUrl: _currentSong!.audioUrl,
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

          // Avatar
          if (_currentIndex != 3 && _currentIndex != 4)
            Positioned(
              top: 20,
              left: 16,
              child: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage('assets/images/avatar.jpg'),
                    ),
                  );
                },
              ),
            ),

          // 🟩 Mini Player chung toàn app
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
