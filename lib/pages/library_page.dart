import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app_flutter/pages/player_page.dart';

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
  final Function(MusicItem)? onSongSelected; // thêm callback
  const LibraryPage({super.key, this.onSongSelected});

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
                    onTap: () {
                        if (item.audioUrl.isNotEmpty) {
                        widget.onSongSelected?.call(item); // 🔁 Gửi bài hát về MainScreen
                      }
                    },
                  );
                },
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


