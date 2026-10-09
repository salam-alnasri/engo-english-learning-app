import 'package:engo/pages/page2/widgets/costom_button.dart';
import 'package:engo/pages/page2/level_data.dart';
import 'package:engo/pages/page2/levels_controller.dart';
import 'package:engo/pages/page2/story_reading_page.dart';
import 'package:engo/pages/page2/widgets/reading_widgets.dart';
import 'package:engo/pages/page2/widgets/story_card.dart';
import 'package:engo/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// الصفحة الثانية: تُعرض قصص المستوى الواحد على شكل بطاقات فوق بعضها،
/// وكل بطاقة تُظهر عنوان القصة وعدد الكلمات، والضغط عليها يفتح نص القصة.
class LevelTextsPage extends StatelessWidget {
  const LevelTextsPage({super.key, required this.level});

  final CefrLevel level;

  @override
  Widget build(BuildContext context) => GetX<LevelStoriesController>(
    init: LevelStoriesController(level: level),
    tag: level.code,
    builder: (controller) {
      // أثناء تحميل قصص هذا المستوى
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: AppColors.color5,
          body: const Center(
            child: CircularProgressIndicator(color: AppColors.color1),
          ),
        );
      }

      // تُقرأ الحالات هنا (داخل builder) حتى تُحدّث الصفحة عند أي تغيير.
      final readStoryIds = controller.readSnapshot();
      final readCount = controller.readCount;
      final progress = controller.progress;
      final isCompleted = controller.isLevelCompleted;
      final stories = controller.stories;
      final openedStory = controller.openedStory;

      // عند اختيار قصة نُظهر نصّها الكامل، وزر الرجوع يعيدنا للقائمة.
      if (openedStory != null) {
        return StoryReadingPage(
          level: level,
          story: openedStory,
          controller: controller,
          read: readStoryIds[openedStory.id] ?? false,
        );
      }

      return Scaffold(
        backgroundColor: AppColors.color5, //=========================
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   foregroundColor: Colors.red,
        //   elevation: 0,
        //   title: Directionality(
        //     textDirection: TextDirection.rtl,
        //     child: Text(
        //       '${level.nameAr} • ${level.code}',
        //       style: GoogleFonts.cairo(
        //         fontSize: 18,
        //         fontWeight: FontWeight.w800,
        //       ),
        //     ),
        //   ),
        // ),
        body: SafeArea(
          child: Column(
            children: [
              _LevelBanner(
                level: level,
                readCount: readCount,
                progress: progress,
                isCompleted: isCompleted,
              ),
              Expanded(
                child: stories.isEmpty
                    ? const EmptyLevelState()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 26),
                        itemCount: stories.length + 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index == stories.length) {
                            return const _StoriesFooterNote();
                          }
                          final story = stories[index];
                          return StoryCard(
                            text: story,
                            color: level.color,
                            number: index + 1,
                            read: readStoryIds[story.id] ?? false,
                            onTap: () => controller.openStory(story.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

        floatingActionButton: CustomFab(onPressed: () => Get.back()),
        bottomNavigationBar: const Note(),
      );
    },
  );
}

/// ترويسة المستوى: الوصف + شريط التقدّم + عدد القصص المقروءة.
class _LevelBanner extends StatelessWidget {
  const _LevelBanner({
    required this.level,
    required this.readCount,
    required this.progress,
    required this.isCompleted,
  });

  final CefrLevel level;
  final int readCount;
  final double progress;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [level.color, level.color.withValues(alpha: .78)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: level.color.withValues(alpha: .28),
          blurRadius: 16,
          offset: const Offset(0, 7),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(level.icon, color: Colors.white, size: 26),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'قصص المستوى ${level.code}',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            if (isCompleted)
              const Icon(Icons.verified_rounded, color: Colors.white),
          ],
        ),
        const SizedBox(height: 8),

        // Text(
        //   level.descriptionAr,
        //   textDirection: TextDirection.rtl,
        //   textAlign: TextAlign.right,
        //   style: GoogleFonts.cairo(
        //     fontSize: 13.5,
        //     height: 1.6,
        //     color: Colors.white.withValues(alpha: .95),
        //   ),
        // ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: Colors.white.withValues(alpha: .3),
            color: Colors.white,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'تمت قراءة $readCount من ${level.texts.length}',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.color5, //=========================
          ),
        ),
      ],
    ),
  );
}

/// ملاحظة إرشادية أسفل قائمة القصص.
class _StoriesFooterNote extends StatelessWidget {
  const _StoriesFooterNote();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF93987c),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.lightbulb_rounded, color: Color(0xFF283618), size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'اضغط على أي قصة لقراءة نصّها كاملًا والاستماع إليها، وعدد الكلمات على كل بطاقة يوضّح طول القصة.',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
              fontSize: 13,
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
