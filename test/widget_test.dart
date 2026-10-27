import 'package:flutter_test/flutter_test.dart';
import 'package:techlearn/models/content.dart';

void main() {
  test('Topic.fromJson читает блоки и подставляет значения по умолчанию', () {
    final topic = Topic.fromJson(
      {
        'title': 'Тест',
        'blocks': [
          {'type': 'paragraph', 'text': 'Привет, мир'},
          {'type': 'code', 'language': 'bash', 'text': 'ls -la'},
        ],
      },
      categoryId: 'linux',
      fallbackId: 'test',
    );

    expect(topic.id, 'test');
    expect(topic.key, 'linux/test');
    expect(topic.order, 1000);
    expect(topic.blocks.length, 2);
    expect(topic.readingMinutes, 1);
  });

  test('TopicCategory.fromJson использует id как папку по умолчанию', () {
    final cat = TopicCategory.fromJson({'id': 'git', 'title': 'Git'});
    expect(cat.folder, 'git');
    expect(cat.icon, 'folder');
  });
}
