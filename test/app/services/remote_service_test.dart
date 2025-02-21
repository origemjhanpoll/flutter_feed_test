import 'dart:convert';
import 'package:flutter_feed_test/app/services/remote_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './remote_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late RemoteService remoteService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    remoteService = RemoteService(mockClient);
  });

  group('RemoteService =>', () {
    test('should fetch posts successfully', () async {
      final mockResponse = jsonEncode([
        {"userId": 1, "id": 1, "title": "Teste", "body": "Conteúdo"},
      ]);

      when(
        mockClient.get(Uri.parse('https://jsonplaceholder.typicode.com/posts')),
      ).thenAnswer((_) async => http.Response(mockResponse, 200));

      final posts = await remoteService.fetchPosts();

      expect(posts, isA<List<Map<String, dynamic>>>());
      expect(posts.first['title'], "Teste");
    });

    test('should throw an exception when fetching posts fails', () async {
      when(
        mockClient.get(Uri.parse('https://jsonplaceholder.typicode.com/posts')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(remoteService.fetchPosts(), throwsException);
    });

    test('should create a post successfully', () async {
      final postData = {"title": "Novo Post", "body": "Conteúdo", "userId": 1};
      final mockResponse = jsonEncode({"id": 101});

      when(
        mockClient.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          headers: anyNamed('headers'),
          body: jsonEncode(postData),
        ),
      ).thenAnswer((_) async => http.Response(mockResponse, 201));

      final result = await remoteService.createPost(postData);

      expect(result['message'], 'Post criado com sucesso!');
      expect(result['id'], 101);
    });

    test('should throw an exception when creating a post fails', () async {
      final postData = {"title": "Novo Post", "body": "Conteúdo", "userId": 1};

      when(
        mockClient.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          headers: anyNamed('headers'),
          body: jsonEncode(postData),
        ),
      ).thenAnswer((_) async => http.Response('Erro', 400));

      expect(() => remoteService.createPost(postData), throwsException);
    });

    test('should delete a post successfully', () async {
      when(
        mockClient.delete(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response('', 200));

      final result = await remoteService.deletePost(1);

      expect(result['message'], 'Post deletado com sucesso!');
      expect(result['id'], 1);
    });

    test('should throw an exception when deleting a post fails', () async {
      when(
        mockClient.delete(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response('Erro', 404));

      expect(() => remoteService.deletePost(1), throwsException);
    });
  });
}
