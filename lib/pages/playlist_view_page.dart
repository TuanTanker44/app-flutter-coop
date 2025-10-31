import 'package:flutter/material.dart';
import '../widgets/music_block.dart';

const Color kPrimaryColor = Color(0xFF19B350);
const Color kBackgroundColor = Colors.black;

class PlaylistViewPage extends StatelessWidget {
  final String playlistName;
  final String coverUrl;
  final List<Map<String, dynamic>> songs;

  const PlaylistViewPage({
    super.key,
    required this.playlistName,
    required this.coverUrl,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          playlistName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Ảnh bìa playlist
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(coverUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.4),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(16),
              child: Text(
                playlistName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Danh sách bài hát
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: MusicBlock(
                    title: song['title'] ?? 'Unknown',
                    artist: song['artist'] ?? 'Unknown Artist',
                    duration: Duration(seconds: song['duration'] ?? 200),
                    coverUrl: song['cover_url'],
                    onPlay: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('🎵 Đang phát: ${song['title']}')),
                      );
                    },
                    onFavorite: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('❤️ Đã thêm vào yêu thích: ${song['title']}')),
                      );
                    },
                    onMore: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.black87,
                        builder: (context) => _buildSongOptions(context, song),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongOptions(BuildContext context, Map<String, dynamic> song) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.play_arrow, color: Colors.white),
            title: const Text('Phát bài hát', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border, color: Colors.white),
            title: const Text('Thêm vào yêu thích', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.playlist_add, color: Colors.white),
            title: const Text('Thêm vào playlist khác', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
