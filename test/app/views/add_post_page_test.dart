import 'package:flutter/material.dart';
import 'package:flutter_feed_test/app/views/add_post_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddPostPage =>', () {
    Widget buildTestWidget() {
      return const MaterialApp(home: AddPostPage());
    }

    testWidgets('should render title and description fields', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.widgetWithText(TextField, 'Título*'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Descrição'), findsOneWidget);
    });

    testWidgets('should start with the publish button disabled', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      final publishButton = find.byKey(Key('key-publicar'));
      expect(publishButton, findsOneWidget);

      final opacityWidget = tester.widget<AnimatedOpacity>(
        find.ancestor(
          of: publishButton,
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(opacityWidget.opacity, equals(0.2));
    });

    testWidgets('should enable the publish button when title is filled', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      final titleField = find.widgetWithText(TextField, 'Título*');
      await tester.enterText(titleField, 'Meu Novo Post');
      await tester.pumpAndSettle();

      final publishButton = find.byKey(Key('key-publicar'));

      final opacityWidget = tester.widget<AnimatedOpacity>(
        find.ancestor(
          of: publishButton,
          matching: find.byType(AnimatedOpacity),
        ),
      );
      expect(opacityWidget.opacity, equals(1.0));
    });

    testWidgets('should return a PostModel when published', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      final titleField = find.widgetWithText(TextField, 'Título*');
      final descriptionField = find.widgetWithText(TextField, 'Descrição');

      await tester.enterText(titleField, 'Título de Teste');
      await tester.enterText(descriptionField, 'Descrição do post de teste.');
      await tester.pumpAndSettle();

      final publishButton = find.byKey(Key('key-publicar'));

      await tester.tap(publishButton);
      await tester.pumpAndSettle();

      expect(find.byType(AddPostPage), findsNothing);
    });

    testWidgets('should close page when close button is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      final closeButton = find.byIcon(Icons.close);
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      expect(find.byType(AddPostPage), findsNothing);
    });
  });
}
