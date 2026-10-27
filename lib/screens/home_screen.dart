import 'package:flutter/material.dart';

import '../models/content.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/icon_map.dart';
import '../widgets/app_drawer.dart';
import '../widgets/hero_banner.dart';
import '../widgets/horizontal_strip.dart';
import '../widgets/info_card.dart';
import '../widgets/neon_card.dart';
import '../widgets/progress_footer.dart';
import '../widgets/tech_app_bar.dart';
import 'article_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final ready = !app.loading && app.error == null;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: buildTechAppBar(context),
      body: TechBackground(
        child: app.loading
            ? const Center(child: CircularProgressIndicator())
            : app.error != null
                ? _ErrorView(message: app.error!, onRetry: app.init)
                : const _HomeBody(),
      ),
      bottomNavigationBar: ready ? const ProgressFooter() : null,
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final cat = app.selected;
    final topics = cat == null ? const <Topic>[] : app.topicsOf(cat.id);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 28),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildHero(context, app, cat, topics),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SectionTitle(
                icon: Icons.subdirectory_arrow_right_rounded,
                text: cat == null
                    ? 'Выберите направление'
                    : 'Подтемы · ${cat.title}',
              ),
            ),
            const SizedBox(height: 6),
            if (cat != null && topics.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _EmptyCategory(folder: cat.folder),
              )
            else
              HorizontalStrip(items: _stripItems(context, app, cat, topics)),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SectionTitle(
                icon: Icons.star_outline_rounded,
                text: cat == null ? 'Разделы' : 'Темы раздела',
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _cards(context, app, cat, topics),
            ),
            if (cat == null) ...[
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _PracticeBanner(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHero(
    BuildContext context,
    AppState app,
    TopicCategory? cat,
    List<Topic> topics,
  ) {
    if (cat == null) {
      return HeroBanner(
        title: 'Твой путь\nв мир технологий',
        subtitle: 'Изучай, практикуй, создавай.\nОт основ до реальных проектов.',
        buttonLabel: 'Начать обучение',
        onPressed: () {
          final next = app.nextUnread();
          if (next != null) {
            openTopic(context, next);
          } else if (app.categories.isNotEmpty) {
            app.selectCategory(app.categories.first.id);
          }
        },
      );
    }
    return HeroBanner(
      title: cat.title,
      subtitle: cat.subtitle,
      icon: iconFor(cat.icon),
      buttonLabel: topics.isEmpty ? null : 'Продолжить',
      onPressed: topics.isEmpty
          ? null
          : () => openTopic(
                context,
                app.nextUnread(categoryId: cat.id) ?? topics.first,
              ),
    );
  }

  List<StripItem> _stripItems(
    BuildContext context,
    AppState app,
    TopicCategory? cat,
    List<Topic> topics,
  ) {
    if (cat == null) {
      return [
        for (final c in app.categories)
          StripItem(
            label: c.title,
            icon: iconFor(c.icon),
            onTap: () => app.selectCategory(c.id),
          ),
      ];
    }
    return [
      for (final t in topics)
        StripItem(
          label: t.title,
          icon: iconFor(t.icon),
          done: app.isRead(t),
          onTap: () => openTopic(context, t),
        ),
    ];
  }

  Widget _cards(
    BuildContext context,
    AppState app,
    TopicCategory? cat,
    List<Topic> topics,
  ) {
    final cards = <Widget>[
      if (cat == null)
        for (final c in app.categories)
          InfoCard(
            icon: iconFor(c.icon),
            title: c.title,
            subtitle: c.subtitle,
            progress: app.topicsOf(c.id).isEmpty
                ? 0
                : app.readCount(c.id) / app.topicsOf(c.id).length,
            trailing: '${app.readCount(c.id)} / ${app.topicsOf(c.id).length}',
            onTap: () => app.selectCategory(c.id),
          )
      else
        for (final t in topics)
          InfoCard(
            icon: iconFor(t.icon),
            title: t.title,
            subtitle: t.subtitle,
            trailing: '≈ ${t.readingMinutes} мин',
            done: app.isRead(t),
            onTap: () => openTopic(context, t),
          ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 96,
          ),
          itemBuilder: (context, i) => cards[i],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return Row(
      children: [
        Icon(icon, color: tc.accent, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _EmptyCategory extends StatelessWidget {
  const _EmptyCategory({required this.folder});

  final String folder;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return NeonCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.folder_open_rounded, color: tc.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'В этом разделе пока нет тем. Добавьте JSON-файл в '
              'assets/content/$folder/',
              style: TextStyle(color: tc.textDim, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _PracticeBanner extends StatelessWidget {
  const _PracticeBanner();

  static const _snippet = "const app = express()\n"
      "app.get('/', (req, res) => {\n"
      "  res.json({ ok: true })\n"
      "})\n"
      "app.listen(3000)";

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return NeonCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Практика — лучший учитель',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Реальные задачи, проекты и код. Учись на практике, '
                  'а не только на теории.',
                  style: TextStyle(fontSize: 12.5, color: tc.textDim, height: 1.4),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Проекты — скоро')),
                  ),
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: const Text('Открыть проект'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: tc.accent,
                    side: BorderSide(color: tc.accent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: tc.codeBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: tc.border),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  _snippet,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontFamilyFallback: const ['Menlo', 'Consolas'],
                    fontSize: 11,
                    height: 1.5,
                    color: tc.codeText,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Повторить')),
          ],
        ),
      ),
    );
  }
}
