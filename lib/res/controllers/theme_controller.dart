import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController instance = Get.find();

  bool isDarkMode = false;
  SharedPreferences? sharedPreferences;

  @override
  void onInit() async {
    super.onInit();
    sharedPreferences = await SharedPreferences.getInstance();
    isDarkMode = sharedPreferences?.getBool("isDarkMode") ?? false;
    Get.changeTheme(isDarkMode ? ThemeData.dark() : ThemeData.light());
  }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    sharedPreferences?.setBool("isDarkMode", isDarkMode);
    Get.changeTheme(isDarkMode ? ThemeData.dark() : ThemeData.light());
    update();
  }
}
