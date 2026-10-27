import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Нижняя полоса «Твой прогресс» (доля пройденных тем).
class ProgressFooter extends StatelessWidget {
  const ProgressFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final app = AppScope.of(context);
    final percent = (app.progress * 100).round();

    return Container(
      decoration: BoxDecoration(
        color: tc.bgAlt,
        border: Border(top: BorderSide(color: tc.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: tc.accent, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Твой прогресс · ${app.readTotal} из ${app.totalTopics} тем',
                      style: TextStyle(fontSize: 12, color: tc.textDim),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: app.progress,
                        minHeight: 6,
                        backgroundColor: tc.border.op(0.6),
                        valueColor: AlwaysStoppedAnimation<Color>(tc.accent),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$percent%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
