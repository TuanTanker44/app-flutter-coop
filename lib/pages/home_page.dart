import 'package:flutter/material.dart';
import '../core/supabase_client.dart';
import './playlist_view_page.dart';
import '../widgets/music_block.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> playlists = [];
  bool isLoadingPlaylists = true;
  List<dynamic> historySongs = [];
  bool isLoadingHistory = true;
  bool isLoadingAvatar = true;
  String userName = "Người dùng";
  String avatarUrl = "assets/images/avatar.jpeg";


  bool isAllCategorySelected = true;
  bool isMusicCategorySelected = false;
  bool isMusicFollowingSelected = false;
  bool isPodcastsCategorySelected = false;
  bool isPodcastsFollowingSelected = false;

  @override
  void initState() {
    super.initState();
    fetchPlaylists();
    fetchListeningHistory();
  }

  Future<void> fetchPlaylists() async {
    try {
      final supabase = SupabaseManager.client;
      final response = await supabase.from('playlists').select().neq('name', 'Liked Songs').limit(8);

      setState(() {
        playlists = response;
        isLoadingPlaylists = false;
      });
    } catch (e) {
      debugPrint('Lỗi tải playlists: $e');
      setState(() {
        isLoadingPlaylists = false;
      });
    }
  }

  Future<void> fetchListeningHistory() async {
    try {
      final supabase = SupabaseManager.client;
      final user = supabase.auth.currentUser;
      print("User: $user");
      if (user == null) return;

      // Lấy danh sách song_id có thứ tự thời gian mới nhất
      final historyResponse = await supabase
          .from('listening_history')
          .select('song_id')
          .eq('user_id', user.id)
          .order('listened_at', ascending: false)
          .limit(10);

      if (historyResponse.isEmpty) {
        setState(() => isLoadingHistory = false);
        return;
      }

      final songIds = historyResponse.map((e) => e['song_id']).toList();

      // Lấy thông tin bài hát từ bảng songs
      final songs = await supabase
          .from('songs')
          .select('id, title, artist, duration, cover_url')
          .inFilter('id', songIds);

      setState(() {
        historySongs = songs;
        isLoadingHistory = false;
      });

    } catch (e) {
      debugPrint("Lỗi tải lịch sử nghe: $e");
      setState(() => isLoadingHistory = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==== DANH MỤC NÚT =====
              Container(
                child: Row(
                  children: [
                    GestureDetector(
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
                    SizedBox(width: 10),
                    // ====== Tất cả =======
                    TextButton(
                      style: ButtonStyle(
                        fixedSize: WidgetStateProperty.all(const Size(50, 25)),
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                        backgroundColor: WidgetStateProperty.all(
                          isAllCategorySelected ? const Color(0xFF1ED760) : const Color(0xFF282828),
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          isAllCategorySelected ? Colors.black : Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isAllCategorySelected = true;
                          isMusicCategorySelected = false;
                          isMusicFollowingSelected = false;
                          isPodcastsCategorySelected = false;
                          isPodcastsFollowingSelected = false;
                        });
                      },
                      child: const Text('Tất cả', style: TextStyle(fontSize: 12)),
                    ),

                    const SizedBox(width: 10),

                    // ====== Nhạc =======
                    Row(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            fixedSize: WidgetStateProperty.all(const Size(40, 25)),
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                            backgroundColor: WidgetStateProperty.all(
                              isMusicCategorySelected
                                  ? const Color(0xFF1ED760)
                                  : const Color(0xFF282828),
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              isMusicCategorySelected ? Colors.black : Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isAllCategorySelected = false;
                              isMusicCategorySelected = true;
                              isMusicFollowingSelected = false;
                              isPodcastsCategorySelected = false;
                              isPodcastsFollowingSelected = false;
                            });
                          },
                          child: const Text('Nhạc', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 5),
                        if (isMusicCategorySelected)
                          TextButton(
                            style: ButtonStyle(
                              fixedSize: WidgetStateProperty.all(const Size(100, 25)),
                              backgroundColor: WidgetStateProperty.all(
                                isMusicFollowingSelected
                                    ? const Color(0xFF19B350)
                                    : const Color(0xFF282828),
                              ),
                              foregroundColor: WidgetStateProperty.all(
                                isMusicFollowingSelected ? Colors.black : Colors.white,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isMusicFollowingSelected = !isMusicFollowingSelected;
                              });
                            },
                            child:
                            const Text('Đang theo dõi', style: TextStyle(fontSize: 12)),
                          ),
                      ],
                    ),

                    const SizedBox(width: 10),

                    // ====== Podcasts =======
                    Row(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            fixedSize: WidgetStateProperty.all(const Size(75, 25)),
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                            backgroundColor: WidgetStateProperty.all(
                              isPodcastsCategorySelected
                                  ? const Color(0xFF1ED760)
                                  : const Color(0xFF282828),
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              isPodcastsCategorySelected ? Colors.black : Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isAllCategorySelected = false;
                              isMusicCategorySelected = false;
                              isMusicFollowingSelected = false;
                              isPodcastsCategorySelected = true;
                              isPodcastsFollowingSelected = false;
                            });
                          },
                          child: const Text('Podcasts', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 5),
                        if (isPodcastsCategorySelected)
                          TextButton(
                            style: ButtonStyle(
                              fixedSize: WidgetStateProperty.all(const Size(100, 25)),
                              backgroundColor: WidgetStateProperty.all(
                                isPodcastsFollowingSelected
                                    ? const Color(0xFF19B350)
                                    : const Color(0xFF282828),
                              ),
                              foregroundColor: WidgetStateProperty.all(
                                isPodcastsFollowingSelected ? Colors.black : Colors.white,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isPodcastsFollowingSelected = !isPodcastsFollowingSelected;
                              });
                            },
                            child:
                            const Text('Đang theo dõi', style: TextStyle(fontSize: 12)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Trang chủ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // ==== PLAYLIST GRID ====
              if (isLoadingPlaylists)
                const Center(child: CircularProgressIndicator())
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final item = playlists[index];
                    final name = item['name'] ?? 'Không tên';
                    final imageUrl = item['cover_url'] ?? 'https://thubcoiluebblsmmbsjw.supabase.co/storage/v1/object/public/covers/playlists/playlist.jpeg';

                    return GestureDetector(
                      onTap: () async {
                        final supabase = SupabaseManager.client;

                        try {
                          // Lấy danh sách song_id từ playlist_songs
                          final playlistSongs = await supabase
                              .from('playlist_songs')
                              .select('song_id')
                              .eq('playlist_id', item['id']);

                          if (playlistSongs.isEmpty) {
                            // Không có bài hát nào trong playlist
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaylistViewPage(
                                  playlistName: name,
                                  coverUrl: imageUrl,
                                  songs: const [],
                                ),
                              ),
                            );
                            return;
                          }

                          // Trích danh sách song_id
                          final songIds = playlistSongs.map((ps) => ps['song_id']).toList();

                          // Lấy thông tin bài hát từ bảng songs theo song_id
                          final songs = await supabase
                              .from('songs')
                              .select('id, title, artist, duration, cover_url')
                              .inFilter('id', songIds);

                          // Mở trang PlaylistView
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaylistViewPage(
                                playlistName: name,
                                coverUrl: imageUrl,
                                songs: songs,
                              ),
                            ),
                          );
                        } catch (e) {
                          debugPrint('Lỗi tải bài hát cho playlist: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Không thể tải bài hát cho playlist này')),
                          );
                        }
                      },

                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF282828),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                image: imageUrl != null
                                    ? DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: imageUrl == null
                                  ? const Icon(Icons.music_note, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 20),
              const Text(
                'Nghe lại',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              if (isLoadingHistory)
                const Center(child: CircularProgressIndicator())
              else if (historySongs.isEmpty)
                const Text(
                  "Chưa có lịch sử nghe",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: historySongs.length,
                  itemBuilder: (context, index) {
                    final song = historySongs[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: MusicBlock(
                        songId: song['id'],
                        title: song['title'] ?? 'Untitled',
                        artist: song['artist'] ?? 'Unknown Artist',
                        coverUrl: song['cover_url'],
                        duration: Duration(seconds: song['duration'] ?? 0),
                        onPlay: () {
                          // TODO: mở player
                          debugPrint("Play: ${song['title']}");
                        },
                        onFavorite: () {
                          debugPrint("Favorite: ${song['title']}");
                        },
                        onMore: () {
                          debugPrint("More options for: ${song['title']}");
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
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

