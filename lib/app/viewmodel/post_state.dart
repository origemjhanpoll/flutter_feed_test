import 'package:equatable/equatable.dart';
import 'package:flutter_feed_test/app/models/post_model.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostEmpty extends PostState {}

class PostSuccess extends PostState {
  final List<PostModel> posts;
  const PostSuccess({required this.posts});

  @override
  List<Object?> get props => [posts];
}

class PostError extends PostState {
  final String message;
  const PostError(this.message);

  @override
  List<Object?> get props => [message];
}
