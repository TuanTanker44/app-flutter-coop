import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                FilterChip(
                  label: const Text('Playlist'),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: const Color(0xFF282828),
                  onSelected: (value) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Nghệ sĩ'),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: const Color(0xFF282828),
                  onSelected: (value) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Album'),
                  labelStyle: const TextStyle(color: Colors.white),
                  backgroundColor: const Color(0xFF282828),
                  onSelected: (value) {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey[800],
                      child: const Icon(Icons.music_note, color: Colors.white),
                    ),
                    title: const Text(
                      'Playlist của tôi',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Playlist • 20 bài hát',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlaylistDetailPage(title: "Playlist cua toi"),)
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
  final String title;

  const PlaylistDetailPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          "Đây là trang chi tiết của $title",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
