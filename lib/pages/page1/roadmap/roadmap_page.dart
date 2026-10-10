import 'dart:async';

import 'package:engo/pages/page1/lesson1/lesson1.dart';
import 'package:engo/pages/page1/roadmap/widgets/line_title.dart';
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

  // 🟢 MediaQuery — نقطة مرجعية (iPhone X / 11 Pro) لتعديل الأحجام لكل المقاسات.
  static const double _refWidth = 375.0;
  static const double _refHeight = 812.0;
  // المسافة بين المراحل (أساسية — تُضرب بمقياس الارتفاع في كل بناء).
  static const double _baseItemSpacing = 80;
  // المسافة الفعلية بين المراحل (تُحسب من MediaQuery في كل بناء).
  double _itemSpacing = _baseItemSpacing;

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

      // 3) تحديث عنوان الخط ورقمه بناءً على الموضع الحالي
      final double currentOffset = _scrollController.hasClients
          ? _scrollController.offset
          : savedOffset;
      final int visualIndex = (currentOffset / _itemSpacing).round();
      final int safeIndex = visualIndex.clamp(0, RoadMapData.stages.length - 1);
      // استخدم الفهرس الأصلي (وليس البصري) ليتم تحديث العنوان والعدّاد معاً
      final int orig = _nearestOriginalIndex(safeIndex);
      final int line = (orig ~/ RoadMapData.stagesPerLine) + 1;
      controller.currentLineTitle.value = RoadMapData.lineTitle(line);
      controller.currentLine.value = line;
      controller.currentLessonInLine.value = _lessonInLineForVisual(safeIndex);
    });
  }

  /// إيجاد أقرب فهرس أصلي (غير فاصل) لفهرس بصري.
  /// البحث للخلف أولاً: عند الفاصل، نُبقي العدّاد على آخر درس مَرَّ به المستخدم
  /// حتى يمرّر للمرحلة التالية من الخط الجديد فيُحدَّث تلقائياً.
  int _nearestOriginalIndex(int visualIndex) {
    final int len = RoadMapData.stages.length;
    if (len == 0) return 0;
    for (int i = visualIndex; i >= 0; i--) {
      final int? orig = RoadMapData.originalIndexOf(i);
      if (orig != null) return orig;
    }
    for (int i = visualIndex + 1; i < len; i++) {
      final int? orig = RoadMapData.originalIndexOf(i);
      if (orig != null) return orig;
    }
    return 0;
  }

  /// رقم الدرس داخل الخط (1..5) لفهرس بصري معيّن.
  int _lessonInLineForVisual(int visualIndex) {
    final int orig = _nearestOriginalIndex(visualIndex);
    return RoadMapData.lessonNumberInLine(orig);
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
    // استخدم نفس الفهرس الأصلي للخط والعدّاد ليبقيا متزامنين
    final int orig = _nearestOriginalIndex(safeIndex);
    final int line = (orig ~/ RoadMapData.stagesPerLine) + 1;
    final String title = RoadMapData.lineTitle(line);

    // تحديث العنوان ورقم الخط ورقم الدرس داخل الخط فقط عند التغيير —
    // نُؤجّل التحديث لما بعد البناء لتفادي setState/markNeedsBuild
    // أثناء البناء (خطأ Obx).
    final controller = Get.find<BottomNavController>();
    final int lessonInLine = _lessonInLineForVisual(safeIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.currentLineTitle.value != title) {
        controller.currentLineTitle.value = title;
      }
      if (controller.currentLine.value != line) {
        controller.currentLine.value = line;
      }
      if (controller.currentLessonInLine.value != lessonInLine) {
        controller.currentLessonInLine.value = lessonInLine;
      }
    });

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
    // 🟢 MediaQuery — قياس الشاشة لحساب مقاييس متناسقة.
    final MediaQueryData media = MediaQuery.of(context);
    final double screenW = media.size.width;
    final double screenH = media.size.height;
    // مقاييس محصورة (لا تتجاوز 40% من المرجع لتفادي كسر التصميم على
    // // شاشات صغيرة جداً أو أجهزة لوحية كبيرة).
    final double wScale = (screenW / _refWidth).clamp(0.70, 1.40);
    final double hScale = (screenH / _refHeight).clamp(0.75, 1.30);
    // مقياس موحّد للعناصر ثنائية البُعد (دوائر، فواصل، أيقونات).
    final double ui = ((wScale + hScale) / 2).clamp(0.75, 1.35);

    // حدِّث المسافة بين المراحل بناءً على ارتفاع الشاشة.
    _itemSpacing = _baseItemSpacing * hScale;

    return Scaffold(
      backgroundColor: AppColors.color20,

      body: Column(
        children: [
          LineTitleInline(),
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
                  return _LineSeparator(
                    label: item.title,
                    uiScale: ui,
                    wScale: wScale,
                  );
                }
                return _StageNode(
                  stage: item,
                  visualIndex: visualIndex,
                  onTap: () => _openLesson(context, item.originalIndex!),
                  uiScale: ui,
                  wScale: wScale,
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
  // 🟢 MediaQuery scales
  final double uiScale;
  final double wScale;

  const _StageNode({
    required this.stage,
    required this.visualIndex,
    required this.onTap,
    required this.uiScale,
    required this.wScale,
  });

  @override
  Widget build(BuildContext context) {
    final int stageIndex = stage.originalIndex!;
    final bool unlocked = ProgressService.isStageOpen(stageIndex);
    final bool completed = ProgressService.isStageFullyCompleted(stageIndex);

    return SizedBox(
      width: 200 * wScale,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: AppColors.color20, //===========================
            // effectiveColor,
            shape: const CircleBorder(
              side: BorderSide(
                color: AppColors.color2,
                width: 0.8,
              ), //===================
            ),
            elevation: completed ? 9 : 1,
            child: InkWell(
              onTap: unlocked ? onTap : null,
              child: Container(
                width: 100 * uiScale,
                height: 60 * uiScale,
                alignment: Alignment.center,
                child: unlocked
                    ? Icon(
                        stage.iconData,
                        size: 36 * uiScale,
                        color: AppColors.color1,
                      )
                    : Icon(
                        Icons.lock,
                        size: 32 * uiScale,
                        color: AppColors.color3,
                      ),
              ),
            ),
          ),

          Flexible(
            child: Row(
              children: [
                Text(
                  stage.id,
                  style: GoogleFonts.cairo(
                    fontSize: 12 * uiScale,
                    fontWeight: FontWeight.w800,
                    color: AppColors.color1,
                  ),
                ),
                Text(
                  stage.title,
                  style: GoogleFonts.cairo(
                    fontSize: 12 * uiScale,
                    fontWeight: FontWeight.w800,
                    color: AppColors.color1,
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
  // 🟢 MediaQuery scales
  final double uiScale;
  final double wScale;
  const _LineSeparator({
    required this.label,
    required this.uiScale,
    required this.wScale,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240 * wScale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🧊 بطاقة العنوان
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 18 * uiScale,
              vertical: 10 * uiScale,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20 * uiScale),
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
                fontSize: 15 * uiScale,
                fontWeight: FontWeight.w900,
                color: AppColors.color1,
              ),
            ),
          ),

          // ─── خط فضي يمتد يميناً ويساراً مع نقطة في المنتصف ───
          SizedBox(height: 10 * uiScale),
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
                margin: EdgeInsets.symmetric(horizontal: 6 * uiScale),
                width: 8 * uiScale,
                height: 8 * uiScale,
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
