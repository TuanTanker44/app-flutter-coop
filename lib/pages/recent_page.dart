import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/supabase_client.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  Map<String, List<Map<String, dynamic>>> historyByDate = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final supabase = SupabaseManager.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    // ✅ Lấy lịch sử phát
    final history = await supabase
        .from("listening_history")
        .select("song_id, listened_at")
        .eq('user_id', user.id)
        .order('listened_at', ascending: false);

    if (history.isEmpty) {
      setState(() => loading = false);
      return;
    }

    // Lấy danh sách song_id duy nhất
    final ids = history.map((e) => e["song_id"]).toSet().toList();

    // Query bảng songs theo song_id
    final songs = await supabase
        .from("songs")
        .select("id, title, cover_url")
        .inFilter("id", ids);

    // Tạo map { song_id : song_info }
    final songMap = {
      for (var s in songs) s['id']: s,
    };

    // Gộp dữ liệu & chia nhóm theo ngày
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in history) {
      DateTime playedAt =
      DateTime.parse(item['listened_at']).toLocal();

      final song = songMap[item['song_id']];
      if (song == null) continue;

      String dateLabel = _generateDateLabel(playedAt);

      grouped.putIfAbsent(dateLabel, () => []);
      grouped[dateLabel]!.add({
        "title": song["title"],
        "cover_url": song["cover_url"],
        "played_at": playedAt,
      });
    }

    setState(() {
      historyByDate = grouped;
      loading = false;
    });
  }

  /// Format ngày: Hôm nay / Hôm qua / Ngày xx Tháng yy Năm yyyy
  String _generateDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final check = DateTime(date.year, date.month, date.day);

    if (check == today) return "Hôm nay";
    if (check == today.subtract(const Duration(days: 1))) {
      return "Hôm qua";
    }

    return DateFormat("'Ngày' dd 'Tháng' MM 'Năm' yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Gần đây"),
        backgroundColor: Colors.black,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : historyByDate.isEmpty
          ? const Center(
        child: Text("Chưa có lịch sử phát nào",
            style: TextStyle(color: Colors.white)),
      )
          : ListView(
        padding: const EdgeInsets.all(12),
        children: historyByDate.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...entry.value.map((item) => ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    item['cover_url'],
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  item['title'],
                  style:
                  const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  DateFormat("HH:mm")
                      .format(item['played_at']),
                  style: const TextStyle(
                      color: Colors.white54),
                ),
                onTap: () {
                  // TODO: chuyển sang màn hình phát nhạc
                },
              )),
              const SizedBox(height: 20),
            ],
          );
        }).toList(),
      ),
    );
  }
}
