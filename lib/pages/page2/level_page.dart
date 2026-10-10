import 'package:engo/pages/page2/level_data.dart';
import 'package:engo/pages/page2/level_texts_page.dart';
import 'package:engo/pages/page2/levels_controller.dart';
import 'package:engo/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// الصفحة الأولى: عرض المستويات الستة (A1 .. C2) لاختبار المستوى.
class LevelPage extends StatelessWidget {
  const LevelPage({super.key});

  @override
  Widget build(BuildContext context) => GetX<LevelsController>(
    init: LevelsController(),
    builder: (controller) {
      // أثناء تحميل القصص من ملفات JSON
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: Color(0xffF5F8FC),

          body: const Center(
            child: CircularProgressIndicator(color: AppColors.color1),
          ),
        );
      }

      // تُقرأ اللقطة هنا (داخل builder) حتى تُحدّث الصفحة عند تغيّر تقدّم القراءة.
      final readCounts = controller.progressSnapshot();

      return Scaffold(
        backgroundColor: Color(0xffF5F8FC), //==============

        body: SafeArea(
          child: Column(
            children: [
              const _Header(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(
                    top: 10,
                    right: 10,
                    left: 10,
                    bottom: 10,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // شبكة بعمودين: 2×3 للمستويات الستة
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1, // نسبة مربّعة تقريباً للبطاقة
                  ),
                  itemCount: controller.levels.length,
                  itemBuilder: (context, index) {
                    final level = controller.levels[index];
                    final readCount = readCounts[level.code] ?? 0;
                    return _LevelCard(
                      level: level,
                      readCount: readCount,
                      progress: level.texts.isEmpty
                          ? 0
                          : (readCount / level.texts.length)
                                .clamp(0, 1)
                                .toDouble(),
                      onTap: () async {
                        await Get.to(
                          () => LevelTextsPage(level: level),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                        // تحديث أشرطة التقدّم عند العودة من صفحة النصوص.
                        controller.refreshProgress();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.color1), //========

            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.school_rounded, color: AppColors.color1),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مستويات اللغة الانجليزية ',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.color1, //=========================
                ),
              ),
              Text(
                'اقرأ النصوص لمعرفة مستواك',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: AppColors.color1, //=========================
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.readCount,
    required this.progress,
    required this.onTap,
  });

  final CefrLevel level;
  final int readCount;
  final double progress;
  final VoidCallback onTap;

  /// اللون الشفاف الموحَّد لكل المستويات.

  @override
  Widget build(BuildContext context) {
    final total = level.texts.length;
    final isCompleted = total > 0 && readCount >= total;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.color20, //====== 🧊 اللون الشفاف الموحَّد
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.color19, //=============
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.verified_rounded
                          : Icons.chevron_left_rounded,
                      color: isCompleted
                          ? AppColors.color1
                          : AppColors.color1.withValues(alpha: .7),
                      size: 20,
                    ),
                    Spacer(),

                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.color19, //=====================
                        //
                      ),
                      child: Text(
                        level.code,
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.color5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    level.nameAr,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.color1,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'عدد النصوص: $total',
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: AppColors.color1.withValues(alpha: .7),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: AppColors.color4.withValues(alpha: .5),
                    color: AppColors.color1,
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'تمت قراءة $readCount من $total',
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.cairo(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.color1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
