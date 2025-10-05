import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  // State quản lý filter
  String _selectedFilter = "Playlist";

  // State quản lý danh sách (sau này có thể fetch từ API)
  List<String> playlists = List.generate(10, (i) => "Playlist ${i + 1}");
  List<String> dsnghsi = List.generate(10, (i) => "Nghe si ${i + 1}");
  List<String> dsalbum = List.generate(10, (i) => "Album ${i + 1}");


  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _addPlaylist() {
    setState(() {
      playlists.add("Playlist mới ${playlists.length + 1}");
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

String _hienThiTheoDanhMuc(String _selectedFilter, int index){
  if(_selectedFilter == "Playlist"){
    return playlists[index];
  }else if(_selectedFilter == "Nghệ sĩ"){
    return dsnghsi[index];
  }else if (_selectedFilter == "Album"){
    return dsalbum[index];
  }else{
    return "khong co ds";
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
                const Text(
                  'Thư viện',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: _showAddOptions
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
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey[800],
                      child: const Icon(Icons.music_note, color: Colors.white),
                    ),
                    title: Text(
                      _hienThiTheoDanhMuc(_selectedFilter, index),
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '$_selectedFilter • 20 bài hát',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlaylistDetailPage(),)
                      );
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

class PlaylistDetailPage extends StatelessWidget {
  const PlaylistDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}