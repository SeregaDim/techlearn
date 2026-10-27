import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'neon_card.dart';

/// Верхний баннер. Если положить картинку в assets/images/hero.png
/// (например, робота из макета), она появится справа автоматически.
class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onPressed,
    this.icon = Icons.memory_rounded,
  });

  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return Container(
      height: 214,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0C3270), Color(0xFF050B1A)],
        ),
        border: Border.all(color: tc.accent.op(0.5)),
        boxShadow: [
          BoxShadow(color: tc.glow.op(0.30), blurRadius: 24, spreadRadius: -2),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(color: const Color(0xFF38BDF8).op(0.07)),
            ),
          ),
          Positioned(
            right: -30,
            top: 0,
            bottom: 0,
            width: 200,
            child: _HeroArt(icon: icon),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: SizedBox.expand(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _HeroText(
                  key: ValueKey(title),
                  title: title,
                  subtitle: subtitle,
                  buttonLabel: buttonLabel,
                  onPressed: onPressed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onPressed,
  });

  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFB6C8E6),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (onPressed != null && buttonLabel != null)
            FilledButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(buttonLabel!),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1E88FF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: tc.accent),
                ),
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _HeroArt extends StatelessWidget {
  const _HeroArt({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final tc = context.tc;
    return Image.asset(
      'assets/images/hero.png',
      fit: BoxFit.cover,
      alignment: Alignment.centerRight,
      errorBuilder: (context, error, stackTrace) => Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [tc.accent.op(0.35), tc.accent.op(0)],
            ),
          ),
          child: Icon(icon, size: 84, color: tc.accent.op(0.9)),
        ),
      ),
    );
  }
}
