import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_feed_test/app/models/post_model.dart';
import 'package:flutter_feed_test/core/constants/padding_size.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _focusNodeTitle = FocusNode();
  final _focusNodeDescription = FocusNode();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

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
          tooltip: 'Fechar',
          onPressed: Navigator.of(context).pop,
          icon: Icon(Icons.close),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: PaddingSize.medium),
            child: ValueListenableBuilder(
              valueListenable: _titleController,
              builder: (context, controller, child) {
                return AnimatedOpacity(
                  opacity: controller.text.isNotEmpty ? 1 : 0.2,
                  duration: Durations.medium2,
                  child: FilledButton.icon(
                    onPressed:
                        controller.text.isNotEmpty
                            ? () {
                              final postModel = PostModel(
                                userId: 232,
                                id: Random().nextInt(1000) + 100,
                                title: _titleController.text,
                                body: _descriptionController.text,
                              );

                              Navigator.pop(context, postModel);
                            }
                            : null,
                    icon: Icon(Icons.add),
                    label: Row(
                      children: [
                        Text(
                          'P',
                          textScaler: TextScaler.linear(1.3),
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        Text(
                          'UBLICAR',
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(PaddingSize.medium),
          child: Column(
            spacing: PaddingSize.medium,
            children: [
              TextField(
                controller: _titleController,
                autofocus: true,
                focusNode: _focusNodeTitle,
                onTapOutside: (event) => _focusNodeTitle.unfocus(),
                maxLines: 3,
                minLines: 1,
                maxLength: 100,
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: 'Título*',
                  hintText: 'Digite o título',
                ),
              ),
              TextField(
                controller: _descriptionController,
                focusNode: _focusNodeDescription,
                onTapOutside: (event) => _focusNodeDescription.unfocus(),
                maxLength: 2000,
                maxLines: 20,
                minLines: 1,
                style: theme.textTheme.bodyLarge!.copyWith(
                  overflow: TextOverflow.ellipsis,
                ),
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Digite a descrição',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
