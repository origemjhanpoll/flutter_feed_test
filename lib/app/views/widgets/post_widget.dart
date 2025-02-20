import 'package:flutter/material.dart';
import 'package:flutter_feed_test/core/constants/padding_size.dart';

class PostWidget extends StatelessWidget {
  final int userId;
  final int id;
  final String title;
  final String body;

  const PostWidget({
    super.key,
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(PaddingSize.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title.characters.first.toUpperCase(),
                textScaler: TextScaler.linear(1.5),
                style: theme.textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: Text(
                  title.substring(1),
                  maxLines: 2,
                  style: theme.textTheme.titleLarge!.copyWith(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          Text(
            body.replaceAll('\n', ' '),
            maxLines: 6,
            style: theme.textTheme.bodyMedium!.copyWith(
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
