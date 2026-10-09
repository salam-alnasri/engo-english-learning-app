import 'package:engo/pages/page1/roadmap/roadmap_data.dart';
import 'package:engo/widgets/bottom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// ───────────────────────────────────────────────────────────
/// عنوان الخط الحالي مُدمج داخل الـ AppBar
/// ───────────────────────────────────────────────────────────
class LineTitleInline extends StatelessWidget {
  const LineTitleInline();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final String title =
          Get.find<BottomNavController>().currentLineTitle.value;
      final int lineNumber = _lineNumberFromTitle(title);

      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🟢 شارة رقم الخط (1/5)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$lineNumber/5',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 🟢 عنوان الخط
          Flexible(
            child: Text(
              title.isEmpty ? RoadMapData.lineTitle(1) : title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    });
  }

  /// يستخرج رقم الخط من عنوانه (مثل "الخط الأول" → 1).
  int _lineNumberFromTitle(String title) {
    const List<String> arabicNumerals = [
      'الأول',
      'الثاني',
      'الثالث',
      'الرابع',
      'الخامس',
    ];
    for (int i = 0; i < arabicNumerals.length; i++) {
      if (title.contains(arabicNumerals[i])) return i + 1;
    }
    return 1;
  }
}
