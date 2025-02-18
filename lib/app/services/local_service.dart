import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  static const String _postsKey = 'posts';

  Future<List<Map<String, dynamic>>> getPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getStringList(_postsKey);

    if (postsJson != null) {
      return postsJson
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();
    } else {
      return [];
    }
  }

  Future<void> addPost(Map<String, dynamic> postJson) async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getStringList(_postsKey) ?? [];

    postsJson.add(jsonEncode(postJson));

    await prefs.setStringList(_postsKey, postsJson);
  }
}
