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

    postsJson.insert(0, jsonEncode(postJson));

    await prefs.setStringList(_postsKey, postsJson);
  }

  Future<void> savePosts(List<Map<String, dynamic>> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedPosts = posts.map((post) => jsonEncode(post)).toList();

    await prefs.setStringList(_postsKey, encodedPosts);
  }

  Future<void> removePost(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getStringList(_postsKey) ?? [];

    final posts =
        postsJson.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

    posts.removeWhere((post) => post['id'] == id);

    final updatedPostsJson = posts.map((post) => jsonEncode(post)).toList();
    await prefs.setStringList(_postsKey, updatedPostsJson);
  }
}
