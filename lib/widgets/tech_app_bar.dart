import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'theme_switch.dart';

/// Шапка: бургер слева, логотип, справа переключатель темы.
/// back = true — вместо бургера кнопка «назад» (экран статьи).
PreferredSizeWidget buildTechAppBar(
  BuildContext context, {
  bool back = false,
  String? title,
}) {
  final tc = context.tc;
  return AppBar(
    automaticallyImplyLeading: false,
    titleSpacing: 0,
    leading: back
        ? IconButton(
            tooltip: 'Назад',
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.maybePop(context),
          )
        : Builder(
            builder: (ctx) => IconButton(
              tooltip: 'Меню',
              icon: const Icon(Icons.menu_rounded, size: 28),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
    title: title == null
        ? const TechLogo()
        : Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
    actions: const [ThemeSwitch(), SizedBox(width: 16)],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(height: 1, color: tc.border.op(0.7)),
    ),
  );
}

class TechLogo extends StatelessWidget {
  const TechLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            colors: [tc.accent, tc.primary],
          ).createShader(rect),
          child: const Icon(Icons.bolt_rounded, size: 32, color: Colors.white),
        ),
        const SizedBox(width: 6),
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
            children: [
              const TextSpan(text: 'Tech'),
              TextSpan(text: 'Learn', style: TextStyle(color: tc.accent)),
            ],
          ),
        ),
      ],
    );
  }
}
