import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import './playlist_view_page.dart';
import '../core/supabase_client.dart';

class MusicItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String audioUrl;
  final String author;

  MusicItem({
    required this.imageUrl,
    required this.subtitle,
    required this.title,
    required this.audioUrl,
    required this.author,
  });
}

class LibraryPage extends StatefulWidget {
  final Function(MusicItem)? onSongSelected;
  const LibraryPage({super.key, this.onSongSelected});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String _selectedFilter = "Playlist";
  MusicItem? _currentSong;
  AudioPlayer? _player;
  bool _isPlaying = false;
  final user = SupabaseManager.client.auth.currentUser;

  // ✅ Playlist mẫu
  List<MusicItem> playlists = [
    MusicItem(
      title: "Nhạc trẻ hot nhất",
      subtitle: "Danh sách phát • V-Pop",
      imageUrl: "assets/images/10-mat-1-con-khong.jpg",
      audioUrl: "assets/audio/10 Mất 1 Còn Không (Td Remix).mp3",
      author: "tac gia 1",
    ),
    MusicItem(
      title: "Lofi Chill",
      subtitle: "Danh sách phát • Relax",
      imageUrl: "assets/images/de-anh-luong-thien.jpg",
      audioUrl: "assets/audio/Để Anh Lương Thiện (Huy PT Remix).mp3",
      author: "tac gia 2",
    ),
    MusicItem(
      title: "Workout Playlist",
      subtitle: "Danh sách phát • EDM",
      imageUrl: "assets/images/chang-phai-tinh-dau-sao-dau-den-the.jpg",
      audioUrl: "assets/audio/chẳng phải tình đầu sao đau đến thế.mp3",
      author: "tac gia 3",
    ),
  ];

  // ✅ Nghệ sĩ mẫu
  List<MusicItem> dsnghsi = [
    MusicItem(
      title: "Sơn Tùng M-TP",
      subtitle: "Pop, V-Pop",
      imageUrl: "assets/images/maxresdefault.jpg",
      audioUrl: "",
      author: "",
    ),
    MusicItem(
      title: "Đen Vâu",
      subtitle: "Rap, Hip-hop",
      imageUrl: "assets/images/Son-Tung-MTP2.jpg",
      audioUrl: "",
      author: "",
    ),
  ];

  // ✅ Album mẫu
  List<MusicItem> dsalbum = [
    MusicItem(
      title: "Chúng Ta Của Hiện Tại",
      subtitle: "Sơn Tùng M-TP • 2020",
      imageUrl: "https://i.scdn.co/image/ab67616d0000b2735f68a9a5b123abcfa89342b8",
      audioUrl: "",
      author: "",
    ),
    MusicItem(
      title: "99%",
      subtitle: "Đức Phúc • 2022",
      imageUrl: "https://i.scdn.co/image/ab67616d0000b273ddfba54a2f8d481cbb123a7c",
      audioUrl: "",
      author: "",
    ),
  ];

  void _onFilterSelected(String filter) {
    setState(() => _selectedFilter = filter);
  }

