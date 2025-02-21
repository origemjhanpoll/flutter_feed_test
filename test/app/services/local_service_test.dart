import 'package:flutter_feed_test/app/services/local_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalService localService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    localService = LocalService();
  });

  group('LocalService =>', () {
    test('should return an empty list when there are no posts', () async {
      final posts = await localService.getPosts();
      expect(posts, isEmpty);
    });

    test('should add a post successfully', () async {
      final post = {"id": 1, "title": "Novo Post", "body": "Conteúdo"};

      await localService.addPost(post);

      final posts = await localService.getPosts();
      expect(posts, isA<List<Map<String, dynamic>>>());
      expect(posts.length, 1);
      expect(posts.first['id'], 1);
    });

    test('should save multiple posts successfully', () async {
      final posts = [
        {"id": 1, "title": "Post 1", "body": "Conteúdo 1"},
        {"id": 2, "title": "Post 2", "body": "Conteúdo 2"},
      ];

      await localService.savePosts(posts);

      final storedPosts = await localService.getPosts();
      expect(storedPosts.length, 2);
      expect(storedPosts.first['title'], "Post 1");
      expect(storedPosts.last['title'], "Post 2");
    });

    test('should remove a post successfully', () async {
      final posts = [
        {"id": 1, "title": "Post 1", "body": "Conteúdo 1"},
        {"id": 2, "title": "Post 2", "body": "Conteúdo 2"},
      ];

      await localService.savePosts(posts);

      await localService.removePost(1);

      final updatedPosts = await localService.getPosts();
      expect(updatedPosts.length, 1);
      expect(updatedPosts.first['id'], 2);
    });

    test('should not remove any post if ID does not exist', () async {
      final posts = [
        {"id": 1, "title": "Post 1", "body": "Conteúdo 1"},
      ];

      await localService.savePosts(posts);
      await localService.removePost(99);

      final updatedPosts = await localService.getPosts();
      expect(updatedPosts.length, 1);
      expect(updatedPosts.first['id'], 1);
    });
  });
}
