import 'package:engo/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// مربع حوار التأكيد قبل بدء الدرس.
///
/// يظهر عند الضغط على أيقونة مرحلة في الـ Roadmap ويعرض:
/// - اسم التبويب (الفئة/المجموعة) في الأعلى
/// - اسم ورقم الدرس (مثال: "الدرس ١ من ٥")
/// - زر "متابعة" في الأسفل
///
/// عند الضغط على أي مكان خارج المربع، يُغلق تلقائياً
/// (بفضل `barrierDismissible: true`).
///
/// **للتعديل على المظهر**: غيّر القيم في [_LessonDialogStyle].
class LessonStartDialog {
  /// يُظهر المربع ويعيد `true` إذا ضغط المستخدم "متابعة"، و`null` إذا أُغلق.
  static Future<bool?> show({
    required BuildContext context,
    required String categoryName,
    required int lessonNumber,
    required int lessonTotalInLine,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // الإغلاق عند الضغط خارج المربع
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => _LessonDialog(
        categoryName: categoryName,
        lessonNumber: lessonNumber,
        lessonTotalInLine: lessonTotalInLine,
      ),
    );
  }
}

class _LessonDialogStyle {
  // 🟢 غيّر هذه القيم لتعديل المظهر بالكامل.

  // الأبعاد
  static const double cardWidth = 320;
  static const double cardPadding = 24;
  static const double cardRadius = 28;

  // الألوان
  static const Color backgroundColor = Colors.white;
  static const Color accentColor = Color(0xFF1E3A5F); // جليدي عميق

  static const Color categoryColor = Color(0xFF6B8CAF); // فولاذي
  static const Color titleColor = Color(0xFF1E3A5F);
  static const Color buttonColor = Color(0xFF1E3A5F);
  static const Color buttonTextColor = Colors.white;

  // النصوص
  // static const String categoryLabel = 'الفئة';
  static const String continueButtonText = 'متابعة';

  // // الإيموجي
  // static const String icon = '📚';
}

class _LessonDialog extends StatelessWidget {
  final String categoryName;
  final int lessonNumber;
  final int lessonTotalInLine;

  const _LessonDialog({
    required this.categoryName,
    required this.lessonNumber,
    required this.lessonTotalInLine,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,

      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: _LessonDialogStyle.cardWidth,
        padding: const EdgeInsets.all(_LessonDialogStyle.cardPadding),
        decoration: BoxDecoration(
          color: Color(0xFFC5C9CC),
          borderRadius: BorderRadius.circular(_LessonDialogStyle.cardRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              categoryName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: _LessonDialogStyle.titleColor,
              ),
            ),

            const SizedBox(height: 10),

            // 🟢 فاصل زخرفي رفيع
            Container(
              height: 2,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey),
            ),

            const SizedBox(height: 10),

            // 🟢 رقم الدرس في الخط الحالي
            Text(
              'الدرس $lessonNumber من $lessonTotalInLine',
              style: GoogleFonts.cairo(
                fontSize: 18,

                color: _LessonDialogStyle.titleColor,
              ),
            ),

            const SizedBox(height: 10),

            // 🟢 زر المتابعة
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _LessonDialogStyle.buttonColor,
                  foregroundColor: _LessonDialogStyle.buttonTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: _LessonDialogStyle.accentColor.withValues(
                    alpha: 0.4,
                  ),
                ),
                child: Text(
                  _LessonDialogStyle.continueButtonText,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
