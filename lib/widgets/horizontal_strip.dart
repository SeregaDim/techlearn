import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'neon_card.dart';

class StripItem {
  const StripItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.done = false,
    this.selected = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool done;
  final bool selected;
}

/// Горизонтально прокручиваемая лента кнопок.
class HorizontalStrip extends StatelessWidget {
  const HorizontalStrip({super.key, required this.items});

  final List<StripItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => _StripButton(item: items[i]),
      ),
    );
  }
}

class _StripButton extends StatelessWidget {
  const _StripButton({required this.item});

  final StripItem item;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return SizedBox(
      width: 92,
      child: Stack(
        children: [
          Positioned.fill(
            child: NeonCard(
              selected: item.selected,
              onTap: item.onTap,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: 30,
                    color: item.selected ? Colors.white : tc.accent,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (item.done)
            Positioned(
              top: 6,
              right: 6,
              child: Icon(Icons.check_circle_rounded,
                  size: 15, color: tc.success),
            ),
        ],
      ),
    );
  }
}
