import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:future_green_world/models/chapter.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/custom_safe_area.dart';
import 'package:future_green_world/res/components/custom_snackbar.dart';
import 'package:future_green_world/res/components/custom_text_button.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/components/loading.dart';
import 'package:future_green_world/res/controller/controller_instances.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../models/exam.dart';
import '../../models/question.dart';
import '../../res/components/custom_pop_up.dart';
import '../quiz/quiz_screen.dart';

class ChapterScreen extends StatelessWidget {
  const ChapterScreen({super.key, required this.exam});

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
          'Chapters',
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
              .collection("chapters")
              .where("examId", isEqualTo: exam.id)
              .orderBy("no")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ChapterModel> chapters = snapshot.data!.docs
                  .map<ChapterModel>((e) => ChapterModel.fromJson(e))
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
  final ChapterModel chapter;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  chapter.name,
                  style: const TextStyle(
                      fontFamily: AppFonts.poppinsBold,
                      fontSize: 24,
                      color: AppColors.kWhite),
                ).flexible,
                IconButton(
                    onPressed: () => showCustomPopUp(
                            context,
                            "Reset",
                            "It will reset all your progress. Are you sure to continue?",
                            "Cancel",
                            AppColors.kGreen,
                            "Reset",
                            AppColors.kRed, () async {
                          loadingDialog("Resetting Progress...");
                          await firestore
                              .collection("chapters")
                              .doc(chapter.id)
                              .update({
                            "participants": FieldValue.arrayRemove(
                                [authController.getCurrentUser()])
                          }).then((_) async {
                            await firestore
                                .collection("chapters")
                                .doc(chapter.id)
                                .collection('participants')
                                .doc(authController.getCurrentUser())
                                .delete()
                                .then((_) async {
                              await firestore
                                  .collection("questions")
                                  .where("chapterId", isEqualTo: chapter.id)
                                  .get()
                                  .then((value) async {
                                List<QuestionModel> questions = value.docs
                                    .map<QuestionModel>(
                                        (e) => QuestionModel.fromJson(e))
                                    .toList();
                                questions = questions
                                    .where((element) => element.attempted
                                        .where((e) =>
                                            e.uid ==
                                            authController.getCurrentUser())
                                        .isNotEmpty)
                                    .toList();
                                for (QuestionModel question in questions) {
                                  await firestore
                                      .collection("questions")
                                      .doc(question.id)
                                      .update({
                                    "attempted": FieldValue.arrayRemove([
                                      question.attempted
                                          .where((e) =>
                                              e.uid ==
                                              authController.getCurrentUser())
                                          .toList()
                                          .first
                                          .toMap()
                                    ])
                                  });
                                }
                              });
                            });
                          }).then((_) {
                            Get.close(2);
                            showMessageSnackbar(
                                "Chapter Reset successful", context);
                          });
                        }),
                    icon: const Icon(
                      Icons.restart_alt,
                      color: AppColors.kWhite,
                    ))
              ],
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
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
            ),
            SizedBox(
              height: Get.height * 0.005,
            ),
            chapter.participants.contains(authController.getCurrentUser())
                ? StreamBuilder<dynamic>(
                    stream: firestore
                        .collection("chapters")
                        .doc(chapter.id)
                        .collection("participants")
                        .doc(authController.getCurrentUser())
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        ParticipantModel participant =
                            ParticipantModel.fromJson(snapshot.data!);
                        return Row(
                          children: [
                            Flexible(
                              child: StepProgressIndicator(
                                size: 5,
                                padding: 0,
                                totalSteps: chapter.totalQuestions == 0
                                    ? participant.attempted + 1
                                    : chapter.totalQuestions,
                                currentStep: participant.attempted,
                                roundedEdges: const Radius.circular(10),
                                selectedColor: AppColors.kPrimary,
                                unselectedColor: AppColors.kWhite,
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.05,
                            ),
                            CustomTextButton(
                                text: chapter.totalQuestions ==
                                        participant.attempted
                                    ? "Restart"
                                    : 'Continue',
                                onPressed: () async {
                                  if (chapter.totalQuestions ==
                                      participant.attempted) {
                                    loadingDialog("Restarting...");
                                    await firestore
                                        .collection("chapters")
                                        .doc(chapter.id)
                                        .update({
                                      "participants": FieldValue.arrayRemove(
                                          [authController.getCurrentUser()])
                                    }).then((_) async {
                                      await firestore
                                          .collection("chapters")
                                          .doc(chapter.id)
                                          .collection('participants')
                                          .doc(authController.getCurrentUser())
                                          .delete()
                                          .then((_) async {
                                        await firestore
                                            .collection("questions")
                                            .where("chapterId",
                                                isEqualTo: chapter.id)
                                            .get()
                                            .then((value) async {
                                          List<QuestionModel> questions = value
                                              .docs
                                              .map<QuestionModel>((e) =>
                                                  QuestionModel.fromJson(e))
                                              .toList();
                                          questions = questions
                                              .where((element) => element
                                                  .attempted
                                                  .where((e) =>
                                                      e.uid ==
                                                      authController
                                                          .getCurrentUser())
                                                  .isNotEmpty)
                                              .toList();
                                          for (QuestionModel question
                                              in questions) {
                                            await firestore
                                                .collection("questions")
                                                .doc(question.id)
                                                .update({
                                              "attempted":
                                                  FieldValue.arrayRemove([
                                                question.attempted
                                                    .where((e) =>
                                                        e.uid ==
                                                        authController
                                                            .getCurrentUser())
                                                    .toList()
                                                    .first
                                                    .toMap()
                                              ])
                                            });
                                          }
                                        });
                                      });
                                    }).then((_) {
                                      Get.close(1);
                                      Get.to(() => QuizScreen(
                                            chapter: chapter,
                                          ));
                                    });
                                  } else {
                                    Get.to(() => QuizScreen(
                                          chapter: chapter,
                                        ));
                                  }
                                }),
                          ],
                        );
                      } else {
                        return const Center(
                          child: Loading(
                            size: 20,
                          ),
                        );
                      }
                    })
                : Row(
                    children: [
                      Flexible(
                        child: StepProgressIndicator(
                          size: 5,
                          padding: 0,
                          totalSteps: chapter.totalQuestions == 0
                              ? 1
                              : chapter.totalQuestions,
                          currentStep: 0,
                          roundedEdges: const Radius.circular(10),
                          selectedColor: AppColors.kPrimary,
                          unselectedColor: AppColors.kWhite,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.05,
                      ),
                      CustomTextButton(
                          text: 'Start',
                          onPressed: () {
                            Get.to(() => QuizScreen(
                                  chapter: chapter,
                                ));
                          })
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
