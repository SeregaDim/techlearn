import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/content.dart';
import '../services/content_repository.dart';

/// Единое состояние приложения: тема, выбранный раздел, контент, прогресс.
class AppState extends ChangeNotifier {
  AppState(this._repo);

  static const _themeKey = 'theme';
  static const _readKey = 'read_topics';

  final ContentRepository _repo;
  SharedPreferences? _prefs;
  bool _disposed = false;

  ThemeMode themeMode = ThemeMode.dark;
  bool loading = true;
  String? error;

  List<TopicCategory> categories = const [];
  final Map<String, List<Topic>> _topics = {};
  Set<String> _read = {};

  /// null = «Главная» (обзор всех разделов).
  String? selectedId;

  TopicCategory? get selected => categoryById(selectedId);

  TopicCategory? categoryById(String? id) {
    if (id == null) {
      return null;
    }
    for (final c in categories) {
      if (c.id == id) {
        return c;
      }
    }
    return null;
  }

  List<Topic> topicsOf(String categoryId) => _topics[categoryId] ?? const [];

  bool isRead(Topic t) => _read.contains(t.key);

  int readCount(String categoryId) => topicsOf(categoryId).where(isRead).length;

  int get totalTopics => _topics.values.fold(0, (sum, l) => sum + l.length);

  int get readTotal =>
      _topics.values.fold(0, (sum, l) => sum + l.where(isRead).length);

  double get progress => totalTopics == 0 ? 0 : readTotal / totalTopics;

  /// Первая непройденная тема (во всём приложении или в одном разделе).
  Topic? nextUnread({String? categoryId}) {
    for (final c in categories) {
      if (categoryId != null && c.id != categoryId) {
        continue;
      }
      for (final t in topicsOf(c.id)) {
        if (!isRead(t)) {
          return t;
        }
      }
    }
    return null;
  }

  Future<void> init() async {
    loading = true;
    error = null;
    try {
      _prefs = await SharedPreferences.getInstance();
      themeMode =
          _prefs?.getString(_themeKey) == 'light' ? ThemeMode.light : ThemeMode.dark;
      _read = (_prefs?.getStringList(_readKey) ?? const <String>[]).toSet();
    } catch (e) {
      debugPrint('Настройки недоступны: $e');
    }
    try {
      categories = await _repo.loadCategories();
      _topics.clear();
      for (final c in categories) {
        _topics[c.id] = await _repo.loadTopics(c);
      }
    } catch (e) {
      error = 'Не удалось загрузить контент: $e';
    }
    loading = false;
    _notify();
  }

  void selectCategory(String? id) {
    selectedId = id;
    notifyListeners();
  }

  Future<void> setDark(bool dark) async {
    themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _prefs?.setString(_themeKey, dark ? 'dark' : 'light');
  }

  Future<void> toggleRead(Topic t) async {
    if (!_read.remove(t.key)) {
      _read.add(t.key);
    }
    notifyListeners();
    await _prefs?.setStringList(_readKey, _read.toList());
  }

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// Доступ к AppState из любого виджета: AppScope.of(context).
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope не найден в дереве виджетов');
    return scope!.notifier!;
  }
}
