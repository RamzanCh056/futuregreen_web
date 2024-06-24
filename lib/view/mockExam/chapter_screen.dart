import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:future_green_world/models/mock_exam_question.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/custom_safe_area.dart';
import 'package:future_green_world/res/components/custom_snackbar.dart';
import 'package:future_green_world/res/components/custom_text_button.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/components/loading.dart';
import 'package:future_green_world/res/controller/controller_instances.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:future_green_world/view/mockExam/mock_exam.dart';
import 'package:get/get.dart';

import '../../models/exam.dart';
import '../../models/mock_chapter.dart';

class MockExamChapterScreen extends StatelessWidget {
  const MockExamChapterScreen({super.key, required this.exam});

  final ExamModel exam;

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(
      backgroundColor: themeController.isDarkMode
          ? DarkModeColors.kBodyColor
          : AppColors.kWhite,
      appBar: AppBar(
        backgroundColor: themeController.isDarkMode
            ? DarkModeColors.kAppBarColor
            : AppColors.kWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: themeController.isDarkMode
                ? DarkModeColors.kWhite
                : AppColors.kBlack,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Mock Exam Chapters',
          style: TextStyle(
            fontFamily: AppFonts.poppinsBold,
            color: themeController.isDarkMode
                ? DarkModeColors.kWhite
                : AppColors.kBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<dynamic>(
          stream: firestore
              .collection("mockExamChapters")
              .where("examId", isEqualTo: exam.id)
              .orderBy("no")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<MockChapterModel> chapters = snapshot.data!.docs
                  .map<MockChapterModel>((e) => MockChapterModel.fromJson(e))
                  .toList();

              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      ...List.generate(
                          chapters.length,
                          (index) => CustomChapterCard(
                                cardColor: AppColors.colorList[
                                    int.parse(index.remainder(10).toString())],
                                chapter: chapters[index],
                              ).paddingB(10)),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                    ],
                  ));
            } else {
              return const Center(child: Loading());
            }
          }),
    ));
  }
}

class CustomChapterCard extends StatelessWidget {
  const CustomChapterCard({
    super.key,
    required this.cardColor,
    required this.chapter,
  });

  final Color? cardColor;
  final MockChapterModel chapter;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Get.height * 0.005,
            ),
            Text(
              chapter.name,
              style: const TextStyle(
                  fontFamily: AppFonts.poppinsBold,
                  fontSize: 24,
                  color: AppColors.kWhite),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                      text: 'Total Questions: ',
                      style: const TextStyle(
                        color: AppColors.kWhite,
                        fontFamily: AppFonts.poppinsRegular,
                      ),
                      children: [
                        TextSpan(
                          text: "${chapter.totalQuestions}",
                          style: const TextStyle(
                            color: AppColors.kWhite,
                            fontSize: 15,
                            fontFamily: AppFonts.poppinsBold,
                          ),
                        ),
                      ]),
                ).flexible,
                SizedBox(
                  width: Get.width * 0.05,
                ),
                CustomTextButton(
                    text: chapter.allowedUsers
                            .contains(authController.getCurrentUser())
                        ? 'Start'
                        : "Locked",
                    color: chapter.allowedUsers
                            .contains(authController.getCurrentUser())
                        ? null
                        : AppColors.kRed,
                    onPressed: () async {
                      if (chapter.allowedUsers
                          .contains(authController.getCurrentUser())) {
                        loadingDialog("Preparing Exam Please Wait...");
                        await firestore
                            .collection("mockExamQuestions")
                            .where("chapterId", isEqualTo: chapter.id)
                            .where("participants",
                                arrayContains: authController.getCurrentUser())
                            .get()
                            .then((value) async {
                          if (value.docs.isEmpty) {
                            1.pop;
                            Get.to(() => MockExamScreen(
                                  chapter: chapter,
                                ));
                          } else {
                            int count = 0;
                            for (dynamic doc in value.docs) {
                              count++;
                              var question =
                                  MockExamQuestionModel.fromJson(doc);
                              await firestore
                                  .collection("mockExamQuestions")
                                  .doc(question.id)
                                  .update({
                                "attempted": FieldValue.arrayRemove([
                                  question.attempted
                                      .where((e) =>
                                          e.uid ==
                                          authController.getCurrentUser())
                                      .first
                                      .toMap()
                                ]),
                                "participants": FieldValue.arrayRemove(
                                    [authController.getCurrentUser()])
                              });
                              if (count == 2) {
                                1.pop;
                                Get.to(() => MockExamScreen(
                                      chapter: chapter,
                                    ));
                              }
                            }
                          }
                        });
                      } else {
                        showErrorSnackbar("Chapter is Locked!", context);
                      }
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
