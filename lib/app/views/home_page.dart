import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feed_test/app/injection.dart';
import 'package:flutter_feed_test/app/models/post_model.dart';
import 'package:flutter_feed_test/app/viewmodel/post_cubit.dart';
import 'package:flutter_feed_test/app/viewmodel/post_state.dart';
import 'package:flutter_feed_test/app/views/add_post_page.dart';
import 'package:flutter_feed_test/app/views/widgets/post_widget.dart';
import 'package:flutter_feed_test/app/views/post_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PostCubit _cubit;
  final _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<PostModel> _posts = [];

  @override
  void initState() {
    _cubit = di<PostCubit>()..load();
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _addPost(PostModel post) {
    _posts.insert(0, post);
    _listKey.currentState?.insertItem(0, duration: Durations.medium1);
  }

  // void _removePost(int id) {
  //   final index = _posts.indexWhere((post) => post.id == id);
  //   if (index != -1) {
  //     final removedPost = _posts.removeAt(index);
  //     _listKey.currentState?.removeItem(
  //       index,
  //       (context, animation) => SizeTransition(
  //         sizeFactor: animation,
  //         child: PostWidget(
  //           key: Key(removedPost.id.toString()),
  //           id: removedPost.id,
  //           userId: removedPost.userId,
  //           title: removedPost.title,
  //           body: removedPost.body,
  //         ),
  //       ),
  //       duration: Durations.medium1,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: BlocConsumer<PostCubit, PostState>(
            listenWhen: (previous, current) => current is PostWarning,
            listener: (context, state) {
              if (state is PostWarning) {
                final snackBar = SnackBar(content: Text(state.message));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            buildWhen:
                (previous, current) =>
                    current is PostLoading ||
                    current is PostSuccess ||
                    current is PostEmpty ||
                    current is PostError,
            builder: (context, state) {
              if (state is PostLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PostSuccess) {
                if (_posts.isEmpty) {
                  _posts.addAll(state.posts);
                }

                return AnimatedList(
                  key: _listKey,
                  controller: _scrollController,
                  initialItemCount: _posts.length,
                  itemBuilder: (context, index, animation) {
                    final post = _posts[index];

                    return SizeTransition(
                      sizeFactor: animation,
                      child: InkWell(
                        overlayColor: WidgetStatePropertyAll(
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .push<PostModel>(
                                MaterialPageRoute(
                                  builder: (_) => PostDetailsPage(post: post),
                                ),
                              )
                              .then((post) {
                                if (post != null) _cubit.removePost(post);
                              });
                        },
                        child: PostWidget(
                          key: Key(post.id.toString()),
                          id: post.id,
                          userId: post.userId,
                          title: post.title,
                          body: post.body,
                        ),
                      ),
                    );
                  },
                );
              } else if (state is PostEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum post encontrado.',
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (state is PostError) {
                return Center(
                  child: Text(state.message, textAlign: TextAlign.center),
                );
              }
              return const LimitedBox();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => AddPostPage()))
                .then((post) {
                  if (post != null) {
                    _cubit.addPost(post);
                    _addPost(post);

                    Future.delayed(Durations.medium1, () {
                      _scrollController.animateTo(
                        0,
                        duration: Durations.medium2,
                        curve: Curves.easeInOut,
                      );
                    });
                  }
                });
          },
          tooltip: 'Adicionar Post',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
