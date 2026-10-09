// lib/widgets/bottom_nav_bar.dart

import 'package:engo/pages/page1/roadmap/roadmap_page.dart';

import 'package:engo/pages/page2/level_page.dart';
import 'package:engo/pages/page3/page2.dart';

import 'package:engo/pages/page4/settings.dart';
import 'package:engo/widgets/bottom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  // 🟢 الصفحات
  static const List<Widget> _pages = [
    RoadMapPage(),
    LevelPage(),
    Page3(),
    SettingsPage(),
  ];

  // 🟢 مسارات أيقونات SVG من assets/icons/
  static const List<String> _svgIcons = [
    'assets/icons/fluent-color--home-32.svg', // 🏠 الرئيسية
    'assets/icons/fluent-color--list-bar-32.svg', // 📚 المسار
    'assets/icons/fluent-color--trophy-48.svg', // 🎮 الألعاب
    'assets/icons/streamline-stickies-color--wrench-duo.svg', // ⚙️ الإعدادات
  ];

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());

    return Scaffold(
      extendBody: true,

      body: Obx(() => _pages[controller.currentIndex.value]),

      bottomNavigationBar: Obx(
        () => SizedBox(
          height: 110,

          child: FloatingNavbar(
            backgroundColor: Colors.grey.shade200,
            selectedBackgroundColor: Colors.blue.shade100,

            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTabIndex,

            items: List.generate(_svgIcons.length, (i) {
              return FloatingNavbarItem(
                customWidget: SvgPicture.asset(
                  _svgIcons[i],
                  width: 30,
                  height: 30,
                ),
              );
            }),

            borderRadius: 20,

            itemBorderRadius: 15,

            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          ),
        ),
      ),
    );
  }
}
