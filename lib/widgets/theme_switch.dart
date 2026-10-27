import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Пилюля «солнце / луна» для переключения светлой и тёмной темы.
class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final dark = context.isDark;

    return Semantics(
      button: true,
      label: 'Переключить тему',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => AppScope.of(context).setDark(!dark),
        child: Container(
          width: 68,
          height: 34,
          decoration: BoxDecoration(
            color: tc.surface,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: tc.border),
            boxShadow: [
              if (dark) BoxShadow(color: tc.glow.op(0.25), blurRadius: 10),
            ],
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: dark ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [tc.accent, tc.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(color: tc.glow.op(0.5), blurRadius: 8),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.light_mode_rounded,
                    size: 17,
                    color: dark ? tc.textDim : Colors.white,
                  ),
                  Icon(
                    Icons.dark_mode_rounded,
                    size: 17,
                    color: dark ? Colors.white : tc.textDim,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
