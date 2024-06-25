import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/controllers/theme_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../fonts/app_fonts.dart';

Future showCustomPopUp(
    BuildContext context,
    String title,
    String bodyText,
    String cancelText,
    Color cancelColor,
    String confirmText,
    Color confirmColor,
    Function()? onConfirm) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      final ThemeController themeController =
          Get.find<ThemeController>(); // Reference to ThemeController

      return AlertDialog(
        backgroundColor: themeController.isDarkMode
            ? DarkModeColors.kAppBarColor
            : AppColors.kWhite,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        title: Text(
          title.toUpperCase(),
          style: TextStyle(
              fontFamily: AppFonts.poppinsBold,
              color: themeController.isDarkMode
                  ? DarkModeColors.kWhite
                  : AppColors.kBlack,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 3),
        ),
        content: Text(
          bodyText,
          style: TextStyle(
              fontSize: 16,
              color: themeController.isDarkMode
                  ? DarkModeColors.kWhite
                  : AppColors.kBlack),
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text(
              cancelText,
              style: TextStyle(fontSize: 15, color: cancelColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            onPressed: onConfirm,
            child: Text(
              confirmText,
              style: TextStyle(fontSize: 15, color: confirmColor),
            ),
          ),
        ],
      );
    },
  );
}
