import 'package:engo/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// نموذج موحّد لعنصر في الرودماب — إمّا مرحلة عادية أو فاصل خط.
class RoadMapStage {
  final String id;
  final String title;
  final IconData iconData;
  final int? difficulty;

  /// true → عنصر فاصل (خط فاصل بين المجموعات)
  final bool isSeparator;

  /// رقم الخط (1-based). يُحدّد لـكل من المراحل والفواصل.
  final int lineNumber;

  /// الفهرس الأصلي للمرحلة في قائمة المراحل الخام (يُستخدم للربط بالبيانات).
  /// null إذا كان العنصر فاصلاً.
  final int? originalIndex;

  const RoadMapStage({
    required this.id,
    required this.title,
    required this.iconData,
    required this.lineNumber,
    this.difficulty,
    this.isSeparator = false,
    this.originalIndex,
  });
}

/// عناوين الخطوط الخمسة. غيّرها لاحقاً حسب رغبتك.
const List<String> _lineTitles = [
  'الكلمات الأساسية',
  'الأشياء في المنزل',
  'العائلة والأصدقاء',
  'الفصل الدراسي',
  'الطعام والشراب',
  ' الاشكال والألوان',
  'الحيوانات والمزرعة',
  'الملابس والفصول',
  'الأيام والأشهر ',
  'الأماكن في المدينة ',
  'السفر والمواصلات',
  'الجسم والصحة',
  'الطقس والطبيعة',
  'الهوايات والأنشطة',
  'المهن والعمل',
  'التكنولوجيا',
  'المشاعر',
  'القصص والمغامرات',
  'العادات والثقافات',
  'الكلمات الأكاديمية',
  'الحياة اليومية',
  'العالم الخارجي',
  'المعرفة والثقافة',
  //==========================
  'قدم واقبل المشروبات',
  'قل من أين أنت',
  'قدم نفسك وعائلتك',
  'تنقل في المطار',
  'استخدم الصفات لوصف الأسماء',
  'اطلب الطعام والشراب',
  'استخدم الزمن المضارع للمهن',
  'استخدم الزمن المضارع',
  'تحدث عن الطقس',
  'تسوق لشراء الملابس',
  'قم بجولة في منزلك',
  'استخدم الزمن المضارع (من يكون)',
  'استخدم اختصارات الزمن المضارع (من يكون)',
  'اطلب الطعام والمشروبات',
  'تواصل في العمل',
  'استخدم الزمن المضارع للمشاعر',
  'اطلب المساعدة في الصف',
  'اطلب المساعدة أثناء التسوق',
  'استخدم تعابير الوجه',
  'ناقش الرياضيات',
  'استخدم ظروف التكرار والوقت',
  'صف روتينك اليومي',
  'احجز غرفة في الفندق',
  'استخدم أدوات التعريف',
  'صف أفراد عائلتك',
  'صف ممتلكاتك',
  'افرز الأشياء المفقودة',
  'تسوق للملابس',
  'كوّن جمع تكسير',
  'تنقل في مدينة غير مألوفة',
  'كوّن النفي في الزمن المضارع',
  'تحدث عن الأعراض',
  'كوّن أسئلة بـ (يكون) في الزمن المضارع',
  'استخدم المضارع المستمر',
  'تحدث عن الطقس والطبيعة',
  'كوّن أسئلة في المضارع المستمر',
  'تحدث عن المدرسة',
  'استخدم أفعال الأمر المثبتة',
  'قدم نصائح السلامة',
];

