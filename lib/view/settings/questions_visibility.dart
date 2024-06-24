import 'package:flutter/material.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../res/colors/app_colors.dart';
import '../../res/controller/controller_instances.dart';
import '../../res/fonts/app_fonts.dart';

class QuestionsVisibility extends StatefulWidget {
  const QuestionsVisibility({super.key});

  @override
  State<QuestionsVisibility> createState() => _QuestionsVisibilityState();
}

class _QuestionsVisibilityState extends State<QuestionsVisibility> {
  String visibility = '';

  @override
  void initState() {
    super.initState();
    visibility = sharedPreferences!.getString("questionsVisibility") == null
        ? "Show Unsolved Only"
        : sharedPreferences!.getString("questionsVisibility")!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: Get.height * 0.03,
        ),
        ListTile(
          onTap: () => {
            sharedPreferences!
                .setString("questionsVisibility", "Show Unsolved Only"),
            Get.back()
          },
          title: Text("Show Unsolved Only",
              style: TextStyle(
                fontFamily: AppFonts.poppinsMedium,
                fontSize: 16,
                color: visibility == "Show Unsolved Only"
                    ? AppColors.kGreen
                    : themeController.isDarkMode
                        ? DarkModeColors.kWhite
                        : AppColors.kBlack,
              )),
          trailing: visibility == "Show Unsolved Only"
              ? const Icon(
                  Icons.task_alt,
                  color: AppColors.kGreen,
                )
              : null,
        ),
        ListTile(
            onTap: () => {
                  sharedPreferences!
                      .setString("questionsVisibility", "Show All"),
                  Get.back()
                },
            title: Text("Show All",
                style: TextStyle(
                  fontFamily: AppFonts.poppinsMedium,
                  fontSize: 16,
                  color: visibility == "Show All"
                      ? AppColors.kGreen
                      : themeController.isDarkMode
                          ? DarkModeColors.kWhite
                          : AppColors.kBlack,
                )),
            trailing: visibility == "Show All"
                ? const Icon(
                    Icons.task_alt,
                    color: AppColors.kGreen,
                  )
                : null),
        SizedBox(
          height: Get.height * 0.04,
        ),
      ],
    ).paddingHrz(15);
  }
}
