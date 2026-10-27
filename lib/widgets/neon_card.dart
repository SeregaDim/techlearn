import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Карточка с неоновой рамкой и свечением (в светлой теме — без свечения).
class NeonCard extends StatelessWidget {
  const NeonCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(12),
    this.selected = false,
    this.radius = 16,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool selected;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: selected ? tc.accent : tc.border),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          if (context.isDark || selected)
            BoxShadow(
              color: tc.glow.op(selected ? 0.38 : 0.10),
              blurRadius: selected ? 18 : 10,
            ),
        ],
      ),
      child: Material(
        color: selected ? tc.surfaceHigh : tc.surface,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Фон экрана: вертикальный градиент.
class TechBackground extends StatelessWidget {
  const TechBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [tc.bg, tc.bgAlt],
        ),
      ),
      child: child,
    );
  }
}

/// Тонкая «технологическая» сетка для баннера.
class GridPainter extends CustomPainter {
  const GridPainter({required this.color, this.step = 28});

  final Color color;
  final double step;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.step != step;
}
