import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';

class UserService {
  final SupabaseClient supabase = SupabaseManager.client;

  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await supabase.from('users').select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateLastSeen(String userId) async {
    await supabase.from('users').update({
      'last_seen': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }
}
