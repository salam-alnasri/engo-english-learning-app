import 'package:engo/pages/page2/level_models.dart';
import 'package:flutter/material.dart';

// نُعيد تصدير النماذج حتى تبقى الاستيرادات القديمة تعمل:
// import 'package:engo/screens/levels/level_data.dart'; يعطي ReadingText و CefrLevel أيضًا.
export 'package:engo/pages/page2/level_models.dart';

/// المستويات بالترتيب الذي تظهر به على الشاشة (من الأسهل إلى الأصعب).
///
/// النصوص (texts) تُحمَّل الآن بشكل غير متزامن من ملفات JSON عبر
/// `StoriesRepository.load(level.code.toLowerCase())` — تُملأ القائمة هنا
/// عند تحميل التطبيق. تُستخدم للوصول المتزامن من الواجهات (التي لا تحتاج
/// إلى تعديل).
final List<CefrLevel> cefrLevels = [
  // ─────────────────────────────── A1 ───────────────────────────────
  CefrLevel(
    code: 'A1',
    nameAr: 'مبتدئ',
    icon: Icons.child_care_rounded,
    texts: const <ReadingText>[], // تُملأ من JSON عند التحميل
  ),
  // ─────────────────────────────── A2 ───────────────────────────────
  CefrLevel(
    code: 'A2',
    nameAr: 'ما قبل المتوسط',
    icon: Icons.backpack_rounded,
    texts: const <ReadingText>[],
  ),
  // ─────────────────────────────── B1 ──────────────────────────────
  CefrLevel(
    code: 'B1',
    nameAr: 'المتوسط',
    icon: Icons.menu_book_rounded,
    texts: const <ReadingText>[],
  ),
  // ─────────────────────────────── B2 ───────────────────────────────
  CefrLevel(
    code: 'B2',
    nameAr: 'فوق المتوسط',
    icon: Icons.insights_rounded,
    texts: const <ReadingText>[],
  ),
  // ─────────────────────────────── C1 ───────────────────────────────
  CefrLevel(
    code: 'C1',
    nameAr: 'المتقدم',
    icon: Icons.psychology_rounded,
    texts: const <ReadingText>[],
  ),
  // ─────────────────────────────── C2 ───────────────────────────────
  CefrLevel(
    code: 'C2',
    nameAr: 'الإتقان',
    icon: Icons.workspace_premium_rounded,
    texts: const <ReadingText>[],
  ),
];

/// إجمالي عدد القصص في كل المستويات.
int get totalStoriesCount =>
    cefrLevels.fold(0, (sum, level) => sum + level.texts.length);
