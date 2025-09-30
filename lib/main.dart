import 'package:engo/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English App',
      // show home based on saved session
      home: WelcomePage(),

      // initialLoggedIn ? const BottomNavBar() : LoginPage() ,
    );
  }
}
