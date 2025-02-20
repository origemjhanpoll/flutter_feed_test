import 'package:flutter/material.dart';
import 'package:flutter_feed_test/app/models/post_model.dart';
import 'package:flutter_feed_test/core/constants/padding_size.dart';

class PostDetailsPage extends StatefulWidget {
  final PostModel post;
  const PostDetailsPage({super.key, required this.post});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 68,
        leading: IconButton.outlined(
          color: theme.colorScheme.secondary,
          style: ButtonStyle(
            side: WidgetStatePropertyAll(
              BorderSide(width: 1.5, color: theme.colorScheme.secondary),
            ),
          ),
          tooltip: 'Retornar',
          onPressed: Navigator.of(context).pop,
          icon: Icon(Icons.chevron_left),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: PaddingSize.medium),
            child: TextButton(
              onPressed: () {
                showDialog<int?>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog.adaptive(
                      title: Text(
                        "Confirmar Exclusão de Post",
                        style: theme.textTheme.titleMedium,
                      ),
                      content: Text(
                        'Tem certeza de que deseja excluir este post? Esta ação não pode ser desfeita.',
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            "Cancelar",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            "Continuar",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                              ..pop()
                              ..pop<PostModel>(widget.post);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Text(
                    'D',
                    textScaler: TextScaler.linear(1.3),
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  Text(
                    'ELETAR',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(PaddingSize.medium),
          child: SelectableRegion(
            selectionControls: materialTextSelectionControls,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${widget.post.id}',
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.post.title.characters.first.toUpperCase(),
                      textScaler: TextScaler.linear(1.5),
                      style: theme.textTheme.displaySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        maxLines: 3,
                        widget.post.title.substring(1),
                        style: theme.textTheme.titleLarge!.copyWith(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(widget.post.body, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
