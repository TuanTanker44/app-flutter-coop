import 'package:flutter/material.dart';
import '../pages/player_page.dart';

const Color kPrimaryColor = Color(0xFF19B350);
const Color kBackgroundColor = Colors.black;

class MusicBlock extends StatefulWidget {
  final String title;
  final String artist;
  final String? coverUrl;
  final String? audioUrl;
  final Duration duration;
  final VoidCallback? onPlay;
  final VoidCallback? onFavorite;
  final VoidCallback? onMore;

  const MusicBlock({
    super.key,
    required this.title,
    required this.artist,
    this.coverUrl,
    this.audioUrl,
    required this.duration,
    this.onPlay,
    this.onFavorite,
    this.onMore,
  });

  @override
  State<MusicBlock> createState() => _MusicBlockState();
}

class _MusicBlockState extends State<MusicBlock> {
  bool isFavorite = false;

  String _formatDuration(Duration d) {
    final min = d.inMinutes;
    final sec = d.inSeconds % 60;
    final secStr = sec < 10 ? '0$sec' : '$sec';
    return '$min:$secStr';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Ảnh bìa bài hát
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: widget.coverUrl != null
                ? Image.network(
              widget.coverUrl!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholderCover(),
            )
                : _placeholderCover(),
          ),
          const SizedBox(width: 12),

          // Thông tin bài hát
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlayerPage(
                      title: widget.title,
                      imageUrl: widget.coverUrl ?? "",
                      audioUrl: widget.audioUrl ?? "",
                      author: widget.artist,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.artist,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDuration(widget.duration),
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Nút yêu thích
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? kPrimaryColor : Colors.white70,
            ),
            onPressed: () {
              setState(() => isFavorite = !isFavorite);
              widget.onFavorite?.call();
            },
          ),

          // Nút tuỳ chọn thêm
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: widget.onMore,
          ),
        ],
      ),
    );
  }

  Widget _placeholderCover() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.white12,
      child: const Icon(Icons.music_note, color: Colors.white54),
    );
  }
}
