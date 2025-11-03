import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  final List<Map<String, String>> newItems = [
    {
      'imageUrl': 'https://th.bing.com/th/id/R.1425e0b6a212ecee47f2b831b049181c?rik=XqBJMiSt7JmlbA&pid=ImgRaw&r=0',
      'time': '1 ngày trước',
      'title': 'Tri kỷ cảm xúc',
      'author': 'Web5ngay',
      'type': 'Podcast',
    },
    {
      'imageUrl': 'https://yt3.googleusercontent.com/50UqhMUilxPFWOqq2H-p9wKsorujDvAYXzJbujZabkXq5WAY5YPjqGKNY22npyBzO6DHvJreRw=s900-c-k-c0x00ffffff-no-rj',
      'time': '2 ngày trước',
      'title': 'Orinn Music, VMix Collection #2',
      'author': 'Orinn, GUANG',
      'type': 'Album',
    },
    {
      'imageUrl': 'https://tse3.mm.bing.net/th/id/OIF.GBKi64HE9bQQq49Iu3f9rg?rs=1&pid=ImgDetMain&o=7&rm=3',
      'time': '4 ngày trước',
      'title': 'Người đầu tiên',
      'author': 'Juky San, buitruonglinh',
      'type': 'Đĩa đơn',
    },
  ];

  final List<Map<String, String>> oldItems = [
    {
      'imageUrl': 'https://picsum.photos/80/80?4',
      'time': '1 tuần trước',
      'title': 'Đĩa đơn: Kỷ niệm',
      'author': 'Tuấn NX',
      'type': 'Đĩa đơn',
    },
    {
      'imageUrl': 'https://picsum.photos/80/80?5',
      'time': '2 tuần trước',
      'title': 'Album: Hồi ức',
      'author': 'Khánh ĐV',
      'type': 'Album',
    },
  ];

  Widget buildFeedItem(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: ảnh + thông tin
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['imageUrl']!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['time']!,
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      item['author']!,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Row 2: thể loại
          Text(
            item['type']!,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 4),
          // Row 3: icon buttons + play
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white70),
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert, color: Colors.white70),
                    iconSize: 20,
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.play_circle_fill, color: Color(0xFF1DB954)),
                iconSize: 32,
              ),
            ],
          ),
          const Divider(color: Colors.white12, thickness: 0.5),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Có gì mới',
          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nội dung phát hành mới từ nghệ sĩ, podcast và chương trình bạn theo dõi',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            const Text(
              'Mới',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...newItems.map(buildFeedItem).toList(),
            const SizedBox(height: 24),
            const Text(
              'Trước đây',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...oldItems.map(buildFeedItem).toList(),
          ],
        ),
      ),
    );
  }
}
