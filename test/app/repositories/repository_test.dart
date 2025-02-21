import 'package:flutter_feed_test/app/services/local_service.dart';
import 'package:flutter_feed_test/app/services/remote_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_feed_test/app/models/post_model.dart';
import 'package:flutter_feed_test/app/repositories/repository.dart';

import './repository_test.mocks.dart';

@GenerateMocks([LocalService, RemoteService])
void main() {
  late Repository repository;
  late MockRemoteService mockRemoteService;
  late MockLocalService mockLocalService;

  setUp(() {
    mockRemoteService = MockRemoteService();
    mockLocalService = MockLocalService();
    repository = Repository(
      remoteService: mockRemoteService,
      localService: mockLocalService,
    );
  });

  group('Repository =>', () {
    test('should return posts from local storage if available', () async {
      final localPosts = [
        {"userId": 1, "id": 1, "title": "Post Local", "body": "Conteúdo local"},
      ];

      when(mockLocalService.getPosts()).thenAnswer((_) async => localPosts);
      when(mockRemoteService.fetchPosts()).thenAnswer((_) async => []);

      final posts = await repository.getPosts();

      expect(posts, isA<List<PostModel>>());
      expect(posts.length, 1);
      expect(posts.first.title, "Post Local");
      verify(mockLocalService.getPosts()).called(1);
      verify(mockRemoteService.fetchPosts()).called(1);
    });

    test(
      'should fetch posts from remote service when local is empty',
      () async {
        when(mockLocalService.getPosts()).thenAnswer((_) async => []);
        final remotePosts = [
          {
            "userId": 1,
            "id": 1,
            "title": "Post Remoto",
            "body": "Conteúdo remoto",
          },
        ];
        when(
          mockRemoteService.fetchPosts(),
        ).thenAnswer((_) async => remotePosts);

        final posts = await repository.getPosts();

        expect(posts.length, 1);
        expect(posts.first.title, "Post Remoto");
        verify(mockLocalService.savePosts(remotePosts)).called(1);
      },
    );

    test('should add a post successfully', () async {
      final post = PostModel(
        userId: 1,
        id: 1,
        title: "Novo Post",
        body: "Teste",
      );
      final response = {"message": "Post criado com sucesso!", "id": 101};

      when(mockRemoteService.createPost(any)).thenAnswer((_) async => response);
      when(mockLocalService.addPost(any)).thenAnswer((_) async {});

      final message = await repository.addPost(post);

      expect(message, "Post criado com sucesso!");
      verify(mockRemoteService.createPost(post.toJson())).called(1);
      verify(mockLocalService.addPost(post.toJson())).called(1);
    });

    test('should remove a post successfully', () async {
      final response = {"message": "Post deletado com sucesso!", "id": 1};

      when(mockRemoteService.deletePost(1)).thenAnswer((_) async => response);
      when(mockLocalService.removePost(1)).thenAnswer((_) async {});

      final message = await repository.removePost(1);

      expect(message, "Post deletado com sucesso!");
      verify(mockRemoteService.deletePost(1)).called(1);
      verify(mockLocalService.removePost(1)).called(1);
    });

    test('should return error message when addPost fails', () async {
      when(
        mockRemoteService.createPost(any),
      ).thenThrow(Exception("Erro ao adicionar"));

      final post = PostModel(userId: 1, id: 1, title: "Erro", body: "Falha");

      final message = await repository.addPost(post);

      expect(message, "Erro ao adicionar o post");
    });

    test('should return error message when removePost fails', () async {
      when(
        mockRemoteService.deletePost(1),
      ).thenThrow(Exception("Erro ao remover"));

      final message = await repository.removePost(1);

      expect(message, "Erro ao remover o post");
    });
  });
}