class RoadMapData {
  /// قائمة المراحل الخام (22 مرحلة).
  static const List<RoadMapStage> _rawStages = [
    RoadMapStage(
      id: '1 ',
      title: 'الدرس ',
      iconData: Iconsax.menu4,

      lineNumber: 1,
    ),
    RoadMapStage(
      id: '2',
      title: 'الدرس ',
      iconData: Icons.auto_stories_outlined,
      lineNumber: 1,
    ),
    RoadMapStage(
      id: '3',
      title: 'الدرس  ',
      iconData: Icons.local_library_outlined,
      lineNumber: 1,
    ),
    RoadMapStage(
      id: '4',
      title: ' الدرس  ',
      iconData: Icons.import_contacts_outlined,
      lineNumber: 1,
    ),
    RoadMapStage(
      id: '5',
      title: 'الدرس  ',
      iconData: Icons.translate,
      lineNumber: 1,
    ),

    RoadMapStage(
      id: '6',
      title: 'الدرس  ',
      iconData: Icons.school_outlined,
      lineNumber: 2,
    ),

    RoadMapStage(
      id: '7',
      title: ' الدرس ',
      iconData: Icons.cast_for_education_outlined,
      lineNumber: 2,
    ),
    RoadMapStage(
      id: '8',
      title: ' الدرس ',
      iconData: Icons.history_edu_outlined,
      lineNumber: 2,
    ),
    RoadMapStage(
      id: '9',
      title: ' الدرس ',
      iconData: Icons.record_voice_over_outlined,
      lineNumber: 2,
    ),
    RoadMapStage(
      id: '10',
      title: ' الدرس ',
      iconData: Icons.mic_none_outlined,
      lineNumber: 2,
    ),

    RoadMapStage(
      id: '11',
      title: ' الدرس',
      iconData: Icons.headphones_outlined,
      lineNumber: 3,
    ),
    RoadMapStage(
      id: '12',
      title: ' الدرس',
      iconData: Icons.campaign_outlined,
      lineNumber: 3,
    ),
    RoadMapStage(
      id: '13',
      title: ' الدرس',
      iconData: Icons.chat_bubble_outline_outlined,
      lineNumber: 3,
    ),
    RoadMapStage(
      id: '14',
      title: ' الدرس',
      iconData: Icons.campaign,
      lineNumber: 3,
    ),
    RoadMapStage(
      id: '15',
      title: ' الدرس',
      iconData: Icons.edit_outlined,
      lineNumber: 3,
    ),

    RoadMapStage(
      id: '16',
      title: ' الدرس',
      iconData: Icons.create_outlined,
      lineNumber: 4,
    ),
    RoadMapStage(
      id: '17',
      title: ' الدرس',
      iconData: Icons.brush_outlined,
      lineNumber: 4,
    ),
    RoadMapStage(
      id: '18',
      title: ' الدرس',
      iconData: Icons.lightbulb_outline,
      lineNumber: 4,
    ),
    RoadMapStage(
      id: '19',
      title: ' الدرس',
      iconData: Icons.restaurant_outlined,
      lineNumber: 4,
    ),
    RoadMapStage(
      id: '20',
      title: ' الدرس',
      iconData: Icons.local_cafe_outlined,
      lineNumber: 4,
    ),
    RoadMapStage(
      id: '21',
      title: ' الدرس',
      iconData: Icons.local_dining_outlined,
      lineNumber: 5,
    ),
    RoadMapStage(
      id: '22',
      title: ' الدرس',
      iconData: Icons.cake_outlined,
      lineNumber: 5,
    ),
    RoadMapStage(
      id: '23',
      title: ' الدرس',
      iconData: Icons.shopping_bag_outlined,
      lineNumber: 5,
    ),
    RoadMapStage(
      id: '24',
      title: ' الدرس',
      iconData: Icons.directions_bus_outlined,
      lineNumber: 5,
    ),
    RoadMapStage(
      id: '25',
      title: ' الدرس',
      iconData: Icons.flight_outlined,
      lineNumber: 5,
    ),
    RoadMapStage(
      id: '26',
      title: ' الدرس',
      iconData: Icons.luggage_outlined,
      lineNumber: 6,
    ),
    RoadMapStage(
      id: '27',
      title: 'الدرس',
      iconData: Icons.home_outlined,
      lineNumber: 6,
    ),
    RoadMapStage(
      id: '28',
      title: 'الدرس',
      iconData: Icons.bed_outlined,
      lineNumber: 6,
    ),
    RoadMapStage(
      id: '29',
      title: 'الدرس',
      iconData: Icons.bathtub_outlined,
      lineNumber: 6,
    ),
    RoadMapStage(
      id: '30',
      title: 'الدرس',
      iconData: Icons.kitchen_outlined,
      lineNumber: 6,
    ),
    RoadMapStage(
      id: '31',
      title: 'الدرس',
      iconData: Icons.work_outline_outlined,
      lineNumber: 7,
    ),
    RoadMapStage(
      id: '32',
      title: 'الدرس',
      iconData: Icons.attach_money_outlined,
      lineNumber: 7,
    ),
    RoadMapStage(
      id: '33',
      title: 'الدرس',
      iconData: Icons.business_center_outlined,
      lineNumber: 7,
    ),
    RoadMapStage(
      id: '34',
      title: 'الدرس',
      iconData: Icons.handshake_outlined,
      lineNumber: 7,
    ),
    RoadMapStage(
      id: '35',
      title: 'الدرس',
      iconData: Icons.fitness_center_outlined,
      lineNumber: 7,
    ),
    RoadMapStage(
      id: '36',
      title: 'الدرس',
      iconData: Icons.health_and_safety_outlined,
      lineNumber: 8,
    ),
    RoadMapStage(
      id: '37',
      title: 'الدرس',
      iconData: Icons.sports_soccer_outlined,
      lineNumber: 8,
    ),
    RoadMapStage(
      id: '38',
      title: 'الدرس',
      iconData: Icons.self_improvement_outlined,
      lineNumber: 8,
    ),
    RoadMapStage(
      id: '39',
      title: 'الدرس',
      iconData: Icons.palette_outlined,
      lineNumber: 8,
    ),
    RoadMapStage(
      id: '40',
      title: 'الدرس',
      iconData: Icons.music_note_outlined,
      lineNumber: 8,
    ),
    RoadMapStage(
      id: '41',
      title: 'الدرس',
      iconData: Icons.photo_camera_outlined,
      lineNumber: 9,
    ),
    RoadMapStage(
      id: '42',
      title: 'الدرس',
      iconData: Icons.movie_outlined,
      lineNumber: 9,
    ),
    RoadMapStage(
      id: '43',
      title: 'الدرس',
      iconData: Icons.computer_outlined,
      lineNumber: 9,
    ),
    RoadMapStage(
      id: '44',
      title: 'الدرس',
      iconData: Icons.smartphone_outlined,
      lineNumber: 9,
    ),
    RoadMapStage(
      id: '45',
      title: 'الدرس',
      iconData: Icons.code_outlined,
      lineNumber: 9,
    ),
    RoadMapStage(
      id: '46',
      title: 'الدرس',
      iconData: Icons.cloud_outlined,
      lineNumber: 10,
    ),
    RoadMapStage(
      id: '47',
      title: 'الدرس',
      iconData: Icons.family_restroom_outlined,
      lineNumber: 10,
    ),
    RoadMapStage(
      id: '48',
      title: 'الدرس',
      iconData: Icons.diversity_3_outlined,
      lineNumber: 10,
    ),
    RoadMapStage(
      id: '49',
      title: 'الدرس',
      iconData: Icons.emoji_emotions_outlined,
      lineNumber: 10,
    ),
    RoadMapStage(
      id: '50',
      title: 'الدرس',
      iconData: Icons.people_outline_outlined,
      lineNumber: 10,
    ),
    RoadMapStage(
      id: '51',
      title: 'الدرس',
      iconData: Icons.pets_outlined,
      lineNumber: 11,
    ),
    RoadMapStage(
      id: '52',
      title: 'الدرس',
      iconData: Icons.forest_outlined,
      lineNumber: 11,
    ),
    RoadMapStage(
      id: '53',
      title: 'الدرس',
      iconData: Icons.wb_sunny_outlined,
      lineNumber: 11,
    ),
    RoadMapStage(
      id: '54',
      title: 'الدرس',
      iconData: Icons.cloud_circle_outlined,
      lineNumber: 11,
    ),
    RoadMapStage(
      id: '55',
      title: 'الدرس',
      iconData: Icons.psychology_outlined,
      lineNumber: 11,
    ),
    RoadMapStage(
      id: '56',
      title: 'الدرس',
      iconData: Icons.functions_outlined,
      lineNumber: 12,
    ),
    RoadMapStage(
      id: '57',
      title: 'الدرس',
      iconData: Icons.calculate_outlined,
      lineNumber: 12,
    ),
    RoadMapStage(
      id: '58',
      title: 'الدرس',
      iconData: Icons.science_outlined,
      lineNumber: 12,
    ),
    RoadMapStage(
      id: '59',
      title: 'الدرس',
      iconData: Icons.menu_book_outlined,
      lineNumber: 12,
    ),
    RoadMapStage(
      id: '60',
      title: 'الدرس',
      iconData: Icons.auto_stories_outlined,
      lineNumber: 12,
    ),
    RoadMapStage(
      id: '61',
      title: 'الدرس',
      iconData: Icons.local_library_outlined,
      lineNumber: 13,
    ),
    RoadMapStage(
      id: '62',
      title: 'الدرس',
      iconData: Icons.import_contacts_outlined,
      lineNumber: 13,
    ),
    RoadMapStage(
      id: '63',
      title: 'الدرس',
      iconData: Icons.translate,
      lineNumber: 13,
    ),
    RoadMapStage(
      id: '64',
      title: 'الدرس',
      iconData: Icons.school_outlined,
      lineNumber: 13,
    ),
    RoadMapStage(
      id: '65',
      title: 'الدرس',
      iconData: Icons.cast_for_education_outlined,
      lineNumber: 13,
    ),
    RoadMapStage(
      id: '66',
      title: 'الدرس',
      iconData: Icons.history_edu_outlined,
      lineNumber: 14,
    ),
    RoadMapStage(
      id: '67',
      title: 'الدرس',
      iconData: Icons.record_voice_over_outlined,
      lineNumber: 14,
    ),
    RoadMapStage(
      id: '68',
      title: 'الدرس',
      iconData: Icons.mic_none_outlined,
      lineNumber: 14,
    ),
    RoadMapStage(
      id: '69',
      title: 'الدرس',
      iconData: Icons.headphones_outlined,
      lineNumber: 14,
    ),
    RoadMapStage(
      id: '70',
      title: 'الدرس',
      iconData: Icons.campaign_outlined,
      lineNumber: 14,
    ),
    RoadMapStage(
      id: '71',
      title: 'الدرس',
      iconData: Icons.chat_bubble_outline_outlined,
      lineNumber: 15,
    ),
    RoadMapStage(
      id: '72',
      title: 'الدرس',
      iconData: Icons.campaign,
      lineNumber: 15,
    ),
    RoadMapStage(
      id: '73',
      title: 'الدرس',
      iconData: Icons.edit_outlined,
      lineNumber: 15,
    ),
    RoadMapStage(
      id: '74',
      title: 'الدرس',
      iconData: Icons.create_outlined,
      lineNumber: 15,
    ),
    RoadMapStage(
      id: '75',
      title: 'الدرس',
      iconData: Icons.brush_outlined,
      lineNumber: 15,
    ),
    RoadMapStage(
      id: '76',
      title: 'الدرس',
      iconData: Icons.lightbulb_outline,
      lineNumber: 16,
    ),
    RoadMapStage(
      id: '77',
      title: 'الدرس',
      iconData: Icons.restaurant_outlined,
      lineNumber: 16,
    ),
    RoadMapStage(
      id: '78',
      title: 'الدرس',
      iconData: Icons.local_cafe_outlined,
      lineNumber: 16,
    ),
    RoadMapStage(
      id: '79',
      title: 'الدرس',
      iconData: Icons.local_dining_outlined,
      lineNumber: 16,
    ),
    RoadMapStage(
      id: '80',
      title: 'الدرس',
      iconData: Icons.cake_outlined,
      lineNumber: 16,
    ),
    RoadMapStage(
      id: '81',
      title: 'الدرس',
      iconData: Icons.shopping_bag_outlined,
      lineNumber: 17,
    ),
    RoadMapStage(
      id: '82',
      title: 'الدرس',
      iconData: Icons.directions_bus_outlined,
      lineNumber: 17,
    ),
    RoadMapStage(
      id: '83',
      title: 'الدرس',
      iconData: Icons.flight_outlined,
      lineNumber: 17,
    ),
    RoadMapStage(
      id: '84',
      title: 'الدرس',
      iconData: Icons.luggage_outlined,
      lineNumber: 17,
    ),
    RoadMapStage(
      id: '85',
      title: 'الدرس',
      iconData: Icons.home_outlined,
      lineNumber: 17,
    ),
    RoadMapStage(
      id: '86',
      title: 'الدرس',
      iconData: Icons.bed_outlined,
      lineNumber: 18,
    ),
    RoadMapStage(
      id: '87',
      title: 'الدرس',
      iconData: Icons.bathtub_outlined,
      lineNumber: 18,
    ),
    RoadMapStage(
      id: '88',
      title: 'الدرس',
      iconData: Icons.kitchen_outlined,
      lineNumber: 18,
    ),
    RoadMapStage(
      id: '89',
      title: 'الدرس',
      iconData: Icons.work_outline_outlined,
      lineNumber: 18,
    ),
    RoadMapStage(
      id: '90',
      title: 'الدرس',
      iconData: Icons.attach_money_outlined,
      lineNumber: 18,
    ),
    RoadMapStage(
      id: '91',
      title: 'الدرس',
      iconData: Icons.business_center_outlined,
      lineNumber: 19,
    ),
    RoadMapStage(
      id: '92',
      title: 'الدرس',
      iconData: Icons.handshake_outlined,
      lineNumber: 19,
    ),
    RoadMapStage(
      id: '93',
      title: 'الدرس',
      iconData: Icons.fitness_center_outlined,
      lineNumber: 19,
    ),
    RoadMapStage(
      id: '94',
      title: 'الدرس',
      iconData: Icons.health_and_safety_outlined,
      lineNumber: 19,
    ),
    RoadMapStage(
      id: '95',
      title: 'الدرس',
      iconData: Icons.sports_soccer_outlined,
      lineNumber: 19,
    ),
    RoadMapStage(
      id: '96',
      title: 'الدرس',
      iconData: Icons.self_improvement_outlined,
      lineNumber: 20,
    ),
    RoadMapStage(
      id: '97',
      title: 'الدرس',
      iconData: Icons.palette_outlined,
      lineNumber: 20,
    ),
    RoadMapStage(
      id: '98',
      title: 'الدرس',
      iconData: Icons.music_note_outlined,
      lineNumber: 20,
    ),
    RoadMapStage(
      id: '99',
      title: 'الدرس',
      iconData: Icons.photo_camera_outlined,
      lineNumber: 20,
    ),
    RoadMapStage(
      id: '100',
      title: 'الدرس',
      iconData: Icons.movie_outlined,
      lineNumber: 20,
    ),
    RoadMapStage(
      id: '101',
      title: 'الدرس',
      iconData: Icons.computer_outlined,
      lineNumber: 21,
    ),
    RoadMapStage(
      id: '102',
      title: 'الدرس',
      iconData: Icons.smartphone_outlined,
      lineNumber: 21,
    ),
    RoadMapStage(
      id: '103',
      title: 'الدرس',
      iconData: Icons.code_outlined,
      lineNumber: 21,
    ),
    RoadMapStage(
      id: '104',
      title: 'الدرس',
      iconData: Icons.cloud_outlined,
      lineNumber: 21,
    ),
    RoadMapStage(
      id: '105',
      title: 'الدرس',
      iconData: Icons.family_restroom_outlined,
      lineNumber: 21,
    ),
    RoadMapStage(
      id: '106',
      title: 'الدرس',
      iconData: Icons.diversity_3_outlined,
      lineNumber: 22,
    ),
    RoadMapStage(
      id: '107',
      title: 'الدرس',
      iconData: Icons.emoji_emotions_outlined,
      lineNumber: 22,
    ),
    RoadMapStage(
      id: '108',
      title: 'الدرس',
      iconData: Icons.people_outline_outlined,
      lineNumber: 22,
    ),
    RoadMapStage(
      id: '109',
      title: 'الدرس',
      iconData: Icons.pets_outlined,
      lineNumber: 22,
    ),
    RoadMapStage(
      id: '110',
      title: 'الدرس',
      iconData: Icons.forest_outlined,
      lineNumber: 22,
    ),
    RoadMapStage(
      id: '111',
      title: 'الدرس',
      iconData: Icons.wb_sunny_outlined,
      lineNumber: 23,
    ),
    RoadMapStage(
      id: '112',
      title: 'الدرس',
      iconData: Icons.cloud_circle_outlined,
      lineNumber: 23,
    ),
    RoadMapStage(
      id: '113',
      title: 'الدرس',
      iconData: Icons.psychology_outlined,
      lineNumber: 23,
    ),
    RoadMapStage(
      id: '114',
      title: 'الدرس',
      iconData: Icons.functions_outlined,
      lineNumber: 23,
    ),
    RoadMapStage(
      id: '115',
      title: 'الدرس',
      iconData: Icons.calculate_outlined,
      lineNumber: 23,
    ),
  ];

