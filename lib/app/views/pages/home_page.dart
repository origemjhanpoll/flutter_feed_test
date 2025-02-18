import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feed_test/app/injection.dart';
import 'package:flutter_feed_test/app/viewmodel/post_cubit.dart';
import 'package:flutter_feed_test/app/viewmodel/post_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PostCubit _cubit;

  @override
  void initState() {
    _cubit = di<PostCubit>()..load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,

          title: Text('Posts'),
        ),
        body: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostSuccess) {
              return ListView.separated(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];

                  return Text(post.title);
                },
                separatorBuilder: (context, index) => Divider(),
              );
            } else if (state is PostEmpty) {
              return const Center(
                child: Text(
                  'Nenhum crypto encontrado.',
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Adicionar Post',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
