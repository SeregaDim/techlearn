import 'package:flutter/material.dart';

/// Иконки, на которые можно ссылаться из JSON строкой: "icon": "terminal".
/// Нужна новая иконка — добавьте строку в карту.
IconData iconFor(String? name) => _icons[name] ?? Icons.article_rounded;

const Map<String, IconData> _icons = {
  // разделы
  'dns': Icons.dns_rounded,
  'code': Icons.code_rounded,
  'fork': Icons.fork_right_rounded,
  'data_object': Icons.data_object_rounded,
  'storage': Icons.storage_rounded,
  'terminal': Icons.terminal_rounded,
  'loop': Icons.all_inclusive_rounded,
  'folder': Icons.folder_rounded,
  // темы
  'article': Icons.article_rounded,
  'download': Icons.download_rounded,
  'inventory': Icons.inventory_2_rounded,
  'layers': Icons.layers_rounded,
  'settings': Icons.settings_rounded,
  'shield': Icons.shield_rounded,
  'bolt': Icons.bolt_rounded,
  'description': Icons.description_rounded,
  'play': Icons.play_arrow_rounded,
  'lock': Icons.lock_rounded,
  'cloud': Icons.cloud_rounded,
  'api': Icons.api_rounded,
  'web': Icons.web_rounded,
  'html': Icons.html_rounded,
  'css': Icons.css_rounded,
  'javascript': Icons.javascript_rounded,
  'rocket': Icons.rocket_launch_rounded,
  'bug': Icons.bug_report_rounded,
  'sync': Icons.sync_rounded,
  'hub': Icons.hub_rounded,
  'key': Icons.key_rounded,
  'speed': Icons.speed_rounded,
  'school': Icons.school_rounded,
  'build': Icons.build_rounded,
  'people': Icons.people_rounded,
  'table': Icons.table_chart_rounded,
  'search': Icons.search_rounded,
  'route': Icons.alt_route_rounded,
  'merge': Icons.merge_type_rounded,
  'memory': Icons.memory_rounded,
  'router': Icons.router_rounded,
  'dashboard': Icons.dashboard_rounded,
  'task': Icons.task_alt_rounded,
  'schedule': Icons.schedule_rounded,
};
