import 'package:flutter/foundation.dart';
import 'package:flutter_feed_test/app/models/post_model.dart';
import 'package:flutter_feed_test/app/repositories/i_repository.dart';
import 'package:flutter_feed_test/app/services/remote_service.dart';

import 'package:flutter_feed_test/app/services/local_service.dart';

class Repository implements IRepository {
  final RemoteService remoteService;
  final LocalService localService;

  Repository({required this.remoteService, required this.localService});

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final localData = await localService.getPosts();
      final remoteData = await remoteService.fetchPosts();

      if (listEquals(localData, remoteData)) {
        return localData.map((e) => PostModel.fromJson(e)).toList();
      }

      return remoteData.map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Erro ao buscar posts: $e');
      throw Exception(e);
    }
  }

  @override
  Future<String> addPost(PostModel post) async {
    try {
      final response = await remoteService.createPost(post.toJson());

      if (response['message'] != null) {
        await localService.addPost(post.toJson());
        return response['message'];
      } else {
        return 'Erro ao criar o post';
      }
    } catch (e) {
      debugPrint('Erro ao adicionar post: $e');
      return 'Erro ao adicionar o post';
    }
  }
}
