import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteService {
  final http.Client client;
  RemoteService(this.client);
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final response = await client.get(Uri.parse('$_baseUrl/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Map<String, dynamic>> createPost(Map<String, dynamic> postData) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(postData),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return {'message': 'Post criado com sucesso!', 'id': data['id']};
    } else {
      throw Exception('Failed to create post');
    }
  }

  Future<Map<String, dynamic>> deletePost(int id) async {
    final response = await client.delete(
      Uri.parse('$_baseUrl/posts/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return {'message': 'Post deletado com sucesso!', 'id': id};
    } else {
      throw Exception('Failed to delete post');
    }
  }
}
