import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/web_custom_elevated_button.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:get/get.dart';

class WebCustomDialog extends StatelessWidget {
  const WebCustomDialog({
    super.key,
    required this.text,
    required this.firstButtonText,
    required this.secondButtonText,
    required this.onPressFirstButton,
    required this.onPressSecondButton,
  });
  final String text;
  final String firstButtonText;
  final String secondButtonText;
  final void Function()? onPressFirstButton;
  final void Function()? onPressSecondButton;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: AppFonts.poppinsRegular, fontSize: 24),
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WebCustomElevatedButton(
                        title: firstButtonText,
                        width: Get.width * 0.3,
                        height: 40,
                        buttonColor: AppColors.kWhite,
                        textColor: AppColors.kPrimary,
                        onPress: onPressFirstButton,
                      ),
                      SizedBox(
                        width: Get.width * 0.1,
                      ),
                      WebCustomElevatedButton(
                        title: secondButtonText,
                        width: Get.width * 0.3,
                        height: 40,
                        onPress: onPressSecondButton,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
