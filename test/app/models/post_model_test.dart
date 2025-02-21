import 'package:flutter_feed_test/app/models/post_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../load_json.dart';
import '../../sample/post.dart';

void main() async {
  final postJson = await loadJson('test/json/post.json');

  group('PostModel =>', () {
    test('should create a PostModel instance correctly', () {
      expect(postSample.userId, 1);
      expect(postSample.id, 101);
      expect(postSample.title, "Título do Post");
      expect(postSample.body, "Conteúdo do post aqui.");
    });

    test('should convert a JSON into a PostModel object correctly', () {
      final postFromJson = PostModel.fromJson(postJson);

      expect(postFromJson, equals(postSample));
    });

    test('should convert a PostModel object into JSON correctly', () {
      final json = postSample.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['userId'], postSample.userId);
      expect(json['id'], postSample.id);
      expect(json['title'], postSample.title);
      expect(json['body'], postSample.body);
    });

    test('should create a new modified instance with copyWith correctly', () {
      final modifiedPost = postSample.copyWith(title: "Novo Título");

      expect(modifiedPost.title, "Novo Título");
      expect(modifiedPost.userId, postSample.userId);
      expect(modifiedPost.id, postSample.id);
      expect(modifiedPost.body, postSample.body);
    });

    test('should ensure object equality with the same values (Equatable)', () {
      const anotherPost = PostModel(
        userId: 1,
        id: 101,
        title: "Título do Post",
        body: "Conteúdo do post aqui.",
      );

      expect(postSample, equals(anotherPost));
    });
  });
}
