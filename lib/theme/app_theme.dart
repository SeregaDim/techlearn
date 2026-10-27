import 'package:flutter/material.dart';

extension ColorOpacity on Color {
  /// Прозрачность без устаревших API (работает на любой версии Flutter).
  Color op(double opacity) =>
      withAlpha((opacity.clamp(0.0, 1.0) * 255).round());
}

/// Цвета киберпанк-интерфейса для светлой и тёмной тем.
@immutable
class TechColors extends ThemeExtension<TechColors> {
  const TechColors({
    required this.bg,
    required this.bgAlt,
    required this.surface,
    required this.surfaceHigh,
    required this.border,
    required this.primary,
    required this.accent,
    required this.text,
    required this.textDim,
    required this.codeBg,
    required this.codeText,
    required this.glow,
    required this.success,
    required this.warning,
  });

  final Color bg;
  final Color bgAlt;
  final Color surface;
  final Color surfaceHigh;
  final Color border;
  final Color primary;
  final Color accent;
  final Color text;
  final Color textDim;
  final Color codeBg;
  final Color codeText;
  final Color glow;
  final Color success;
  final Color warning;

  static const dark = TechColors(
    bg: Color(0xFF050B1A),
    bgAlt: Color(0xFF081327),
    surface: Color(0xFF0B1A33),
    surfaceHigh: Color(0xFF102548),
    border: Color(0xFF1B3A6B),
    primary: Color(0xFF1E88FF),
    accent: Color(0xFF38BDF8),
    text: Color(0xFFE8F1FF),
    textDim: Color(0xFF8FA6C7),
    codeBg: Color(0xFF040A16),
    codeText: Color(0xFFBFE3FF),
    glow: Color(0xFF1E88FF),
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
  );

  static const light = TechColors(
    bg: Color(0xFFF1F6FE),
    bgAlt: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFE3EDFB),
    border: Color(0xFFC5D6F0),
    primary: Color(0xFF1565E0),
    accent: Color(0xFF0284C7),
    text: Color(0xFF0B1B33),
    textDim: Color(0xFF58708F),
    codeBg: Color(0xFF0F1B33),
    codeText: Color(0xFFD6E8FF),
    glow: Color(0xFF1565E0),
    success: Color(0xFF059669),
    warning: Color(0xFFB45309),
  );

  @override
  TechColors copyWith({Color? bg, Color? accent, Color? primary}) {
    return TechColors(
      bg: bg ?? this.bg,
      bgAlt: bgAlt,
      surface: surface,
      surfaceHigh: surfaceHigh,
      border: border,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      text: text,
      textDim: textDim,
      codeBg: codeBg,
      codeText: codeText,
      glow: glow,
      success: success,
      warning: warning,
    );
  }

  @override
  TechColors lerp(ThemeExtension<TechColors>? other, double t) {
    if (other is! TechColors) {
      return this;
    }
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return TechColors(
      bg: l(bg, other.bg),
      bgAlt: l(bgAlt, other.bgAlt),
      surface: l(surface, other.surface),
      surfaceHigh: l(surfaceHigh, other.surfaceHigh),
      border: l(border, other.border),
      primary: l(primary, other.primary),
      accent: l(accent, other.accent),
      text: l(text, other.text),
      textDim: l(textDim, other.textDim),
      codeBg: l(codeBg, other.codeBg),
      codeText: l(codeText, other.codeText),
      glow: l(glow, other.glow),
      success: l(success, other.success),
      warning: l(warning, other.warning),
    );
  }
}

extension TechTheme on BuildContext {
  TechColors get tc => Theme.of(this).extension<TechColors>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark => _build(Brightness.dark, TechColors.dark);
  static ThemeData get light => _build(Brightness.light, TechColors.light);

  static ThemeData _build(Brightness brightness, TechColors c) {
    final scheme = ColorScheme.fromSeed(
      seedColor: c.primary,
      brightness: brightness,
    ).copyWith(
      primary: c.primary,
      secondary: c.accent,
      surface: c.surface,
      onSurface: c.text,
      outline: c.border,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      extensions: [c],
    );
    return base.copyWith(
      scaffoldBackgroundColor: c.bg,
      textTheme: base.textTheme.apply(bodyColor: c.text, displayColor: c.text),
      dividerColor: c.border,
      appBarTheme: AppBarTheme(
        backgroundColor: c.bgAlt,
        foregroundColor: c.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: c.bgAlt,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.surfaceHigh,
        contentTextStyle: TextStyle(color: c.text),
      ),
    );
  }
}
