// lib/app/theme/app_theme.dart
//
// 主題：角色感知雙主題（#9）—— 醫生藍 / 復康青綠 × 明暗兩檔。
// 以 colorSchemeSeed 驅動 Material 3 配色；角色強調色經 ThemeExtension<RoleTheme>
// 暴露，供組件以 type-safe 方式讀取（後續 #10 高對比變體在此擴充）。
// 無障礙：字體縮放由 App 層 MediaQuery 控制；強調色對比遵循 scheme.onPrimary（WCAG AA）。

import 'package:flutter/material.dart';

import '../../features/auth/domain/user_role.dart';

/// 角色強調色。組件以 `Theme.of(context).extension<RoleTheme>()` 讀取。
@immutable
class RoleTheme extends ThemeExtension<RoleTheme> {
  const RoleTheme({required this.accent, required this.onAccent});

  final Color accent;
  final Color onAccent;

  @override
  RoleTheme copyWith({Color? accent, Color? onAccent}) => RoleTheme(
        accent: accent ?? this.accent,
        onAccent: onAccent ?? this.onAccent,
      );

  @override
  RoleTheme lerp(ThemeExtension<RoleTheme>? other, double t) {
    if (other is! RoleTheme) return this;
    return RoleTheme(
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
    );
  }
}

class AppTheme {
  AppTheme._();

  static const _doctorSeed = Color(0xFF0B6E99); // 醫療藍：清晰、可信賴
  static const _patientSeed = Color(0xFF2E7D5B); // 復康青綠：溫和、親切

  static Color _seedFor(UserRole role) =>
      role == UserRole.patient ? _patientSeed : _doctorSeed;

  /// 依角色與明暗構建主題。未登入（role 為 null）時預設醫生藍。
  /// [elder]：長者模式（增大基礎字號）；[highContrast]：高對比（M3 contrastLevel 拉滿 + 純色背景）。
  static ThemeData forRole(
    UserRole role, {
    Brightness brightness = Brightness.light,
    bool elder = false,
    bool highContrast = false,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seedFor(role),
      brightness: brightness,
      contrastLevel: highContrast ? 1.0 : 0.0,
    );
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: highContrast
          ? (isDark ? Colors.black : Colors.white)
          : (isDark ? const Color(0xFF121417) : const Color(0xFFF7F9FB)),
      // 確保文字與背景對比度達 WCAG AA；長者模式加大基礎字號
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: elder ? 20 : 16),
      ),
      // 行動優先：適應平台密度
      visualDensity: VisualDensity.adaptivePlatformDensity,
      extensions: [
        RoleTheme(accent: scheme.primary, onAccent: scheme.onPrimary),
      ],
    );
  }
}
