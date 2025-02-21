import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feed_test/app/models/post_model.dart';
import 'package:flutter_feed_test/app/repositories/i_repository.dart';
import 'package:flutter_feed_test/app/viewmodel/post_state.dart';

class PostCubit extends Cubit<PostState> {
  final IRepository _repository;

  PostCubit({required IRepository repository})
    : _repository = repository,
      super(PostInitial());

  final List<PostModel> posts = [];

  Future<void> load() async {
    emit(PostLoading());

    try {
      final result = await _repository.getPosts();
      posts.addAll(result);
      if (posts.isEmpty) {
        emit(PostEmpty());
      } else {
        emit(PostSuccess(posts: posts));
      }
    } catch (e) {
      emit(PostError('An unexpected error occurred: $e'));
    }
  }

  Future<void> addPost(PostModel post) async {
    try {
      final message = await _repository.addPost(post);
      posts.insert(0, post);

      emit(PostSuccess(posts: posts));
      emit(PostWarning(message));
    } catch (e) {
      emit(PostError('An unexpected error occurred: $e'));
    }
  }

  Future<void> removePost(PostModel post) async {
    try {
      final message = await _repository.removePost(post.id);
      posts.remove(post);

      emit(PostSuccess(posts: posts));
      emit(PostWarning(message));
    } catch (e) {
      emit(PostError('An unexpected error occurred: $e'));
    }
  }
}
