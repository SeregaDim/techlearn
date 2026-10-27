import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/content.dart';
import '../theme/app_theme.dart';

const List<String> _monoFallback = ['Menlo', 'Consolas', 'Roboto Mono'];

/// Рисует статью из списка блоков JSON.
/// Поддерживаются: heading, paragraph, list, steps, code, note.
/// В тексте работает `встроенный код` в обратных кавычках.
class ArticleBody extends StatelessWidget {
  const ArticleBody({super.key, required this.blocks});

  final List<ContentBlock> blocks;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final b in blocks) _buildBlock(context, b)],
    );
  }

  Widget _buildBlock(BuildContext context, ContentBlock b) {
    switch (b.type) {
      case 'heading':
        return _Heading(b.text);
      case 'list':
        return _ListBlock(items: b.items, numbered: false);
      case 'steps':
        return _ListBlock(items: b.items, numbered: true);
      case 'code':
        return _CodeBlock(code: b.text, language: b.language);
      case 'note':
        return _NoteBlock(text: b.text, kind: b.kind ?? 'info');
      case 'paragraph':
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: _RichText(b.text),
        );
    }
  }
}

TextStyle _body(BuildContext context) => TextStyle(
      fontSize: 15.5,
      height: 1.6,
      color: context.tc.text.op(0.92),
    );

class _RichText extends StatelessWidget {
  const _RichText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final base = _body(context);
    final parts = text.split('`');
    final spans = <InlineSpan>[];
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) {
        continue;
      }
      if (i.isOdd) {
        spans.add(TextSpan(
          text: parts[i],
          style: base.copyWith(
            fontFamily: 'monospace',
            fontFamilyFallback: _monoFallback,
            fontSize: 14,
            color: tc.accent,
            backgroundColor: tc.surfaceHigh,
          ),
        ));
      } else {
        spans.add(TextSpan(text: parts[i]));
      }
    }
    return Text.rich(TextSpan(style: base, children: spans));
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 6),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: tc.accent,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [BoxShadow(color: tc.glow.op(0.6), blurRadius: 8)],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListBlock extends StatelessWidget {
  const _ListBlock({required this.items, required this.numbered});

  final List<String> items;
  final bool numbered;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (numbered)
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(top: 2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: tc.accent),
                      ),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: tc.accent,
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 6, right: 6),
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: tc.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  SizedBox(width: numbered ? 12 : 8),
                  Expanded(child: _RichText(items[i])),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code, this.language});

  final String code;
  final String? language;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: tc.codeBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 2, 2, 2),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: tc.border.op(0.6))),
            ),
            child: Row(
              children: [
                Text(
                  (language ?? 'code').toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: tc.accent,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Копировать',
                  visualDensity: VisualDensity.compact,
                  iconSize: 18,
                  icon: const Icon(Icons.copy_rounded, color: Color(0xFF8FA6C7)),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await Clipboard.setData(ClipboardData(text: code));
                    messenger.showSnackBar(const SnackBar(
                      content: Text('Скопировано'),
                      duration: Duration(milliseconds: 1200),
                    ));
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(14),
            child: SelectableText(
              code,
              style: TextStyle(
                fontFamily: 'monospace',
                fontFamilyFallback: _monoFallback,
                fontSize: 13,
                height: 1.5,
                color: tc.codeText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteBlock extends StatelessWidget {
  const _NoteBlock({required this.text, required this.kind});

  final String text;
  final String kind;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final Color color;
    final IconData icon;
    final String label;
    switch (kind) {
      case 'warning':
        color = tc.warning;
        icon = Icons.warning_amber_rounded;
        label = 'Осторожно';
      case 'tip':
        color = tc.success;
        icon = Icons.lightbulb_outline_rounded;
        label = 'Совет';
      default:
        color = tc.accent;
        icon = Icons.info_outline_rounded;
        label = 'Заметка';
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.op(0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.op(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                _RichText(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
