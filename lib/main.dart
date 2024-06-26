import 'package:flutter/material.dart';
import 'package:future_green_world/view/home/select_topic.dart';
import 'package:get/get.dart';
import 'package:future_green_world/res/controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() async => ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Future Green World',
          theme:
              themeController.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: const SelectTopic(),
        );
      },
    );
  }
}
