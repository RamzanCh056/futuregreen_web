import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:future_green_world/models/chapter.dart';
import 'package:future_green_world/models/flash_card.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/custom_safe_area.dart';
import 'package:future_green_world/res/components/custom_snackbar.dart';
import 'package:future_green_world/res/components/custom_text_button.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/components/loading.dart';
import 'package:future_green_world/res/controller/controller_instances.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:future_green_world/view/flashCards/flash_cards.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../models/exam.dart';
import '../../res/components/custom_pop_up.dart';

class FlashCardChapterScreen extends StatelessWidget {
  const FlashCardChapterScreen({super.key, required this.exam});

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
          'Flash Card Chapters',
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
              .collection("flashCardChapters")
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
                              .collection("flashCards")
                              .where("chapterId", isEqualTo: chapter.id)
                              .where('participants',
                                  arrayContains:
                                      authController.getCurrentUser())
                              .get()
                              .then((value) async {
                            List<FlashCardModel> cards = value.docs
                                .map<FlashCardModel>(
                                    (e) => FlashCardModel.fromJson(e))
                                .toList();

                            for (FlashCardModel flashCard in cards) {
                              await firestore
                                  .collection("flashCards")
                                  .doc(flashCard.id)
                                  .update({
                                "participants": FieldValue.arrayRemove(
                                    [authController.getCurrentUser()]),
                                "favourites": FieldValue.arrayRemove(
                                    [authController.getCurrentUser()])
                              });
                            }
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
                  text: 'Total Flash Cards: ',
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
            StreamBuilder<dynamic>(
                stream: firestore
                    .collection("flashCards")
                    .where("chapterId", isEqualTo: chapter.id)
                    .where("participants",
                        arrayContains: authController.getCurrentUser())
                    .snapshots(),
                builder: (context, snapshot) {
                  return Row(
                    children: [
                      Flexible(
                        child: StepProgressIndicator(
                          size: 5,
                          padding: 0,
                          totalSteps: chapter.totalQuestions == 0
                              ? 1
                              : chapter.totalQuestions,
                          currentStep:
                              snapshot.hasData ? snapshot.data.docs.length : 0,
                          roundedEdges: const Radius.circular(10),
                          selectedColor: AppColors.kPrimary,
                          unselectedColor: AppColors.kWhite,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.05,
                      ),
                      CustomTextButton(
                          text: snapshot.hasData
                              ? (snapshot.data.docs.isNotEmpty
                                  ? "Continue"
                                  : snapshot.data.docs.length ==
                                          chapter.totalQuestions
                                      ? "Restart"
                                      : 'Start')
                              : '.....',
                          onPressed: () async {
                            if (snapshot.hasData) {
                              if (snapshot.data.docs.length ==
                                  chapter.totalQuestions) {
                                loadingDialog("Restarting...");
                                await firestore
                                    .collection("flashCards")
                                    .where("chapterId", isEqualTo: chapter.id)
                                    .where('participants',
                                        arrayContains:
                                            authController.getCurrentUser())
                                    .get()
                                    .then((value) async {
                                  List<FlashCardModel> cards = value.docs
                                      .map<FlashCardModel>(
                                          (e) => FlashCardModel.fromJson(e))
                                      .toList();

                                  for (FlashCardModel flashCard in cards) {
                                    await firestore
                                        .collection("flashCards")
                                        .doc(flashCard.id)
                                        .update({
                                      "participants": FieldValue.arrayRemove(
                                          [authController.getCurrentUser()]),
                                      "favourites": FieldValue.arrayRemove(
                                          [authController.getCurrentUser()])
                                    });
                                  }
                                }).then((_) {
                                  Get.close(1);
                                  Get.to(() => FlashCardScreen(
                                        chapter: chapter,
                                      ));
                                });
                              } else {
                                Get.to(() => FlashCardScreen(
                                      chapter: chapter,
                                    ));
                              }
                            }
                          }),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
