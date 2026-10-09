import 'package:get/get.dart';

/// 🟢 Controller يدير فهرس التبويب النشط (GetX).
/// ملف منفصل لتفادي الـ circular import بين bottom_nav_bar و roadmap_page.
class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  /// عنوان الخط الحالي في الصفحة الأولى (RoadMap).
  /// يتم تحديثه من roadmap_page.dart عند التمرير.
  final RxString currentLineTitle = ''.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}
