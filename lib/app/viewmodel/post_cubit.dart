import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feed_test/app/repositories/i_repository.dart';
import 'package:flutter_feed_test/app/viewmodel/post_state.dart';

class PostCubit extends Cubit<PostState> {
  final IRepository _repository;

  PostCubit({required IRepository repository})
    : _repository = repository,
      super(PostInitial());

  Future<void> load() async {
    emit(PostLoading());

    try {
      final cryptosResult = await _repository.getPosts();
      if (cryptosResult.isEmpty) {
        emit(PostEmpty());
      } else {
        emit(PostSuccess(posts: cryptosResult));
      }
    } on HttpException catch (error) {
      emit(PostError(error.message));
    } catch (e) {
      emit(PostError('An unexpected error occurred: $e'));
    }
  }
}
