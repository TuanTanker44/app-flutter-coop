import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../pages/player_page.dart';
import '../pages/library_page.dart'; // để dùng MusicItem

class MiniPlayer extends StatelessWidget {
  final AudioPlayer player;
  final MusicItem? currentSong;
  final bool isPlaying;
  final VoidCallback onTogglePlay;
  final VoidCallback onTap;

  const MiniPlayer({
    super.key,
    required this.player,
    required this.currentSong,
    required this.isPlaying,
    required this.onTogglePlay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (currentSong == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: currentSong!.imageUrl.startsWith("http")
                  ? Image.network(
                      currentSong!.imageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      currentSong!.imageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                currentSong!.title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: onTogglePlay,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
