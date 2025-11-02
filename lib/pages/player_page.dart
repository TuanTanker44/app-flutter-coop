import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';

class PlayerPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String audioUrl;
  final AudioPlayer? existingPlayer;
  final VoidCallback? onClose;

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

  Color _darkColor = Colors.black;
  Color _lightColor = Colors.blueGrey;

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

    _extractPalette(); // Gọi hàm AI palette
  }

  Future<void> _init() async {
    try {
      await _player.setAsset(widget.audioUrl);
      await _player.play();
    } catch (e) {
      print("Lỗi phát nhạc: $e");
    }
  }

  /// 🧠
  Future<void> _extractPalette() async {
    try {
      final imageProvider = widget.imageUrl.startsWith('http')
          ? NetworkImage(widget.imageUrl)
          : AssetImage(widget.imageUrl) as ImageProvider;

      final PaletteGenerator palette =
          await PaletteGenerator.fromImageProvider(imageProvider);

      setState(() {
        _darkColor = palette.darkVibrantColor?.color ??
            palette.dominantColor?.color ??
            Colors.blueGrey.shade900;
        _lightColor = palette.lightVibrantColor?.color ??
            palette.mutedColor?.color ??
            Colors.blueGrey.shade200;
      });
    } catch (e) {
      print("Lỗi lấy màu từ ảnh: $e");
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
      backgroundColor: _darkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              _player.stop();
              widget.onClose?.call();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_darkColor, _lightColor],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Ảnh bìa
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: widget.imageUrl.startsWith("http")
                      ? Image.network(widget.imageUrl,
                          width: double.infinity,
                          height: 280,
                          fit: BoxFit.cover)
                      : Image.asset(widget.imageUrl,
                          width: double.infinity,
                          height: 280,
                          fit: BoxFit.cover),
                ),
              ),

              // Tên bài hát
              Column(
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Phan Mạnh Quỳnh",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),

              // Thanh trượt
              Column(
                children: [
                  Slider(
                    activeColor: Colors.white,
                    inactiveColor: Colors.white38,
                    value: _position.inSeconds
                        .toDouble()
                        .clamp(0, _duration.inSeconds.toDouble() == 0 ? 1 : _duration.inSeconds.toDouble()),
                    max: _duration.inSeconds.toDouble() == 0
                        ? 1
                        : _duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      _player.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(_position),
                            style: const TextStyle(color: Colors.white70)),
                        Text(_formatDuration(_duration),
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),

              // Nút điều khiển
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shuffle, color: Colors.white70),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.skip_previous,
                          size: 40, color: Colors.white),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () =>
                          _isPlaying ? _player.pause() : _player.play(),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 45,
                          color: _darkColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.skip_next,
                          size: 40, color: Colors.white),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.repeat, color: Colors.white70),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