  /// حجم كل مجموعة (عدد المراحل في الخط الواحد).
  static const int stagesPerLine = 5;

  /// القائمة النهائية المعروضة في الرودماب (مراحل + فواصل).
  /// تُحسب مرة عند أول قراءة وتُخزّن.
  static final List<RoadMapStage> stages = _buildItems();

  static List<RoadMapStage> _buildItems() {
    final List<RoadMapStage> result = <RoadMapStage>[];
    for (int i = 0; i < _rawStages.length; i++) {
      // أدرج فاصلاً قبل بداية كل خط جديد (إلا قبل أول خط).
      if (i > 0 && i % stagesPerLine == 0) {
        final int lineNum = (i ~/ stagesPerLine) + 1;
        result.add(
          RoadMapStage(
            id: 'separator_$lineNum',
            title: _lineTitles[lineNum - 1],
            iconData: Icons.science_outlined,
            lineNumber: lineNum,
            isSeparator: true,
          ),
        );
      }
      // المرحلة مع فهرسها الأصلي للربط بالبيانات.
      result.add(
        RoadMapStage(
          id: _rawStages[i].id,
          title: _rawStages[i].title,
          iconData: _rawStages[i].iconData,
          lineNumber: _rawStages[i].lineNumber,
          difficulty: _rawStages[i].difficulty,
          originalIndex: i,
        ),
      );
    }
    return result;
  }

