import 'package:flutter/material.dart';

import '../config.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/icon_map.dart';
import 'tech_app_bar.dart';
import 'theme_switch.dart';

/// Бургер-меню: «Главная», разделы из categories.json, служебные пункты, тема.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final tc = context.tc;

    void soon(String name) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(SnackBar(content: Text('$name — скоро')));
    }

    void select(String? id) {
      app.selectCategory(id);
      Navigator.pop(context);
    }

    return Drawer(
      width: 312,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
              child: Row(
                children: [
                  const TechLogo(),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Закрыть',
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const _ProfileTile(),
            Divider(height: 1, color: tc.border),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                children: [
                  _DrawerItem(
                    icon: Icons.home_rounded,
                    label: 'Главная',
                    selected: app.selectedId == null,
                    onTap: () => select(null),
                  ),
                  for (final c in app.categories)
                    _DrawerItem(
                      icon: iconFor(c.icon),
                      label: c.title,
                      selected: app.selectedId == c.id,
                      onTap: () => select(c.id),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1, color: tc.border),
                  ),
                  _DrawerItem(
                    icon: Icons.folder_open_rounded,
                    label: 'Проекты',
                    onTap: () => soon('Проекты'),
                  ),
                  _DrawerItem(
                    icon: Icons.sticky_note_2_outlined,
                    label: 'Заметки',
                    onTap: () => soon('Заметки'),
                  ),
                  _DrawerItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Профиль',
                    onTap: () => soon('Профиль'),
                  ),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    label: 'Настройки',
                    onTap: () => soon('Настройки'),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: tc.border)),
              ),
              child: Row(
                children: [
                  const ThemeSwitch(),
                  const SizedBox(width: 14),
                  const Text(
                    'Тема',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Switch(
                    value: context.isDark,
                    onChanged: (v) => app.setDark(v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile();

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [tc.accent, tc.primary]),
              boxShadow: [BoxShadow(color: tc.glow.op(0.5), blurRadius: 12)],
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        kUserName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (kShowProBadge) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: tc.accent),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.workspace_premium_rounded,
                                size: 14, color: tc.accent),
                            const SizedBox(width: 3),
                            Text(
                              'Pro',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: tc.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  kUserTagline,
                  style: TextStyle(fontSize: 13, color: tc.textDim),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: selected
                ? LinearGradient(colors: [tc.primary, tc.primary.op(0.65)])
                : null,
            border: selected ? Border.all(color: tc.accent.op(0.7)) : null,
            boxShadow: [
              if (selected) BoxShadow(color: tc.glow.op(0.35), blurRadius: 12),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: selected ? Colors.white : tc.text.op(0.85),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected ? Colors.white : tc.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
