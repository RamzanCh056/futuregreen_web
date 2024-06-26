import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/web_custom_elevated_button.dart';
import 'package:future_green_world/res/components/web_scaffold.dart';
import 'package:future_green_world/screens/login_screen.dart';
import 'package:get/get.dart';

class SelectTopic extends StatefulWidget {
  const SelectTopic({super.key});

  @override
  State<SelectTopic> createState() => _SelectTopicState();
}

class _SelectTopicState extends State<SelectTopic> {
  int? selectedExamIndex;

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: 80),
            Container(
              // padding: const EdgeInsets.symmetric(horizontal: 35),
              child: const Text(
                "Select Topic Study",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              // padding: const EdgeInsets.symmetric(horizontal: 30),
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
                ...List.generate(exams.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedExamIndex == index) {
                          selectedExamIndex = null;
                        } else {
                          selectedExamIndex = index;
                        }
                      });
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 15, right: 15, top: 8),
                      decoration: BoxDecoration(
                        color: selectedExamIndex == index
                            ? AppColors.greenColor.withOpacity(0.2)
                            : null,
                        border: Border.all(
                            color: AppColors.greyColor.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Image.asset(
                              exams[index].iconPath,
                              height: 40,
                              width: 40,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              exams[index].name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            selectedExamIndex == index
                                ? Image.asset(
                                    'assets/icons/selected.png',
                                    height: 20,
                                    width: 20,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: Get.height * 0.08),
                GestureDetector(
                  onTap: () {
                    if (selectedExamIndex != null) {
                      Get.to(() => ExamsScreen(
                            examData: exams[selectedExamIndex!],
                          ));
                    }
                  },
                  child: WebCustomElevatedButton(
                    title: 'Continue',
                    onPress: () => LoginScreen(),
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
}

// Mock ExamModel for demonstration purposes
class ExamModel {
  final String name;
  final String iconPath;

  ExamModel({required this.name, required this.iconPath});
}

// Mock ExamsScreen for demonstration purposes
class ExamsScreen extends StatelessWidget {
  final ExamModel examData;

  const ExamsScreen({required this.examData, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(examData.name),
      ),
      body: Center(
        child: Text('Welcome to the ${examData.name} exam screen!'),
      ),
    );
  }
}
