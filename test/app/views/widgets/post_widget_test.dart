import 'package:flutter/material.dart';
import 'package:flutter_feed_test/app/views/widgets/post_widget.dart';
import 'package:flutter_feed_test/core/constants/padding_size.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostWidget =>', () {
    const testKey = Key('post_widget');
    const title = 'Test Title';
    const body = 'This is a test body for the post.';

    Widget buildTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: PostWidget(
            key: testKey,
            userId: 1,
            id: 1,
            title: title,
            body: body,
          ),
        ),
      );
    }

    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byKey(testKey), findsOneWidget);
      expect(find.text(title.characters.first.toUpperCase()), findsOneWidget);
      expect(find.text(title.substring(1)), findsOneWidget);
      expect(find.text(body), findsOneWidget);
    });

    testWidgets('should apply correct padding', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final paddingWidget = tester.widget<Padding>(find.byType(Padding));
      expect(paddingWidget.padding, EdgeInsets.all(PaddingSize.medium));
    });

    testWidgets('should truncate body text after 6 lines', (tester) async {
      const longBody =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n Integer viverra purus sit amet turpis ornare, a laoreet ex tempus.\n Suspendisse congue erat eu est cursus, ut consequat velit rhoncus. Nam non dictum arcu, pretium venenatis orci. Praesent molestie massa gravida magna dignissim, et cursus turpis luctus. Sed diam enim, semper sed est non, ultrices facilisis enim.';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostWidget(userId: 1, id: 1, title: title, body: longBody),
          ),
        ),
      );

      final bodyTextWidget = tester.widget<Text>(find.textContaining('Lorem'));
      expect(bodyTextWidget.maxLines, equals(6));
      expect(bodyTextWidget.style!.overflow, equals(TextOverflow.ellipsis));
    });

    testWidgets('should style title correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final titleTextFirstCharacter = tester.widget<Text>(
        find.text(title.characters.first.toUpperCase()),
      );
      expect(titleTextFirstCharacter.style?.fontWeight, FontWeight.bold);
      expect(titleTextFirstCharacter.textScaler, TextScaler.linear(1.5));

      final titleText = tester.widget<Text>(find.text(title.substring(1)));
      expect(titleText.style?.fontWeight, FontWeight.bold);
      expect(titleText.style?.overflow, TextOverflow.ellipsis);
      expect(titleText.style?.height, 1);
    });
  });
}
