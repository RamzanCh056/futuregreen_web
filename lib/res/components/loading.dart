import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:future_green_world/res/controllers/theme_controller.dart';
import 'package:get/get.dart';

import '../colors/app_colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.color, this.size, this.text, this.textColor});
  final double? size;
  final Color? color;
  final String? text;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.find<ThemeController>(); // Reference to ThemeController

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpinKitThreeBounce(
          color: color ?? AppColors.kPrimary,
          size: size ?? 45,
        ),
        text != null
            ? Text(
                text!,
                style: TextStyle(
                    color: themeController.isDarkMode
                        ? textColor ?? DarkModeColors.kWhite
                        : textColor ?? AppColors.kBlack),
              )
            : const SizedBox(),
      ],
    );
  }
}

void loadingDialog(String? text) async {
  return Get.dialog(
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
            child: Loading(
          size: 50,
        )),
        text != null
            ? Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      text,
                      style: TextStyle(
                        color: AppColors.kWhite.withOpacity(0.7),
                        fontSize: Get.height / 55,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox()
      ],
    ),
    barrierDismissible: false,
  );
}
