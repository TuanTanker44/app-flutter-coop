import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String audioUrl;

  MusicItem({
    required this.imageUrl,
    required this.subtitle,
    required this.title ,
    required this.audioUrl
  });
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  // State quản lý filter
  String _selectedFilter = "Playlist";
  MusicItem? _currentSong;
  AudioPlayer? _player;
  bool _isPlaying = false;

// State quản lý danh sách (sau này có thể fetch từ API)
// Playlist mẫu
List<MusicItem> playlists = [
  MusicItem(
    title: "Nhạc trẻ hot nhất",
    subtitle: "Danh sách phát • V-Pop",
    imageUrl: "assets/images/maxresdefault.jpg",
    audioUrl: "assets/audio/10 Mất 1 Còn Không (Td Remix).mp3"
  ),
  MusicItem(
    title: "Lofi Chill",
    subtitle: "Danh sách phát • Relax",
    imageUrl: "assets/images/maxresdefault.jpg",
    audioUrl: "assets/audio/Để Anh Lương Thiện (Huy PT Remix).mp3"

  ),
  MusicItem(
    title: "Workout Playlist",
    subtitle: "Danh sách phát • EDM",
    imageUrl: "assets/images/maxresdefault.jpg",
    audioUrl: "assets/audio/chẳng phải tình đầu sao đau đến thế.mp3"
  ),
];

// Nghệ sĩ mẫu
List<MusicItem> dsnghsi = [
  MusicItem(
    title: "Sơn Tùng M-TP",
    subtitle: "Pop, V-Pop",
    imageUrl: "assets/images/maxresdefault.jpg",
    audioUrl: ""
  ),
  MusicItem(
    title: "Đen Vâu",
    subtitle: "Rap, Hip-hop",
    imageUrl: "assets/images/Son-Tung-MTP2.jpg",
    audioUrl: ""
  ),
];

// Album mẫu
List<MusicItem> dsalbum = [
  MusicItem(
    title: "Chúng Ta Của Hiện Tại",
    subtitle: "Sơn Tùng M-TP • 2020",
    imageUrl: "https://i.scdn.co/image/ab67616d0000b2735f68a9a5b123abcfa89342b8",
    audioUrl: ""
  ),
  MusicItem(
    title: "99%",
    subtitle: "Đức Phúc • 2022",
    imageUrl: "https://i.scdn.co/image/ab67616d0000b273ddfba54a2f8d481cbb123a7c",
    audioUrl: ""
  ),
];



  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _addPlaylist() {
    setState(() {
      showDialog(
        context: context,
        builder: (context) {
          TextEditingController titleController = TextEditingController();
          TextEditingController subtitleController = TextEditingController();

          return AlertDialog(
            backgroundColor: const Color(0xFF2C2C2C),
            title: const Text("them play list", style: TextStyle(color: Colors.white),),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                  ),
                  TextField(
                    controller: subtitleController,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Huy", style: TextStyle(color: Colors.redAccent)),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child:  const Text("Them", style: TextStyle(color: Colors.greenAccent),),
                onPressed: () {
                  setState(() {
                    playlists.add(
                      MusicItem(
                        title: titleController.text.trim(),
                        imageUrl: "",
                        subtitle: "",
                        audioUrl: ""
                      ));
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        } 
      );
    });
  }

  void _addNgheSi(){
    setState(() {
      
    });
  }

  void _addAlbum(){
    setState(() {
      
    });
  }

// ham hien thi lua chon them playlist nghe si hoac album
  void _showAddOptions() {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1E1E1E), // nền tối
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
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
            onTap: () {
              Navigator.pop(context);
              // TODO: viết hàm thêm nghệ sĩ
            },
          ),
          ListTile(
            leading: const Icon(Icons.album, color: Colors.white),
            title: const Text("Thêm Album", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              // TODO: viết hàm thêm album
            },
          ),
        ],
      );
    },
  );
}

// ham tra ve so luong phan tu trong mang
int _getItemCount(){
  if(_selectedFilter == "Playlist") {
    return playlists.length;
  } else if (_selectedFilter == "Nghệ sĩ") {
    return dsnghsi.length;
  } else if (_selectedFilter == "Album") {
    return dsalbum.length;
  } else {
    return 0;
  }
}

