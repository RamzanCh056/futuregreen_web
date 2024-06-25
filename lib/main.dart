import 'package:flutter/material.dart';
import 'package:future_green_world/res/controllers/theme_controller.dart';
import 'package:future_green_world/screens/login_screen.dart';
import 'package:get/get.dart';

void main() {
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future Green World',
      home: LoginScreen(),
    );
  }
}
