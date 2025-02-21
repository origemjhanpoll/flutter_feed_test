import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_feed_test/app/repositories/i_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_feed_test/app/models/post_model.dart';
import 'package:flutter_feed_test/app/viewmodel/post_cubit.dart';
import 'package:flutter_feed_test/app/viewmodel/post_state.dart';

import './post_cubit_test.mocks.dart';

@GenerateMocks([IRepository])
void main() {
  late PostCubit postCubit;
  late MockIRepository mockRepository;

  setUp(() {
    mockRepository = MockIRepository();
    postCubit = PostCubit(repository: mockRepository);
  });

  tearDown(() {
    postCubit.close();
  });

  group('PostCubit =>', () {
    final post = PostModel(
      userId: 1,
      id: 1,
      title: 'Test Post',
      body: 'Content',
    );

    blocTest<PostCubit, PostState>(
      'should emit [PostLoading, PostSuccess] when load is successful with data',
      build: () {
        when(mockRepository.getPosts()).thenAnswer((_) async => [post]);
        return postCubit;
      },
      act: (cubit) => cubit.load(),
      expect:
          () => [
            PostLoading(),
            PostSuccess(posts: [post]),
          ],
    );

    blocTest<PostCubit, PostState>(
      'should emit [PostLoading, PostEmpty] when load returns no data',
      build: () {
        when(mockRepository.getPosts()).thenAnswer((_) async => []);
        return postCubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [PostLoading(), PostEmpty()],
    );

    blocTest<PostCubit, PostState>(
      'should emit [PostError] when load fails',
      build: () {
        when(
          mockRepository.getPosts(),
        ).thenThrow(Exception('Error fetching posts'));
        return postCubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [PostLoading(), isA<PostError>()],
    );

    blocTest<PostCubit, PostState>(
      'should emit [PostSuccess, PostWarning] when addPost is successful',
      build: () {
        when(
          mockRepository.addPost(any),
        ).thenAnswer((_) async => 'Post created');
        return postCubit;
      },
      act: (cubit) => cubit.addPost(post),
      expect:
          () => [
            PostSuccess(posts: [post]),
            PostWarning('Post created'),
          ],
    );

    blocTest<PostCubit, PostState>(
      'should emit [PostError] when addPost fails',
      build: () {
        when(
          mockRepository.addPost(any),
        ).thenThrow(Exception('Error adding post'));
        return postCubit;
      },
      act: (cubit) => cubit.addPost(post),
      expect: () => [isA<PostError>()],
    );

    blocTest<PostCubit, PostState>(
      'should emit [PostSuccess, PostWarning] when removePost is successful',
      build: () {
        when(
          mockRepository.removePost(any),
        ).thenAnswer((_) async => 'Post removed');
        postCubit.posts.add(post);
        return postCubit;
      },
      act: (cubit) => cubit.removePost(post),
      expect: () => [PostSuccess(posts: []), PostWarning('Post removed')],
    );

    blocTest<PostCubit, PostState>(
      'should emit [PostError] when removePost fails',
      build: () {
        when(
          mockRepository.removePost(any),
        ).thenThrow(Exception('Error removing post'));
        return postCubit;
      },
      act: (cubit) => cubit.removePost(post),
      expect: () => [isA<PostError>()],
    );
  });
}