  /// يُرجع الفهرس الأصلي للمرحلة (من القائمة الخام) من الفهرس البصري.
  /// إذا كان العنصر فاصلاً، يُرجع null.
  static int? originalIndexOf(int visualIndex) {
    final RoadMapStage item = stages[visualIndex];
    return item.originalIndex;
  }

  /// يُرجع رقم الخط الحالي من الفهرس البصري.
  static int lineOf(int visualIndex) => stages[visualIndex].lineNumber;

  /// يُرجع عنوان الخط.
  static String lineTitle(int lineNumber) =>
      _lineTitles[(lineNumber - 1).clamp(0, _lineTitles.length - 1)];

  /// يُرجع مستوى difficulty للمرحلة من الفهرس البصري.
  /// للمراحل العادية فقط، أما الفواصل فيُرجع null.
  static int? difficultyOf(int visualIndex) {
    final RoadMapStage item = stages[visualIndex];
    return item.difficulty ?? item.originalIndex?.let((i) => i + 1);
  }

  /// يُرجع لون المرحلة حسب الفهرس البصري.
  /// للفواصل تُرجع لون فضي.
  static Color colorOf(int visualIndex) {
    if (stages[visualIndex].isSeparator) return AppColors.color4;
    final int? orig = stages[visualIndex].originalIndex;
    return AppColors.roadmapIconColors[(orig ?? 0) %
        AppColors.roadmapIconColors.length];
  }

