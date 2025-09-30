import 'package:engo/screens/settings.dart';
import 'package:engo/screens/stories_page.dart';
import 'package:engo/screens/levelpage.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> pages = [
    const LevelPage(),
    const StoriesPage(),
    const SettingsPage(),
  ];

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());

    return Scaffold(
      body: Obx(() => controller.pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => ConvexAppBar(
          style: TabStyle.reactCircle,
          backgroundColor: Colors.teal,
          activeColor: Colors.white,
          color: Colors.white,
          height: 40,
          top: -20,
          curveSize: 100,
          cornerRadius: 0,
          shadowColor: Colors.black,
          elevation: 1,
          items: [
            TabItem(
              icon: Icon(
                Icons.layers_rounded,
                color: controller.currentIndex.value == 0
                    ? Colors.teal
                    : Colors.white,
                size: 30,
              ),
            ),
            TabItem(
              icon: Icon(
                Icons.menu_book_rounded,
                color: controller.currentIndex.value == 1
                    ? Colors.teal
                    : Colors.white,
                size: 30,
              ),
            ),
            TabItem(
              icon: Icon(
                Icons.settings_rounded,
                color: controller.currentIndex.value == 2
                    ? Colors.teal
                    : Colors.white,
                size: 30,
              ),
            ),
          ],
          initialActiveIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.changeTabIndex(index);
          },
        ),
      ),
    );
  }
}
