import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/custom_elevated_button.dart';
import 'package:future_green_world/res/components/custom_text_field.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:get/get.dart';
import 'package:the_validator/the_validator.dart';

import '../../main.dart';

class UpdatePracticeQuestionsCount extends StatefulWidget {
  const UpdatePracticeQuestionsCount({super.key});

  @override
  State<UpdatePracticeQuestionsCount> createState() =>
      _UpdatePracticeQuestionsCountState();
}

class _UpdatePracticeQuestionsCountState
    extends State<UpdatePracticeQuestionsCount> {
  final questionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    questionsController.text =
        sharedPreferences!.getInt("questionsCount") == null
            ? "50"
            : sharedPreferences!.getInt("questionsCount").toString();
  }

  @override
  void dispose() {
    questionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: Get.height * 0.04,
        ),
        CustomTextField(
            controller: questionsController,
            hintText: 'Practice Questions',
            labelText: 'Practice Questions',
            keyboardType: const TextInputType.numberWithOptions(),
            textInputAction: TextInputAction.done,
            validator: FieldValidator.required(),
            savedValue: (_) {}),
        SizedBox(
          height: Get.height * 0.04,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomElevatedButton(
              title: 'Cancel',
              buttonColor: AppColors.kGrey,
              onPress: () {
                Get.back();
              },
              width: Get.width * 0.35,
            ),
            CustomElevatedButton(
              title: 'Save',
              onPress: () {
                sharedPreferences!.setInt(
                    "questionsCount", int.parse(questionsController.text));
                Get.back();
              },
              width: Get.width * 0.35,
            ),
          ],
        ),
        SizedBox(
          height: Get.height * 0.04,
        ),
      ],
    ).paddingHrz(15);
  }
}
