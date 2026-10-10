import 'package:engo/pages/page2/widgets/costom_button.dart';
import 'package:engo/pages/page2/level_data.dart';
import 'package:engo/pages/page2/levels_controller.dart';
import 'package:engo/pages/page2/widgets/reading_widgets.dart';
import 'package:engo/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// شاشة قراءة قصة واحدة: العنوان، عدد الكلمات، الفقرات، المفردات، والنطق.
///
/// تُعرض داخل نفس مسار صفحة المستوى، وزر الرجوع (أو زر الرجوع في الجهاز)
/// يعيد المستخدم إلى قائمة بطاقات القصص.
class StoryReadingPage extends StatelessWidget {
  const StoryReadingPage({
    super.key,
    required this.level,
    required this.story,
    required this.controller,
    required this.read,
  });

  final CefrLevel level;
  final ReadingText story;
  final LevelStoriesController controller;

  /// هل أنجز المستخدم قراءة هذه القصة؟
  final bool read;

  @override
  Widget build(BuildContext context) {
    final speaking = controller.speakingStoryId.value == story.id;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        controller.closeStory();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFc9c9ae),
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   foregroundColor: Colors.black,
        //   elevation: 0,
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back_rounded),
        //     onPressed: () => controller.closeStory(),
        //   ),
        //   title: Directionality(
        //     textDirection: TextDirection.rtl,
        //     child: Text(
        //       'قصة • ${level.code}',
        //       style: GoogleFonts.cairo(
        //         fontSize: 18,
        //         fontWeight: FontWeight.w800,
        //       ),
        //     ),
        //   ),
        // ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
            children: [
              _StoryHeader(level: level, story: story, read: read),
              const SizedBox(height: 14),
              // فقرات القصة: الضغط على أي فقرة ينطقها.
              for (final paragraph in story.paragraphs)
                ReadingDialogBox(
                  color: Color(0xff283618),
                  text: paragraph,
                  onTap: () => controller.speak(paragraph),
                ),
              VocabBox(
                color: Color(0xff283618),
                vocab: story.vocab,
                onSpeak: controller.speak,
              ),
              const SizedBox(height: 16),
              _StoryActions(
                level: level,
                story: story,
                speaking: speaking,
                read: read,
                controller: controller,
              ),
              const SizedBox(height: 16),
              const ReadingFooterNote(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: CustomFab(
          onPressed: () => controller.closeStory(),
        ),
        bottomNavigationBar: Note(),
      ),
    );
  }
}

/// ترويسة القصة: العنوان بالإنجليزية، الترجمة العربية، عدد الكلمات وحالة القراءة.
class _StoryHeader extends StatelessWidget {
  const _StoryHeader({
    required this.level,
    required this.story,
    required this.read,
  });

  final CefrLevel level;
  final ReadingText story;
  final bool read;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.color17,
          AppColors.color17.withValues(alpha: .78),
        ], //=============
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: AppColors.color17.withValues(alpha: .28), //================
          blurRadius: 16,
          offset: const Offset(0, 7),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                story.title,
                style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            if (read)
              const Icon(Icons.verified_rounded, color: Colors.white, size: 22),
          ],
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            story.titleAr,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: .95),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _HeaderChip(
              icon: Icons.text_fields_rounded,
              label: story.wordCountLabel,
            ),
            const SizedBox(width: 8),
            _HeaderChip(
              icon: Icons.segment_rounded,
              label: '${story.paragraphsCount} فقرة',
            ),
            const SizedBox(width: 8),
            _HeaderChip(
              icon: Icons.menu_book_rounded,
              label: '${story.vocab.length} مفردة',
            ),
          ],
        ),
      ],
    ),
  );
}

/// شريحة بيضاء شفّافة داخل ترويسة القصة.
class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .22),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white),
        const SizedBox(width: 5),
        Text(
          label,
          textDirection: TextDirection.rtl,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

/// أزرار التحكم في قراءة القصة: النطق، الاستماع البطيء، وتسجيل الإكمال.
class _StoryActions extends StatelessWidget {
  const _StoryActions({
    required this.level,
    required this.story,
    required this.speaking,
    required this.read,
    required this.controller,
  });

  final CefrLevel level;
  final ReadingText story;
  final bool speaking;
  final bool read;
  final LevelStoriesController controller;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          OutlinedButton.icon(
            onPressed: () => controller.speakStory(story),
            icon: Icon(
              speaking ? Icons.stop_rounded : Icons.volume_up_rounded,
              size: 18,
            ),
            label: Text(
              speaking ? 'إيقاف' : 'اقرأ لي',
              textDirection: TextDirection.rtl,
              style: GoogleFonts.cairo(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: _outlinedStyle(AppColors.color17), //=================
          ),
          OutlinedButton.icon(
            onPressed: () => controller.speakStorySlowly(story),
            icon: const Icon(Icons.slow_motion_video_rounded, size: 18),
            label: Text(
              'قراءة بطيئة',
              textDirection: TextDirection.rtl,
              style: GoogleFonts.cairo(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: _outlinedStyle(AppColors.color17), //==================
          ),
          ElevatedButton.icon(
            onPressed: () => controller.toggleRead(story.id),
            icon: Icon(
              read
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline_rounded,
              size: 18,
            ),
            label: Text(
              read ? 'أنهيت قراءته' : 'أكملت القراءة',
              textDirection: TextDirection.rtl,
              style: GoogleFonts.cairo(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: read
                  ? const Color(0xFF283618)
                  : AppColors.color17, //===========
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    ],
  );

  ButtonStyle _outlinedStyle(Color color) => OutlinedButton.styleFrom(
    foregroundColor: color,
    side: BorderSide(color: color.withValues(alpha: .5)),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );
}
