import 'package:flutter/material.dart';
import '../pages/player_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color kPrimaryColor = Color(0xFF19B350);
const Color kBackgroundColor = Colors.black;

class MusicBlock extends StatefulWidget {
  final int songId;
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
    required this.songId,
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
  late int likedPlaylistId;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _initFavorite();
  }

  Future<void> _initFavorite() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    // Lấy playlist "Liked Songs", nếu chưa có → tạo mới
    final playlistRes = await supabase
        .from('playlists')
        .select('id')
        .eq('user_id', user.id)
        .eq('name', 'Liked Songs')
        .maybeSingle();

    if (playlistRes != null) {
      likedPlaylistId = (playlistRes['id'] as num).toInt();
    } else {
      final insertRes = await supabase.from('playlists').insert({
        'name': 'Liked Songs',
        'user_id': user.id,
        'song_count': 0,
        'cover_url': 'https://thubcoiluebblsmmbsjw.supabase.co/storage/v1/object/public/covers/playlists/liked_songs.jpeg'
      }).select().maybeSingle();

      likedPlaylistId = (insertRes!['id'] as num).toInt();
    }

    // Kiểm tra xem bài hát đã nằm trong playlist_songs chưa
    final exists = await supabase
        .from('playlist_songs')
        .select()
        .eq('playlist_id', likedPlaylistId)
        .eq('song_id', widget.songId)
        .maybeSingle();

    setState(() {
      isFavorite = exists != null;
    });
  }

  Future<void> _toggleFavorite() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    if (!isFavorite) {
      // Thêm bài hát
      await supabase.from('playlist_songs').insert({
        'playlist_id': likedPlaylistId,
        'song_id': widget.songId,
      });

      // Cập nhật song_count
      final playlist = await supabase
          .from('playlists')
          .select('song_count')
          .eq('id', likedPlaylistId)
          .maybeSingle();
      final currentCount = (playlist?['song_count'] as int?) ?? 0;

      await supabase.from('playlists').update({
        'song_count': currentCount + 1,
      }).eq('id', likedPlaylistId);

      setState(() => isFavorite = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã thêm vào Liked Songs: ${widget.title}')),
      );
    } else {
      // Xóa bài hát
      await supabase.from('playlist_songs').delete()
          .eq('playlist_id', likedPlaylistId)
          .eq('song_id', widget.songId);

      // Giảm song_count
      final playlist = await supabase
          .from('playlists')
          .select('song_count')
          .eq('id', likedPlaylistId)
          .maybeSingle();
      final currentCount = (playlist?['song_count'] as int?) ?? 0;
      final newCount = currentCount > 0 ? currentCount - 1 : 0;

      await supabase.from('playlists').update({
        'song_count': newCount,
      }).eq('id', likedPlaylistId);

      setState(() => isFavorite = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xoá khỏi Liked Songs: ${widget.title}')),
      );
    }
  }

  Future<void> _showAddToPlaylist() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final playlists = await supabase
        .from('playlists')
        .select('id, name')
        .eq('user_id', user.id)
        .neq('name', 'Liked Songs');

    if (playlists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn chưa có playlist nào khác')),
      );
      return;
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          maxChildSize: 0.9,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          expand: false,
          builder: (context, scrollController) {
            return ListView.builder(
              controller: scrollController,
              itemCount: playlists.length,
              itemBuilder: (_, index) {
                final playlist = playlists[index];

                return ListTile(
                  leading: const Icon(Icons.playlist_add, color: Colors.white),
                  title: Text(
                    playlist['name'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    final int playlistId = (playlist['id'] as num).toInt();

                    await supabase.from('playlist_songs').insert({
                      'playlist_id': playlistId,
                      'song_id': widget.songId,
                    });

                    final res = await supabase
                        .from('playlists')
                        .select('song_count')
                        .eq('id', playlist['id'])
                        .maybeSingle();

                    final currentCount = (res?['song_count'] as int?) ?? 0;

                    await supabase.from('playlists').update({
                      'song_count': currentCount + 1,
                    }).eq('id', playlist['id']);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã thêm vào playlist: ${playlist['name']}')),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow, color: Colors.white),
              title: const Text('Phát bài hát', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _openPlayer();
              },
            ),
            ListTile(
              leading: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              title: Text(
                isFavorite ? 'Xoá khỏi yêu thích' : 'Thêm vào yêu thích',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _toggleFavorite();
                widget.onFavorite?.call();
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add, color: Colors.white),
              title: const Text('Thêm vào playlist khác', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showAddToPlaylist();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openPlayer() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      await supabase.from('listening_history').upsert({
        'user_id': user.id,
        'song_id': widget.songId,
      });
    }

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
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes;
    final sec = d.inSeconds % 60;
    final secStr = sec < 10 ? '0$sec' : '$sec';
    return '$min:$secStr';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openPlayer,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
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
            Expanded(
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
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? kPrimaryColor : Colors.white70,
              ),
              onPressed: _toggleFavorite,
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white70),
              onPressed: _showOptions,
            ),
          ],
        ),
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
