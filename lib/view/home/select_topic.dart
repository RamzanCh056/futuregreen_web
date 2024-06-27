import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/view/exam/exam_tile.dart';
import 'package:future_green_world/view/exam/level_tile.dart';
import 'package:future_green_world/res/components/web_custom_elevated_button.dart';
import 'package:future_green_world/res/components/web_scaffold.dart';
import 'package:future_green_world/view/exam/exam_model.dart';
import 'package:future_green_world/view/home/study%20mode/study_mode.dart';
import 'package:get/get.dart';

class SelectTopic extends StatefulWidget {
  const SelectTopic({super.key});

  @override
  State<SelectTopic> createState() => _SelectTopicState();
}

class _SelectTopicState extends State<SelectTopic> {
  int? selectedExamIndex;
  bool showLevels = false;

  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    List<ExamModel> exams = [
      ExamModel(
          name: "CFA ESG Investing", iconPath: 'assets/icons/CFA_Book.png'),
      ExamModel(name: "GARP SCR", iconPath: 'assets/icons/GARP_book.png'),
      ExamModel(name: "CAIA", iconPath: 'assets/icons/CAIA_book-1.png'),
      ExamModel(name: "CIPM", iconPath: 'assets/icons/CAIA_book.png'),
    ];

    return WebScaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: const Text(
                "Select Topic Study",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              child: const Text(
                "Please select your topic study that you want to learn.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyColor,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!showLevels)
                  ...List.generate(exams.length, (index) {
                    return ExamTile(
                      exam: exams[index],
                      isSelected: selectedExamIndex == index,
                      onTap: () {
                        setState(() {
                          selectedExamIndex = index;
                        });
                      },
                    );
                  }),
                if (showLevels && selectedExamIndex != null)
                  Column(
                    children: [
                      LevelTile(
                        exam: exams[selectedExamIndex!],
                        level: "Level 1",
                        isSelected: false,
                        onTap: () {
                          navigateToExamScreen();
                        },
                      ),
                      LevelTile(
                        exam: exams[selectedExamIndex!],
                        level: "Level 2",
                        isSelected: false,
                        onTap: () {
                          navigateToExamScreen();
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 18),
                if (selectedExamIndex != null && !showLevels)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showLevels = true;
                      });
                    },
                    child: WebCustomElevatedButton(
                      title: 'Continue',
                      onPress: () {
                        setState(() {
                          showLevels = true;
                        });
                      },
                      width: Get.width * 0.6,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void navigateToExamScreen() {
    Get.to(() => const StudyMode());
  }
}
