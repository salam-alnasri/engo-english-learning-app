import 'dart:async';

import 'package:engo/pages/page1/lesson1/lesson1.dart';
import 'package:engo/pages/page1/roadmap/widgets/LineTitleInline.dart';
import 'package:engo/theme/app_colors.dart';
import 'package:engo/widgets/bottom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_path_layout/flutter_path_layout.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'progress_service.dart';
import 'roadmap_data.dart';
import 'widgets/lesson_dialog.dart';

/// صفحة الرودماب — تستخدم flutter_path_layout مع فواصل بين كل ٥ مراحل.
/// عنوان الخط الحالي يظهر في الـ AppBar ويتحدّث تلقائياً عند التمرير.
class RoadMapPage extends StatefulWidget {
  const RoadMapPage({super.key});

  @override
  State<RoadMapPage> createState() => _RoadMapPageState();
}

class _RoadMapPageState extends State<RoadMapPage> {
  final ScrollController _scrollController = ScrollController();

  // مفتاح التخزين لآخر موضع تمرير — يبقى محفوظاً بين فتحات التطبيق
  static const _kScrollOffsetKey = 'roadmap_scroll_offset';
  final GetStorage _box = GetStorage();

  // مؤقت للحفظ المُؤجّل (debounce) لتفادي الكتابة المتكررة
  Timer? _saveTimer;

  // المسافة بين المراحل (يجب أن يطابق itemSpacing في FlutterPathLayout).
  static const double _itemSpacing = 80;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // ابدأ بخط 1 + استعد موضع التمرير المحفوظ — نُؤجّل لما بعد البناء
    final controller = Get.find<BottomNavController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // 1) قراءة موضع التمرير المحفوظ
      final double savedOffset = _box.read(_kScrollOffsetKey) ?? 0.0;

      // 2) القفز إلى الموضع المحفوظ (إن وُجد)
      if (savedOffset > 0 && _scrollController.hasClients) {
        final double maxOffset = _scrollController.position.maxScrollExtent;
        _scrollController.jumpTo(savedOffset.clamp(0.0, maxOffset));
      }

      // 3) تحديث عنوان الخط بناءً على الموضع الحالي
      final double currentOffset = _scrollController.hasClients
          ? _scrollController.offset
          : savedOffset;
      final int visualIndex = (currentOffset / _itemSpacing).round();
      final int safeIndex = visualIndex.clamp(0, RoadMapData.stages.length - 1);
      controller.currentLineTitle.value = RoadMapData.lineTitle(
        RoadMapData.lineOf(safeIndex),
      );
    });
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final double offset = _scrollController.offset;
    // الفهرس البصري الأقرب للوسط
    final int visualIndex = (offset / _itemSpacing).round();

    // ضمان أن البصري ضمن الحدود
    final int safeIndex = visualIndex.clamp(0, RoadMapData.stages.length - 1);
    final int line = RoadMapData.lineOf(safeIndex);
    final String title = RoadMapData.lineTitle(line);

    // تحديث العنوان فقط عند التغيير — نُؤجّل التحديث لما بعد البناء
    // لتفادي setState/markNeedsBuild أثناء البناء (خطأ Obx).
    final controller = Get.find<BottomNavController>();
    if (controller.currentLineTitle.value != title) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.currentLineTitle.value != title) {
          controller.currentLineTitle.value = title;
        }
      });
    }

    // 🟢 حفظ الموضع في GetStorage مع debounce (300ms)
    // يكتب مرة واحدة بعد توقّف المستخدم عن التمرير لتوفير الموارد.
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _box.write(_kScrollOffsetKey, offset);
    });
  }

  void _openLesson(BuildContext context, int stageIndex) async {
    // 🟢 عرض مربع حوار قبل بدء الدرس، يحوي اسم الفئة ورقم الدرس.
    final categoryName = RoadMapData.categoryTitleFor(stageIndex);
    final lessonInLine = RoadMapData.lessonNumberInLine(stageIndex);

    final shouldStart = await LessonStartDialog.show(
      context: context,
      categoryName: categoryName,
      lessonNumber: lessonInLine,
      lessonTotalInLine: RoadMapData.stagesPerLine,
    );

    // إذا ضغط المستخدم متابعة، نفتح الدرس.
    if (shouldStart == true && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              Lesson1(groupIndex: stageIndex, levelIndex: stageIndex),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🟢 شريط علوي — معلومات تقدم اللاعب (ذهب + LineBanner + قلوب)
      appBar: AppBar(
        backgroundColor: AppColors.color1,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ─── عملات ذهبية (يسار) ──────────────────────────
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.monetization_on,
                    color: Color(0xFFFFD700), // ذهبي
                    size: 20,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '10',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // ─── عنوان الخط الحالي (وسط) ─────────────────────
            const Flexible(child: LineTitleInline()),

            // ─── قلب واحد + رقم (يمين) ─────────────────────
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '10',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
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
      ),

      body: Column(
        children: [
          // 🟢 محتوى الرودماب القابل للتمرير
          Expanded(
            child: FlutterPathLayout<RoadMapStage>(
              items: RoadMapData.stages,
              shape: PathShape.wave,
              itemSpacing: _itemSpacing,
              amplitude: 1,
              frequency: 11,

              // تمرير قابل للتحكم
              controller: _scrollController,

              itemBuilder: (context, item, visualIndex) {
                if (item.isSeparator) {
                  return _LineSeparator(label: item.title);
                }
                return _StageNode(
                  stage: item,
                  visualIndex: visualIndex,
                  onTap: () => _openLesson(context, item.originalIndex!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ───────────────────────────────────────────────────────────
/// عقدة مرحلة عادية
/// ───────────────────────────────────────────────────────────
class _StageNode extends StatelessWidget {
  final RoadMapStage stage;
  final int visualIndex;
  final VoidCallback onTap;

  const _StageNode({
    required this.stage,
    required this.visualIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final int stageIndex = stage.originalIndex!;
    final bool unlocked = ProgressService.isStageOpen(stageIndex);
    final bool completed = ProgressService.isStageFullyCompleted(stageIndex);
    final Color color = RoadMapData.colorOf(visualIndex);
    final Color effectiveColor = unlocked ? color : Colors.grey;
    final Color titleColor = unlocked
        ? (completed ? AppColors.color1 : Colors.black87)
        : Colors.grey;

    return SizedBox(
      width: 200,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: effectiveColor,
            shape: const CircleBorder(),
            elevation: completed ? 6 : 1,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: unlocked ? onTap : null,
              child: Container(
                width: 100,
                height: 60,
                alignment: Alignment.center,
                child: unlocked
                    ? Icon(stage.iconData, size: 36, color: Colors.white)
                    : const Icon(Icons.lock, size: 32, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Flexible(
            child: Row(
              children: [
                Text(
                  stage.id,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: titleColor,
                  ),
                ),
                Text(
                  stage.title,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: titleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ───────────────────────────────────────────────────────────
/// فاصل بين مجموعتين من المراحل (بطاقة + خط فضي)
/// ───────────────────────────────────────────────────────────
class _LineSeparator extends StatelessWidget {
  final String label;
  const _LineSeparator({required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🧊 بطاقة العنوان
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.color4, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.color1.withValues(alpha: 0.10),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.color1,
              ),
            ),
          ),

          // ─── خط فضي يمتد يميناً ويساراً مع نقطة في المنتصف ───
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.color4.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.color1,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.color4.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
