import 'package:flutter/material.dart';
import 'package:flutter_feed_test/app/models/post_model.dart';
import 'package:flutter_feed_test/app/views/post_details_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostDetailsPage =>', () {
    final post = PostModel(
      id: 1,
      userId: 232,
      title: 'Post de Teste',
      body: 'Conteúdo do post de teste.',
    );

    Widget buildTestWidget() {
      return MaterialApp(home: PostDetailsPage(post: post));
    }

    testWidgets('should display post title and body', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('#1'), findsOneWidget);
      expect(find.text('P'), findsOneWidget);
      expect(find.text('ost de Teste'), findsOneWidget);
      expect(find.text('Conteúdo do post de teste.'), findsOneWidget);
    });

    testWidgets('should show confirmation dialog when delete button is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      final deleteButton = find.text('ELETAR');
      expect(deleteButton, findsOneWidget);

      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      expect(find.text('CONFIMAR EXCLUSÃO'), findsOneWidget);
      expect(
        find.text(
          'Tem certeza de que deseja excluir este post? Esta ação não pode ser desfeita.',
        ),
        findsOneWidget,
      );

      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Continuar'), findsOneWidget);
    });

    testWidgets(
      'should pop the PostModel when "Continuar" is pressed in the confirmation dialog',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());

        final deleteButton = find.text('ELETAR');
        await tester.tap(deleteButton);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Continuar'));
        await tester.pumpAndSettle();

        expect(find.byType(PostDetailsPage), findsNothing);
      },
    );

    testWidgets(
      'should pop nothing when "Cancelar" is pressed in the confirmation dialog',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());

        final deleteButton = find.text('ELETAR');
        await tester.tap(deleteButton);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancelar'));
        await tester.pumpAndSettle();

        expect(find.byType(PostDetailsPage), findsOneWidget);
      },
    );
  });
}
