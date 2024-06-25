import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController instance = Get.find();

  bool isDarkMode = false;
  SharedPreferences? sharedPreferences;

  @override
  void onInit() {
    isDarkMode = sharedPreferences!.getBool("isDarkMode") ?? false;
    Get.forceAppUpdate();
    super.onInit();
  }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    if (isDarkMode) {
      sharedPreferences!.setBool("isDarkMode", true);
      Get.forceAppUpdate();
    } else {
      Get.changeTheme(ThemeData.light());
      sharedPreferences!.setBool("isDarkMode", false);
    }
    Get.forceAppUpdate();
  }
}
