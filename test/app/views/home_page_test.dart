import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feed_test/app/models/post_model.dart';
import 'package:flutter_feed_test/app/viewmodel/post_cubit.dart';
import 'package:flutter_feed_test/app/viewmodel/post_state.dart';
import 'package:flutter_feed_test/app/views/home_page.dart';
import 'package:flutter_feed_test/app/views/widgets/post_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './home_page_test.mocks.dart';

@GenerateMocks([PostCubit])
void main() {
  late GlobalKey<NavigatorState> navigatorKey;
  late MockPostCubit mockCubit;

  setUp(() {
    mockCubit = MockPostCubit();
    navigatorKey = GlobalKey<NavigatorState>();

    GetIt.instance.registerFactory<PostCubit>(() => mockCubit);

    provideDummy<PostState>(PostInitial());
    when(mockCubit.stream).thenAnswer((_) => Stream<PostState>.empty());
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: BlocProvider<PostCubit>(
        create: (_) => GetIt.instance<PostCubit>(),
        child: const HomePage(),
      ),
    );
  }

  group('HomePage =>', () {
    testWidgets('should show loading indicator when state is PostLoading', (
      tester,
    ) async {
      when(mockCubit.state).thenReturn(PostLoading());

      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show empty message when state is PostEmpty', (
      tester,
    ) async {
      when(mockCubit.state).thenReturn(PostEmpty());

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Nenhum post encontrado.'), findsOneWidget);
    });

    testWidgets('should show error message when state is PostError', (
      tester,
    ) async {
      when(mockCubit.state).thenReturn(PostError('Erro ao carregar posts'));

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Erro ao carregar posts'), findsOneWidget);
    });

    testWidgets('should display posts when state is PostSuccess', (
      tester,
    ) async {
      final posts = [
        PostModel(
          id: 1,
          userId: 10,
          title: 'Post 1',
          body: 'Conteúdo do post 1',
        ),
        PostModel(
          id: 2,
          userId: 20,
          title: 'Post 2',
          body: 'Conteúdo do post 2',
        ),
      ];

      when(mockCubit.state).thenReturn(PostSuccess(posts: posts));

      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(PostWidget), findsNWidgets(2));
      expect(find.text('Conteúdo do post 1'), findsOneWidget);
      expect(find.text('Conteúdo do post 2'), findsOneWidget);
    });

    testWidgets('should navigate to AddPostPage and add post on return', (
      tester,
    ) async {
      final newPost = PostModel(
        id: 3,
        userId: 30,
        title: 'Novo Post',
        body: 'Conteúdo do novo post',
      );

      when(mockCubit.state).thenReturn(PostSuccess(posts: []));
      when(mockCubit.addPost(newPost)).thenAnswer((_) async {});

      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      navigatorKey.currentState!.pop(newPost);
      await tester.pumpAndSettle();

      verify(mockCubit.addPost(newPost)).called(1);
    });

    testWidgets('should remove post when returning from PostDetailsPage', (
      tester,
    ) async {
      final posts = [
        PostModel(
          id: 1,
          userId: 10,
          title: 'Post 1',
          body: 'Conteúdo do post 1',
        ),
      ];

      when(mockCubit.state).thenReturn(PostSuccess(posts: posts));
      when(mockCubit.removePost(posts.first)).thenAnswer((_) async {});

      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Conteúdo do post 1'));
      await tester.pumpAndSettle();

      navigatorKey.currentState?.pop(posts.first);
      await tester.pumpAndSettle();

      verify(mockCubit.removePost(posts.first)).called(1);
    });
  });
}
