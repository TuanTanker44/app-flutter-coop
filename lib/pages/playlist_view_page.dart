import 'package:flutter/material.dart';
import '../widgets/music_block.dart';

const Color kPrimaryColor = Color(0xFF19B350);
const Color kBackgroundColor = Colors.black;

class PlaylistViewPage extends StatelessWidget {
  final String playlistName;
  final String coverUrl;
  final List<Map<String, dynamic>> songs;
  final void Function(Map<String, dynamic> song)? onSongSelected;

  const PlaylistViewPage({
    super.key,
    required this.playlistName,
    required this.coverUrl,
    required this.songs,
    this.onSongSelected,
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
                    songId: song['id'],
                    title: song['title'] ?? 'Unknown',
                    artist: song['artist'] ?? 'Unknown Artist',
                    coverUrl: song['cover_url'],
                    audioUrl: song['audio_url'], // nếu có audio_url trong DB
                    duration: Duration(seconds: song['duration'] ?? 200),
                    onFavorite: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('❤️ Đã thêm vào yêu thích: ${song['title']}')),
                      );
                    },
                    onMore: () {
                      // Có thể hiển thị popup tuỳ chọn khác ở đây
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
}
