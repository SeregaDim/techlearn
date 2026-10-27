import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'neon_card.dart';

/// Карточка раздела/темы: иконка, заголовок, описание, прогресс или время.
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
    this.progress,
    this.done = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? trailing;
  final double? progress;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return NeonCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: tc.surfaceHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tc.accent.op(0.5)),
            ),
            child: Icon(icon, size: 26, color: tc.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(
                      done
                          ? Icons.check_circle_rounded
                          : Icons.chevron_right_rounded,
                      size: 20,
                      color: done ? tc.success : tc.textDim,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: tc.textDim),
                ),
                if (trailing != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (progress != null) ...[
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 5,
                              backgroundColor: tc.border.op(0.6),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(tc.accent),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ] else
                        Icon(Icons.schedule_rounded,
                            size: 13, color: tc.textDim),
                      if (progress == null) const SizedBox(width: 4),
                      Text(
                        trailing!,
                        style: TextStyle(fontSize: 12, color: tc.textDim),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