// hien thi danh sach theo muc
MusicItem _hienThiTheoDanhMuc(String _selectedFilter, int index){
  if(_selectedFilter == "Playlist"){
    return playlists[index];
  }else if(_selectedFilter == "Nghệ sĩ"){
    return dsnghsi[index];
  }else if (_selectedFilter == "Album"){
    return dsalbum[index];
  }else{
    return MusicItem(imageUrl: "", subtitle: "", title: "khong co du lieu", audioUrl: "");
  }
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 55, top: 10),
                  child: const Text(
                    'Thư Viện',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => SearchPagelib(selectedFilter: _selectedFilter),)
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: (){},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filter chips
            Row(
              children: [
                FilterChip(
                  label: const Text('Playlist'),
                  labelStyle: const TextStyle(color: Colors.white),
                  selected: _selectedFilter == "Playlist",
                  selectedColor: Colors.blue,
                  backgroundColor: const Color(0xFF282828),
                  onSelected: (_) => _onFilterSelected("Playlist"),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Nghệ sĩ'),
                  labelStyle: const TextStyle(color: Colors.white),
                  selected: _selectedFilter == "Nghệ sĩ",
                  selectedColor: Colors.blue,
                  backgroundColor: const Color(0xFF282828),
                  onSelected: (_) => _onFilterSelected("Nghệ sĩ"),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Album'),
                  labelStyle: const TextStyle(color: Colors.white),
                  selected: _selectedFilter == "Album",
                  selectedColor: Colors.blue,
                  backgroundColor: const Color(0xFF282828),
                  onSelected: (_) => _onFilterSelected("Album"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Danh sách
            Expanded(
              child: ListView.builder(
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
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 56,
                            height: 56,
                            color: Colors.grey[800],
                            child: const Icon(Icons.music_note, color: Colors.white),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      item.subtitle,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: () async {
                      setState(() {
                        _currentSong = item;
                        _player ??= AudioPlayer();
                      });
                      try {
                        await _player!.setAsset(item.audioUrl);
                        await _player!.play();
                        
                      _player!.playerStateStream.listen((state) {
                        setState(() {
                          _isPlaying = state.playing;
                        });
                      });
                      } catch (e) {
                        print('loi phat nhac: $e');
                      }
                    },
                  );
                },
              ),
            ),
            if (_currentSong != null)
            GestureDetector(
              onTap: () {
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
                          _currentSong = null; // Ẩn mini player khi bấm X
                        });
                      },
                    ),
                  ),
                );
              },
              child: Container(
                height: 70,
                margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _currentSong!.imageUrl.startsWith("http")
                          ? Image.network(
                              _currentSong!.imageUrl,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              _currentSong!.imageUrl,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _currentSong!.title,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white),
                      onPressed: () async{
                        // lay ds hien tai (playlist, dsngsi, ds album)
                        List<MusicItem> currentList = [];
                        if(_selectedFilter == "Playlist"){
                          currentList = playlists;
                        }else if(_selectedFilter == "Nghệ sĩ"){
                          currentList = dsnghsi;
                        }else if(_selectedFilter == "Album"){
                          currentList = dsalbum;
                        }
                        // tim vi tri hien tai va chuyen bai
                        final currentIndex = currentList.indexOf(_currentSong!);
                        if (currentIndex != -1 && currentIndex < currentList.length) {
                        final preSong = currentList[currentIndex - 1];
                        setState(() {
                          _currentSong = preSong;
                        });
                        await _player!.setAsset(preSong.audioUrl);
                        await _player!.play();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('K co bai truoc do')),
                        );
                      }
                    },
                    ),
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_isPlaying) {
                            _player!.pause();
                          } else {
                            _player!.play();
                          }
                        });
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      onPressed: () async{
                        // lay ds hien tai (playlist, dsngsi, ds album)
                        List<MusicItem> currentList = [];
                        if(_selectedFilter == "Playlist"){
                          currentList = playlists;
                        }else if(_selectedFilter == "Nghệ sĩ"){
                          currentList = dsnghsi;
                        }else if(_selectedFilter == "Album"){
                          currentList = dsalbum;
                        }
                        // tim vi tri hien tai va chuyen bai
                        final currentIndex = currentList.indexOf(_currentSong!);
                        if (currentIndex != -1 && currentIndex < currentList.length - 1) {
                        final nextSong = currentList[currentIndex + 1];
                        setState(() {
                          _currentSong = nextSong;
                        });
                        await _player!.setAsset(nextSong.audioUrl);
                        await _player!.play();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Không có bài tiếp theo')),
                        );
                      }
                    },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// trang tim kiem khi bam vao kinh lup
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
          onChanged: (value){
            setState(() {
              _searchText = value;
            });
          },
        ),
      ),
      body: Center(
        child: Text(
          _searchText.isEmpty
        ? "nhap de tim trong ${widget.selectedFilter}"
        : "ket qua cho $_searchText",
        style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}



class PlayerPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String audioUrl;
  final AudioPlayer? existingPlayer;
  final VoidCallback? onClose; // callback khi bấm nút X

  const PlayerPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.audioUrl,
    this.existingPlayer,
    this.onClose,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late AudioPlayer _player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = widget.existingPlayer ?? AudioPlayer();
    if (widget.existingPlayer == null) _init();

    _player.durationStream.listen((d) {
      if (d != null) setState(() => _duration = d);
    });
    _player.positionStream.listen((p) {
      setState(() => _position = p);
    });
    _player.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
    });
  }

  Future<void> _init() async {
    try {
      await _player.setAsset(widget.audioUrl);
    } catch (e) {
      print("Lỗi khi phát nhạc: $e");
    }
  }

  @override
  void dispose() {
    if (widget.existingPlayer == null) _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              widget.onClose?.call(); // báo cho LibraryPage ẩn mini player
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: widget.imageUrl.startsWith("http")
                ? Image.network(widget.imageUrl, width: 250, height: 250, fit: BoxFit.cover)
                : Image.asset(widget.imageUrl, width: 250, height: 250, fit: BoxFit.cover),
          ),
          const SizedBox(height: 30),
          Slider(
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.grey,
            value: _position.inSeconds.toDouble(),
            max: _duration.inSeconds.toDouble() == 0 ? 1 : _duration.inSeconds.toDouble(),
            onChanged: (value) {
              _player.seek(Duration(seconds: value.toInt()));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position), style: const TextStyle(color: Colors.white)),
                Text(_formatDuration(_duration), style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          IconButton(
            iconSize: 80,
            color: Colors.white,
            icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
            onPressed: () {
              _isPlaying ? _player.pause() : _player.play();
            },
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
