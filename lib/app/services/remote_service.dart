import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteService {
  final http.Client client;
  RemoteService(this.client);
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<dynamic>> fetchPosts() async {
    final response = await client.get(Uri.parse('$_baseUrl/posts'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Map<String, dynamic>> createPost(Map<String, dynamic> postData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(postData),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return {'message': 'Post created successfully', 'id': data['id']};
    } else {
      throw Exception('Failed to create post');
    }
  }
}
