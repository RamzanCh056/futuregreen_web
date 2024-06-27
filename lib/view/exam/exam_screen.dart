import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/web_custom_elevated_button.dart';
import 'package:future_green_world/res/components/web_scaffold.dart';
import 'package:future_green_world/view/exam/exam_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({Key? key, required this.exam});
  final ExamModel exam;

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  bool isPracticeSwitched = false;
  bool isChapterSelected = false;
  bool isMockExamSelected = false;
  bool isFactSheetSelected = false;
  bool isStudyNotesSelected = false;
  bool isFlashCardsSelected = false;

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 12,
                  ),
                ),
                const Text(
                  "CFA ESG Investing",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  "Select Category",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isPracticeSwitched = !isPracticeSwitched;
                  });
                },
                child: WebManualWidget(
                  imageUrl: 'assets/icons/practice_exam.png',
                  text: "Practice Exam",
                  isSelected: isPracticeSwitched,
                  switchIcon: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: isPracticeSwitched,
                      onChanged: (value) {
                        setState(() {
                          isPracticeSwitched = value;
                        });
                      },
                      activeTrackColor: AppColors.kPrimary,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isChapterSelected = !isChapterSelected;
                  });
                },
                child: WebManualWidget(
                  imageUrl: 'assets/icons/practice chapter.png',
                  text: "Practice By Chapter",
                  isSelected: isChapterSelected,
                  switchIcon: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: isChapterSelected,
                      onChanged: (value) {
                        setState(() {
                          isChapterSelected = value;
                        });
                      },
                      activeTrackColor: AppColors.kPrimary,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMockExamSelected = !isMockExamSelected;
                  });
                },
                child: WebManualWidget(
                  imageUrl: 'assets/icons/exam.png',
                  text: "Mock Exam",
                  isSelected: isMockExamSelected,
                  switchIcon: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: isMockExamSelected,
                      onChanged: (value) {
                        setState(() {
                          isMockExamSelected = value;
                        });
                      },
                      activeTrackColor: AppColors.kPrimary,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isFactSheetSelected = !isFactSheetSelected;
                  });
                },
                child: WebManualWidget(
                  imageUrl: 'assets/icons/fact_icon.png',
                  text: "Fact Sheet",
                  isSelected: isFactSheetSelected,
                  switchIcon: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: isFactSheetSelected,
                      onChanged: (value) {
                        setState(() {
                          isFactSheetSelected = value;
                        });
                      },
                      activeTrackColor: AppColors.kPrimary,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isFlashCardsSelected = !isFlashCardsSelected;
                  });
                },
                child: WebManualWidget(
                  imageUrl: 'assets/icons/flash card.png',
                  text: "Flash Cards",
                  isSelected: isFlashCardsSelected,
                  switchIcon: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: isFlashCardsSelected,
                      onChanged: (value) {
                        setState(() {
                          isFlashCardsSelected = value;
                        });
                      },
                      activeTrackColor: AppColors.kPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          if (isPracticeSwitched ||
              isChapterSelected ||
              isMockExamSelected ||
              isFactSheetSelected ||
              isFlashCardsSelected)
            Center(
              child: WebCustomElevatedButton(
                width: Get.width * 0.5,
                title: 'Continue',
                onPress: () {
                  // Get.to(() => const SelectTopic());
                },
              ),
            ),
        ],
      ),
    );
  }
}

class WebManualWidget extends StatelessWidget {
  final String imageUrl;
  final String text;
  final bool isSelected;
  final Widget? switchIcon;

  const WebManualWidget({
    Key? key,
    required this.imageUrl,
    required this.text,
    required this.isSelected,
    this.switchIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? AppColors.greyColor.withOpacity(0.2)
              : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? Colors.white : AppColors.greyColor.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Image.asset(
            imageUrl,
            height: 40, // Adjust the height of the image
            width: 40, // Adjust the width of the image
            //  color: isSelected ? null : AppColors.greyColor.withOpacity(0.3),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12, // Adjust the font size of the text
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? Colors.black
                    : AppColors.greyColor.withOpacity(0.8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          switchIcon ?? const SizedBox(),
        ],
      ),
    );
  }
}
