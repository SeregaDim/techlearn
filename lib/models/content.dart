import 'dart:math' as math;

/// Главный раздел (пункт бургер-меню). Описывается в assets/content/categories.json.
class TopicCategory {
  const TopicCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.folder,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;

  /// Имя подпапки в assets/content/, где лежат JSON-файлы тем.
  final String folder;

  /// Имя иконки из lib/utils/icon_map.dart.
  final String icon;

  factory TopicCategory.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    return TopicCategory(
      id: id,
      title: (json['title'] ?? id) as String,
      subtitle: (json['subtitle'] ?? '') as String,
      folder: (json['folder'] ?? id) as String,
      icon: (json['icon'] ?? 'folder') as String,
    );
  }
}

/// Один блок статьи: heading, paragraph, list, steps, code, note.
class ContentBlock {
  const ContentBlock({
    required this.type,
    this.text = '',
    this.items = const [],
    this.language,
    this.kind,
  });

  final String type;
  final String text;
  final List<String> items;
  final String? language;

  /// Для note: tip | warning | info.
  final String? kind;

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      type: (json['type'] ?? 'paragraph') as String,
      text: (json['text'] ?? '') as String,
      items: ((json['items'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      language: json['language'] as String?,
      kind: json['kind'] as String?,
    );
  }
}

/// Тема (подпункт раздела) = один JSON-файл.
class Topic {
  const Topic({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.order,
    required this.blocks,
  });

  final String id;
  final String categoryId;
  final String title;
  final String subtitle;
  final String icon;
  final int order;
  final List<ContentBlock> blocks;

  /// Уникальный ключ темы (для сохранения прогресса).
  String get key => '$categoryId/$id';

  int get readingMinutes {
    var words = 0;
    for (final b in blocks) {
      if (b.type == 'code') {
        continue;
      }
      words += _countWords(b.text);
      for (final i in b.items) {
        words += _countWords(i);
      }
    }
    return math.max(1, (words / 160).ceil());
  }

  factory Topic.fromJson(
    Map<String, dynamic> json, {
    required String categoryId,
    required String fallbackId,
  }) {
    final rawBlocks = (json['blocks'] as List?) ?? const [];
    return Topic(
      id: (json['id'] ?? fallbackId) as String,
      categoryId: categoryId,
      title: (json['title'] ?? fallbackId) as String,
      subtitle: (json['subtitle'] ?? '') as String,
      icon: (json['icon'] ?? 'article') as String,
      order: (json['order'] as num?)?.toInt() ?? 1000,
      blocks: rawBlocks
          .whereType<Map<String, dynamic>>()
          .map(ContentBlock.fromJson)
          .toList(),
    );
  }
}

int _countWords(String s) {
  final t = s.trim();
  return t.isEmpty ? 0 : t.split(RegExp(r'\s+')).length;
}
