import 'package:flutter/material.dart';

import '../models/content.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/icon_map.dart';
import '../widgets/article_blocks.dart';
import '../widgets/neon_card.dart';
import '../widgets/tech_app_bar.dart';

/// Открывает статью. replace = true заменяет текущую (для «Вперёд/Назад»).
void openTopic(BuildContext context, Topic topic, {bool replace = false}) {
  final route = MaterialPageRoute<void>(
    builder: (_) => ArticleScreen(topic: topic),
  );
  if (replace) {
    Navigator.pushReplacement(context, route);
  } else {
    Navigator.push(context, route);
  }
}

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final tc = context.tc;
    final siblings = app.topicsOf(topic.categoryId);
    final index = siblings.indexWhere((t) => t.key == topic.key);
    final prev = index > 0 ? siblings[index - 1] : null;
    final next =
        index >= 0 && index < siblings.length - 1 ? siblings[index + 1] : null;
    final category = app.categoryById(topic.categoryId);
    final read = app.isRead(topic);

    return Scaffold(
      appBar: buildTechAppBar(context, back: true, title: topic.title),
      body: TechBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: tc.surfaceHigh,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: tc.accent.op(0.6)),
                        boxShadow: [
                          BoxShadow(color: tc.glow.op(0.3), blurRadius: 14),
                        ],
                      ),
                      child: Icon(iconFor(topic.icon), size: 32, color: tc.accent),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (category != null)
                            Text(
                              category.title.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: tc.accent,
                              ),
                            ),
                          const SizedBox(height: 2),
                          Text(
                            topic.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (topic.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    topic.subtitle,
                    style: TextStyle(fontSize: 15, height: 1.45, color: tc.textDim),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 15, color: tc.textDim),
                    const SizedBox(width: 5),
                    Text(
                      '≈ ${topic.readingMinutes} мин чтения',
                      style: TextStyle(fontSize: 13, color: tc.textDim),
                    ),
                  ],
                ),
                Divider(height: 28, color: tc.border),
                ArticleBody(blocks: topic.blocks),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: () => app.toggleRead(topic),
                  icon: Icon(
                    read
                        ? Icons.check_circle_rounded
                        : Icons.check_circle_outline_rounded,
                  ),
                  label: Text(read ? 'Пройдено' : 'Отметить как пройденное'),
                  style: FilledButton.styleFrom(
                    backgroundColor: read ? tc.success : tc.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: prev == null
                          ? const SizedBox.shrink()
                          : _NavButton(
                              label: prev.title,
                              leading: true,
                              onTap: () => openTopic(context, prev, replace: true),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: next == null
                          ? const SizedBox.shrink()
                          : _NavButton(
                              label: next.title,
                              leading: false,
                              onTap: () => openTopic(context, next, replace: true),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.leading,
    required this.onTap,
  });

  final String label;
  final bool leading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final arrow = Icon(
      leading ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
      size: 20,
      color: tc.accent,
    );
    return NeonCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          if (leading) ...[arrow, const SizedBox(width: 8)],
          Expanded(
            child: Column(
              crossAxisAlignment:
                  leading ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  leading ? 'Назад' : 'Далее',
                  style: TextStyle(fontSize: 11, color: tc.textDim),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (!leading) ...[const SizedBox(width: 8), arrow],
        ],
      ),
    );
  }
}
