import 'package:flutter/material.dart';
import '../core/supabase_client.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final supabase = SupabaseManager.client;

    // bucket public
    final url = supabase.storage.from('avatars').getPublicUrl('yena.jpg');

    setState(() {
      imageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: imageUrl == null
            ? const CircularProgressIndicator()
            : Image.network(imageUrl!),
      ),
    );
  }
}
