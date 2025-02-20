import 'package:flutter_feed_test/app/models/post_model.dart';

abstract class IRepository {
  Future<List<PostModel>> getPosts();
  Future<String> addPost(PostModel post);
  Future<String> removePost(int id);
}
