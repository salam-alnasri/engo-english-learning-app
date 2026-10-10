// lib/widgets/bottom_nav_bar.dart

import 'package:engo/pages/page1/roadmap/roadmap_page.dart';
import 'package:engo/pages/page2/level_page.dart';
import 'package:engo/pages/page3/page3.dart';
import 'package:engo/pages/page4/settings.dart';
import 'package:engo/theme/app_colors.dart';
import 'package:engo/widgets/bottom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class _NavColors {
  // static const primary = Color(0xFF1F4E8C); // الأزرق الأساسي
  // static const tint = Color(0xFFE3EDFA); // خلفية العنصر المختار
  static const muted = Color(0xFF5B6B82); // العناصر غير المختارة
}

/// 🟢 MediaQuery — نقاط مرجعية لتعديل الحجم لكل قياس شاشة.
/// يجب أن تطابق نفس القيم في roadmap_page.dart للحفاظ على التناسق.
class _NavScale {
  static const double refWidth = 375.0; // iPhone X
  static const double refHeight = 812.0;
  // القيم الأساسية (مقاس iPhone X المرجعي).
  static const double baseBarHeight = 110; // ارتفاع الشريط
  static const double baseItemHeight = 50; // ارتفاع العنصر الواحد
  static const double baseIconSize = 25; // حجم الأيقونة
  static const double baseFontSize = 10; // حجم خط التسمية
  static const double baseBorderRadius = 20; // نصف القطر
  static const double basePadding = 6; // الحاشية الداخلية
  static const double baseMarginTop = 10; // هامش علوي

  /// يُحسب مقياس موحّد من قياس الشاشة الفعلي.
  /// يجمع بين العرض والارتفاع ثم يحصره ضمن نطاق آمن
  /// لتفادي الانهيار على شاشات صغيرة جداً أو التمدّد المفرط على اللوحية.
  static double unified(double screenW, double screenH) {
    final wScale = (screenW / refWidth).clamp(0.70, 1.40);
    final hScale = (screenH / refHeight).clamp(0.75, 1.30);
    return ((wScale + hScale) / 2).clamp(0.75, 1.35);
  }

  /// مقياس الارتفاع للشريط نفسه.
  static double heightScale(double screenH) =>
      (screenH / refHeight).clamp(0.75, 1.30);
}

class _NavData {
  const _NavData(this.icon, this.label);
  final IconData icon;
  final String label;
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  static const List<Widget> _pages = [
    RoadMapPage(),
    LevelPage(),
    Page3(),
    SettingsPage(),
  ];

  static const List<_NavData> _items = [
    _NavData(Iconsax.home, 'المسار'),
    _NavData(Iconsax.chart, 'المستويات'),
    _NavData(Iconsax.cup, 'المتصدرون'),
    _NavData(Iconsax.setting_2, 'الإعدادات'),
  ];

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());
    final media = MediaQuery.of(context);
    final uiScale = _NavScale.unified(media.size.width, media.size.height);
    final heightScale = _NavScale.heightScale(media.size.height);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF4F7FB),
      body: Obx(() => _pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(() {
        final current = controller.currentIndex.value;

        return SafeArea(
          child: SizedBox(
            height: _NavScale.baseBarHeight * heightScale,
            child: FloatingNavbar(
              backgroundColor: Colors.white,
              selectedBackgroundColor: AppColors.color9,
              selectedItemColor: AppColors.color1,
              unselectedItemColor: _NavColors.muted,
              elevation: 9,
              currentIndex: current,
              onTap: controller.changeTabIndex,
              borderRadius: _NavScale.baseBorderRadius * uiScale,
              itemBorderRadius: _NavScale.baseBorderRadius * uiScale,
              margin: EdgeInsets.only(
                top: _NavScale.baseMarginTop * heightScale,
              ),
              padding: EdgeInsets.all(_NavScale.basePadding * uiScale),
              items: List.generate(_items.length, (i) {
                final selected = i == current;
                final color = selected ? AppColors.color1 : _NavColors.muted;

                return FloatingNavbarItem(
                  customWidget: SizedBox(
                    height: _NavScale.baseItemHeight * uiScale,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _items[i].icon,
                          size: _NavScale.baseIconSize * uiScale,
                          color: color,
                        ),
                        SizedBox(height: 3 * uiScale),
                        Text(
                          _items[i].label,
                          maxLines: 1,
                          style: GoogleFonts.cairo(
                            fontSize: _NavScale.baseFontSize * uiScale,
                            color: color,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}
