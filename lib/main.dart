import 'package:engo/widgets/welcome.dart';
import 'package:engo/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final hasSeenWelcome = box.read('hasSeenWelcome') ?? false;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Engo',
      // show home based on saved session
      home: hasSeenWelcome ? const BottomNavBar() : const WelcomePage(),
    );
  }
}
