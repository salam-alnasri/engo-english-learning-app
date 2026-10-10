import 'package:get/get.dart';

/// 🟢 Controller يدير فهرس التبويب النشط (GetX).
/// ملف منفصل لتفادي الـ circular import بين bottom_nav_bar و roadmap_page.
class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  /// عنوان الخط الحالي في الصفحة الأولى (RoadMap).
  /// يتم تحديثه من roadmap_page.dart عند التمرير.
  final RxString currentLineTitle = ''.obs;

  /// رقم الخط الحالي (1..N). يحدّث من roadmap_page.dart عند التمرير.
  final RxInt currentLine = 1.obs;

  /// رقم الدرس داخل الخط الحالي (1..5). يُعدّ من `_rawStages` في roadmap_data.
  final RxInt currentLessonInLine = 1.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}