  /// عدد المراحل الفعلي (بدون الفواصل).
  static int get stageCount => _rawStages.length;

  /// العدد الكلي للخطوط (مجموعات من 5 مراحل).
  /// يُحسب تلقائياً: ceil(stageCount / stagesPerLine).
  static int get totalLines {
    if (_rawStages.isEmpty) return 1;
    return ((_rawStages.length + stagesPerLine - 1) / stagesPerLine).ceil();
  }

  // ──────────────────────────────────────────────
  // 🟢 دوال مساعدة لحوار "الدرس ١ من ٥"
  // ──────────────────────────────────────────────

  /// يُرجع رقم الخط (1-based) لعنصر بصري معيّن.
  /// للفواصل يُرجع الخط الذي تسبقها.
  static int lineOfVisualIndex(int visualIndex) =>
      stages[visualIndex].lineNumber;

  /// يُرجع عنوان الفئة (الخط) لرقم خط معيّن.
  static String categoryTitleFor(int originalStageIndex) {
    if (originalStageIndex < 0 || originalStageIndex >= _rawStages.length) {
      return _lineTitles[0];
    }
    final int lineNum = (originalStageIndex ~/ stagesPerLine) + 1;
    return _lineTitles[(lineNum - 1).clamp(0, _lineTitles.length - 1)];
  }

  /// يُرجع رقم الدرس داخل الخط الحالي (1..5).
  /// مثال: المرحلة الخامسة في الخط الأول → 5، السادسة → 1 (أول درس في الخط 2).
  static int lessonNumberInLine(int originalStageIndex) {
    if (originalStageIndex < 0) return 1;
    return (originalStageIndex % stagesPerLine) + 1;
  }
}

/// دالة مساعدة لإضافة لـ null-safety.
extension _Let<T> on T? {
  R? let<R>(R Function(T) block) {
    if (this == null) return null;
    return block(this as T);
  }
}
