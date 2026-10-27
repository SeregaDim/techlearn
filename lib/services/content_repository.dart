import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../config.dart';
import '../models/content.dart';

/// Читает контент из assets/content/.
///
///  * assets/content/categories.json — список разделов (бургер-меню)
///  * assets/content/<folder>/*.json  — темы раздела, каждая в своём файле
///
/// Список файлов в папке раздела определяется автоматически через
/// AssetManifest, поэтому для новой темы достаточно положить JSON в папку.
class ContentRepository {
  List<String>? _assetPaths;

  Future<List<TopicCategory>> loadCategories() async {
    final raw = await rootBundle.loadString('$kContentRoot/categories.json');
    final list = (jsonDecode(raw) as List).whereType<Map<String, dynamic>>();
    return list.map(TopicCategory.fromJson).toList();
  }

  Future<List<Topic>> loadTopics(TopicCategory category) async {
    final prefix = '$kContentRoot/${category.folder}/';
    final paths = await _allAssets();
    final files = paths
        .where((p) => p.startsWith(prefix) && p.endsWith('.json'))
        .toList()
      ..sort();

    final topics = <Topic>[];
    for (final path in files) {
      try {
        final raw = await rootBundle.loadString(path);
        final json = jsonDecode(raw) as Map<String, dynamic>;
        final fileName = path.split('/').last;
        final fallbackId = fileName.substring(0, fileName.length - 5);
        topics.add(Topic.fromJson(
          json,
          categoryId: category.id,
          fallbackId: fallbackId,
        ));
      } catch (e) {
        // Один сломанный файл не должен ронять весь раздел.
        debugPrint('Не удалось прочитать $path: $e');
      }
    }
    topics.sort((a, b) {
      final byOrder = a.order.compareTo(b.order);
      return byOrder != 0 ? byOrder : a.title.compareTo(b.title);
    });
    return topics;
  }

  Future<List<String>> _allAssets() async {
    final cached = _assetPaths;
    if (cached != null) {
      return cached;
    }
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    return _assetPaths = manifest.listAssets();
  }
}
