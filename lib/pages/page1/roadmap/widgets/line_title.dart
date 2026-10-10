import 'package:engo/theme/app_colors.dart';
import 'package:engo/widgets/bottom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// ───────────────────────────────────────────────────────────
/// يعرض في الـ AppBar:
///   • عنوان الخط الحالي (مثلاً: "Travel") — من _lineTitles
///   • دائرة صغيرة بجانبه تعرض رقم الدرس داخل الخط (مثلاً: "3/5")
///   كلاهما يتحدّث تلقائياً عند التمرير بفضل Obx + BottomNavController.
/// ───────────────────────────────────────────────────────────
class LineTitleInline extends StatelessWidget {
  const LineTitleInline({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<BottomNavController>();

      // عنوان الخط الحالي من الـ Controller (مثال: "Travel")
      final String title = controller.currentLineTitle.value;

      // رقم الدرس داخل الخط (1..5) — يبدأ من 1 افتراضياً
      final int lesson = controller.currentLessonInLine.value.clamp(1, 5);

      // رقم الخط الحالي (للعرض في الدائرة كـ X/5)
      // نستخدم lesson مباشرة لأنه يحدّث مع كل مرحلة
      return Container(
        padding: EdgeInsets.only(bottom: 12),
        height: 120,
        width: double.infinity,

        decoration: BoxDecoration(
          color: AppColors.color1,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ─── عملات ذهبية (يسار) ──────────────────────────
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.color1,
                  ),
                  child: const Icon(
                    Icons.monetization_on,
                    color: Color(0xFFFFD700), // ذهبي
                    size: 25,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '10',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.color11,
                  ),
                ),
              ],
            ),
            SizedBox(width: 50),

            // ─── دائرة رقم الدرس (مثلاً: "3/5") ──────────────────
            Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),

                color: AppColors.color3,
              ),
              child: Text(
                '$lesson',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.color11,
                ),
              ),
            ),
            const SizedBox(width: 5),

            // ─── عنوان الخط (مثلاً: "Travel") ──────────────────────
            Flexible(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.color3,
                  height: 1,
                ),
              ),
            ),
            SizedBox(width: 50),

            // ─── قلب واحد + رقم (يمين) ─────────────────────
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '10',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.color11,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Color(0xFFFF6B9D), // وردي ساخن
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