  void _addPlaylist() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController titleController = TextEditingController();
        TextEditingController subtitleController = TextEditingController();

        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text("them play list", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: titleController),
                TextField(controller: subtitleController),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Huy", style: TextStyle(color: Colors.redAccent)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Them", style: TextStyle(color: Colors.greenAccent)),
              onPressed: () {
                setState(() {
                  playlists.add(
                    MusicItem(
                      title: titleController.text.trim(),
                      imageUrl: "",
                      subtitle: "",
                      audioUrl: "",
                      author: "",
                    ),
                  );
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.playlist_add, color: Colors.white),
              title: const Text("Thêm Playlist", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _addPlaylist();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.white),
              title: const Text("Thêm Nghệ sĩ", style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.album, color: Colors.white),
              title: const Text("Thêm Album", style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  int _getItemCount() {
    if (_selectedFilter == "Playlist") return playlists.length;
    if (_selectedFilter == "Nghệ sĩ") return dsnghsi.length;
    if (_selectedFilter == "Album") return dsalbum.length;
    return 0;
  }

  MusicItem _hienThiTheoDanhMuc(String f, int i) {
    if (f == "Playlist") return playlists[i];
    if (f == "Nghệ sĩ") return dsnghsi[i];
    if (f == "Album") return dsalbum[i];
    return MusicItem(
      imageUrl: "",
      subtitle: "",
      title: "khong co du lieu",
      audioUrl: "",
      author: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ✅ Header
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: const EdgeInsets.only(left: 55, top: 10),
              child: const Text(
                'Thư Viện',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(children: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchPagelib(selectedFilter: _selectedFilter),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {},
              ),
            ]),
          ]),

          const SizedBox(height: 16),

          // ✅ Filter chips
          Row(children: [
            FilterChip(
              label: const Text('Playlist'),
              selected: _selectedFilter == "Playlist",
              labelStyle: const TextStyle(color: Colors.white),
              selectedColor: Colors.blue,
              backgroundColor: const Color(0xFF282828),
              onSelected: (_) => _onFilterSelected("Playlist"),
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Nghệ sĩ'),
              selected: _selectedFilter == "Nghệ sĩ",
              labelStyle: const TextStyle(color: Colors.white),
              selectedColor: Colors.blue,
              backgroundColor: const Color(0xFF282828),
              onSelected: (_) => _onFilterSelected("Nghệ sĩ"),
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Album'),
              selected: _selectedFilter == "Album",
              labelStyle: const TextStyle(color: Colors.white),
              selectedColor: Colors.blue,
              backgroundColor: const Color(0xFF282828),
              onSelected: (_) => _onFilterSelected("Album"),
            ),
          ]),

          const SizedBox(height: 16),

          Expanded(
            child: ListView(children: [
              // ✅ Danh sách theo mục
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _getItemCount(),
                itemBuilder: (context, index) {
                  final item = _hienThiTheoDanhMuc(_selectedFilter, index);
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          color: Colors.grey[800],
                          child: const Icon(Icons.music_note,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    title: Text(item.title,
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text(item.subtitle,
                        style: TextStyle(color: Colors.grey[600])),
                    onTap: () {
                      if (item.audioUrl.isNotEmpty) {
                        widget.onSongSelected?.call(item);
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 20),
              const Text(
                "Playlist của bạn",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(height: 10),

              // ✅ Future - playlist user
              FutureBuilder(
                future: SupabaseManager.client
                    .from('playlists')
                    .select('*')
                    .eq('user_id', user!.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                          child: CircularProgressIndicator(
                              color: Colors.white)),
                    );
                  }

                  final data = snapshot.data as List<dynamic>;
                  if (data.isEmpty) {
                    return const Text("Chưa có playlist nào",
                        style: TextStyle(color: Colors.grey));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () async {
                            final supabase = SupabaseManager.client;

                            try {
                              final playlistSongs = await supabase
                                  .from('playlist_songs')
                                  .select('song_id')
                                  .eq('playlist_id', item['id']);

                              if (playlistSongs.isEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlaylistViewPage(
                                      playlistName: item['name'],
                                      coverUrl: item['cover_url'] ??
                                          'https://thubcoiluebblsmmbsjw.supabase.co/storage/v1/object/public/covers/playlists/playlist.jpeg',
                                      songs: const [],
                                    ),
                                  ),
                                );
                                return;
                              }

                              final songIds =
                              playlistSongs.map((ps) => ps['song_id']).toList();

                              final songs = await supabase.from('songs').select(
                                'id, title, artist, duration, cover_url',
                              ).inFilter('id', songIds);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PlaylistViewPage(
                                    playlistName: item['name'],
                                    coverUrl: item['cover_url'] ??
                                        'https://thubcoiluebblsmmbsjw.supabase.co/storage/v1/object/public/covers/playlists/playlist.jpeg',
                                    songs: songs,
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Không thể tải bài hát trong playlist',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  item['cover_url'] ??
                                      'https://thubcoiluebblsmmbsjw.supabase.co/storage/v1/object/public/covers/playlists/playlist.jpeg',
                                  width: 65,
                                  height: 65,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 65,
                                    height: 65,
                                    color: Colors.grey[800],
                                    child: const Icon(Icons.music_note, color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Playlist • ${item['song_count']} bài hát",
                                        style:
                                        TextStyle(color: Colors.grey[500], fontSize: 13),
                                      )
                                    ]),
                              ),
                              const Icon(Icons.chevron_right, color: Colors.white54),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ✅ Trang Search lib
class SearchPagelib extends StatefulWidget {
  final String selectedFilter;
  const SearchPagelib({super.key, required this.selectedFilter});

  @override
  State<SearchPagelib> createState() => _SearchPagelibState();
}

class _SearchPagelibState extends State<SearchPagelib> {
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Tìm kiếm trong ${widget.selectedFilter}",
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => _searchText = value),
        ),
      ),
      body: Center(
        child: Text(
          _searchText.isEmpty
              ? "Nhập để tìm kiếm trong ${widget.selectedFilter}"
              : "ket qua cho $_searchText",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
