import 'package:flutter/material.dart';

/// 🧊 لوحة الألوان الجليدية والسريرية للتطبيق.
/// جميع الألوان باردة (جليدية) أو معدنية (فضية) لتجربة بصرية متناسقة.
class AppColors {
  AppColors._();

  /// أزرق جليدي عميق — اللون الرئيسي (أزرار، AppBar، أيقونات نشطة)
  static const Color color1 = Color.fromARGB(255, 52, 99, 160);
  static const Color color2 = Color(0xFF6B8CAF);
  static const Color color3 = Color(0xFFEAF4FB);
  static const Color color4 = Color(0xFFC5C9CC);
  static const Color color5 = Color(0xFFF5F7F9);

  // ─────────────────────────────────────────
  // 🧊 ألوان إضافية للتمييز
  // ─────────────────────────────────────────

  static const Color color6 = Color(0xFFB0E0E6);
  static const Color color7 = Color(0xFFE5E4E2);
  static const Color color8 = Color(0xFF2C4A6B);
  static const Color color9 = Color(0xFFADD8E6);
  static const Color color10 = Color(0xFF87CEEB);

  static const Color color11 = Color(0xFF2D1B4E); // بنفسجي ليلي
  static const Color color12 = Color(0xFF4A2570); // أرجواني عميق
  static const Color color13 = Color(0xFF7B2D8E); // بنفسجي ملكي
  static const Color color14 = Color(0xFFB03A8C); // فوشيا
  static const Color color15 = Color(0xFFE0457B); // وردي ساطع
  static const Color color16 = Color(0xFFFF6B6B); // مرجاني
  static const Color color17 = Color(0xFFFF8E53); // برتقالي غروب
  static const Color color18 = Color(0xFFFFB347); // عنبري
  static const Color color19 = Color(0xFFFFD98E); // ذهبي فاتح

  // ─────────────────────────────────────────
  // 🌈 تدرّج أيقونات الرودماب (جليدي → فضي)
  // ─────────────────────────────────────────
  static const List<Color> roadmapIconColors = [
    Color(0xFF1E3A5F), // جليدي عميق
    Color(0xFF2C4A6B), // فولاذي داكن
    Color(0xFF4A7FA7), // فولاذي
    Color(0xFF6B8CAF), // فولاذي فاتح
    Color(0xFF87CEEB), // سماوي
    Color(0xFFADD8E6), // أزرق ثلجي
    Color(0xFFB0E0E6), // فيروزي
    Color(0xFFC5C9CC), // فضي
    Color(0xFFD3D3D3), // رمادي فاتح
    Color(0xFF2D1B4E), // بنفسجي ليلي
    Color(0xFF4A2570), // أرجواني عميق
    Color(0xFF7B2D8E), // بنفسجي ملكي
    Color(0xFFB03A8C), // فوشيا
    Color(0xFFE0457B), // وردي ساطع
    Color(0xFFFF6B6B), // مرجاني
    Color(0xFFFF8E53), // برتقالي غروب
    Color(0xFFFFB347), // عنبري
    Color(0xFFFFD98E), // ذهبي فاتح
    // // =====================================
    Color(0xFF0B1F3A), // أزرق ليلي
    Color(0xFF123D6B), // أزرق محيطي
    Color(0xFF1A5F9E), // أزرق ملكي
    Color(0xFF1E88C7), // أزرق سماوي
    Color(0xFF26A8D6), // أزرق لازوردي
    Color(0xFF2EC4C4), // تركوازي
    Color(0xFF5ED9C0), // أخضر مائي
    Color(0xFF9AEBD3), // نعناعي
    Color(0xFFD0F7EA), // أخضر ثلجي
    // //============================
    Color(0xFF0F2E1F), // أخضر غابات داكن
    Color(0xFF1B4D32), // أخضر زمردي عميق
    Color(0xFF2A7A4B), // أخضر زمردي
    Color(0xFF3FA361), // أخضر ورقي
    Color(0xFF6BC46D), // أخضر ربيعي
    Color(0xFF9BDB6E), // أخضر ليموني
    Color(0xFFC8E86B), // أخضر مصفر
    Color(0xFF9BDB6E), // أخضر ليموني
    Color(0xFF6BC46D), // أخضر ربيعي
    Color(0xFF3FA361), // أخضر ورقي
    Color(0xFF2A7A4B), // أخضر زمردي
    Color(0xFF1B4D32), // أخضر زمردي عميق
    Color(0xFF1B4D32), // أخضر زمردي عميق
  ];
}
