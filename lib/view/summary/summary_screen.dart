import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:future_green_world/models/mock_chapter.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/custom_safe_area.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/components/loading.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../main.dart';
import '../../models/chapter.dart';
import '../../models/exam.dart';
import '../../res/controller/controller_instances.dart';

// ignore: must_be_immutable
class SummaryScreen extends StatelessWidget {
  SummaryScreen({super.key});

  var showExam = 'exam1'.obs;
  var showFlashCard = ''.obs;
  var showMockExam = ''.obs;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: CustomSafeArea(
          child: Scaffold(
        backgroundColor: themeController.isDarkMode
            ? DarkModeColors.kBodyColor
            : AppColors.kWhite,
        appBar: AppBar(
          backgroundColor: themeController.isDarkMode
              ? DarkModeColors.kAppBarColor
              : AppColors.kWhite,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            'Summary',
            style: TextStyle(
              fontFamily: AppFonts.poppinsBold,
              color: themeController.isDarkMode
                  ? DarkModeColors.kWhite
                  : AppColors.kBlack,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
              indicatorWeight: 3,
              unselectedLabelColor: themeController.isDarkMode
                  ? DarkModeColors.kWhite
                  : AppColors.kBlack,
              labelColor: AppColors.kPrimary,
              indicatorColor: AppColors.kPrimary,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              tabs: const [
                Tab(
                  text: "Overview",
                ),
                Tab(
                  text: "Exams/Chapters",
                ),
              ]),
        ),
        body: TabBarView(
          children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: Get.height * 0.01,
                ),
                //Overall Result Card
                StreamBuilder<dynamic>(
                    stream: firestore.collection("exams").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ExamModel> exams = snapshot.data!.docs
                            .map<ExamModel>((e) => ExamModel.fromJson(e))
                            .toList();
                        return Column(
                          children: List.generate(
                              exams.length,
                              (index) => StreamBuilder<dynamic>(
                                  stream: firestore
                                      .collection("chapters")
                                      .where("examId",
                                          isEqualTo: exams[index].id)
                                      .snapshots(),
                                  builder: (context, sn) {
                                    if (sn.hasData) {
                                      List<ChapterModel> chapters = sn
                                          .data!.docs
                                          .map<ChapterModel>(
                                              (e) => ChapterModel.fromJson(e))
                                          .toList();
                                      var totalQuestions = 0.obs;
                                      var attemptedQuestions = 0.obs;
                                      var correct = 0.obs;

                                      //Adding total Questions
                                      for (ChapterModel chapter in chapters) {
                                        totalQuestions = totalQuestions +
                                            chapter.totalQuestions;
                                        firestore
                                            .collection("chapters")
                                            .doc(chapter.id)
                                            .collection("participants")
                                            .doc(
                                                authController.getCurrentUser())
                                            .get()
                                            .then((value) {
                                          if (value.exists) {
                                            attemptedQuestions.value =
                                                (attemptedQuestions.value +
                                                    value["attempted"]) as int;
                                            correct.value = (correct.value +
                                                value["correct"]) as int;
                                          }
                                        });
                                      }

                                      return Obx(() {
                                        return CustomTitleCircularProgressCard(
                                            title: exams[index].name,
                                            totalQuestion:
                                                totalQuestions.value == 0
                                                    ? 1
                                                    : totalQuestions.value,
                                            attemptedQuestion:
                                                attemptedQuestions.value,
                                            score: correct.value == 0
                                                ? 0
                                                : ((correct.value /
                                                            attemptedQuestions
                                                                .value) *
                                                        100)
                                                    .toInt());
                                      });
                                    } else {
                                      return Loading(
                                        text: "Loading ${exams[index].name}",
                                      );
                                    }
                                  })),
                        );
                      } else {
                        return const Loading();
                      }
                    }).paddingHrz(10),

                //Practice Exams
                Card(
                  color: themeController.isDarkMode
                      ? DarkModeColors.kBodyColor
                      : AppColors.kWhite,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: AppColors.kPrimary)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Practice Exam',
                          style: TextStyle(
                              fontFamily: AppFonts.poppinsBold,
                              fontSize: 18,
                              color: themeController.isDarkMode
                                  ? DarkModeColors.kWhite
                                  : AppColors.kPrimary),
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularStepProgressIndicator(
                                  height: 120,
                                  width: 120,
                                  selectedColor: AppColors.kPrimary,
                                  unselectedColor:
                                      const Color.fromARGB(255, 199, 224, 211),
                                  roundedCap: (index, _) => true,
                                  padding: 0,
                                  totalSteps: 100,
                                  currentStep: sharedPreferences!
                                          .getInt("exam1Attempted") ??
                                      0,
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        sharedPreferences!
                                                    .getInt("exam1Attempted") !=
                                                null
                                            ? "${sharedPreferences!.getInt("exam1Attempted") ?? 0} / 100"
                                            : "--",
                                        style: const TextStyle(
                                            fontFamily: AppFonts.poppinsBold,
                                            fontSize: 20,
                                            color: AppColors.kPrimary),
                                      ),
                                      5.heightBox,
                                      Visibility(
                                        visible: sharedPreferences!
                                                .getInt("exam1Attempted") !=
                                            null,
                                        child: Text.rich(TextSpan(
                                            text:
                                                "${sharedPreferences!.getInt("exam1") ?? 0}%",
                                            style: const TextStyle(
                                                fontFamily:
                                                    AppFonts.poppinsBold,
                                                color: AppColors.kPrimary,
                                                fontSize: 13),
                                            children: const [
                                              TextSpan(
                                                text: ' Score',
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.poppinsMedium,
                                                    color: AppColors.kPrimary,
                                                    fontSize: 13),
                                              )
                                            ])),
                                      )
                                    ],
                                  )),
                                ),
                                const AutoSizeText(
                                  'CFA ESG Investing',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: AppFonts.poppinsBold,
                                      fontSize: 15,
                                      color: AppColors.kPrimary),
                                ).paddingT(10)
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularStepProgressIndicator(
                                  height: 120,
                                  width: 120,
                                  selectedColor: AppColors.kPrimary,
                                  unselectedColor:
                                      const Color.fromARGB(255, 199, 224, 211),
                                  roundedCap: (index, _) => true,
                                  padding: 0,
                                  totalSteps: 80,
                                  currentStep: sharedPreferences!
                                          .getInt("exam2Attempted") ??
                                      0,
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        sharedPreferences!
                                                    .getInt("exam2Attempted") !=
                                                null
                                            ? "${sharedPreferences!.getInt("exam2Attempted") ?? 0} / 80"
                                            : "--",
                                        style: const TextStyle(
                                            fontFamily: AppFonts.poppinsBold,
                                            fontSize: 20,
                                            color: AppColors.kPrimary),
                                      ),
                                      5.heightBox,
                                      Visibility(
                                        visible: sharedPreferences!
                                                .getInt("exam2Attempted") !=
                                            null,
                                        child: Text.rich(TextSpan(
                                            text:
                                                "${sharedPreferences!.getInt("exam2") ?? 0}%",
                                            style: const TextStyle(
                                                fontFamily:
                                                    AppFonts.poppinsBold,
                                                color: AppColors.kPrimary,
                                                fontSize: 13),
                                            children: const [
                                              TextSpan(
                                                text: ' Score',
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.poppinsMedium,
                                                    color: AppColors.kPrimary,
                                                    fontSize: 13),
                                              )
                                            ])),
                                      )
                                    ],
                                  )),
                                ),
                                const AutoSizeText(
                                  'GARP SCR',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: AppFonts.poppinsBold,
                                      fontSize: 15,
                                      color: AppColors.kPrimary),
                                ).paddingT(10)
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).paddingHrz(10),
                SizedBox(
                  height: Get.height * 0.01,
                ),
              ],
            ),
            ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                StreamBuilder<dynamic>(
                    stream: firestore.collection("exams").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ExamModel> exams = snapshot.data!.docs
                            .map<ExamModel>((e) => ExamModel.fromJson(e))
                            .toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              exams.length,
                              (index) => Obx(() {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        2.h.heightBox,
                                        GestureDetector(
                                          onTap: () {
                                            if (showExam.value ==
                                                exams[index].id) {
                                              showExam.value = '';
                                            } else {
                                              showExam.value = exams[index].id;
                                            }
                                          },
                                          child: Container(
                                            color: Ex.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  exams[index].name,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.poppinsBold,
                                                      fontSize: 22,
                                                      color: themeController
                                                              .isDarkMode
                                                          ? DarkModeColors
                                                              .kWhite
                                                          : AppColors.kPrimary),
                                                ),
                                                Icon(
                                                  showExam.value !=
                                                          exams[index].id
                                                      ? Icons
                                                          .keyboard_arrow_down
                                                      : Icons.keyboard_arrow_up,
                                                  color: themeController
                                                          .isDarkMode
                                                      ? DarkModeColors.kWhite
                                                      : AppColors.kBlack,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              showExam.value == exams[index].id,
                                          child: Column(
                                            children: [
                                              5.heightBox,
                                              //Grid View
                                              StreamBuilder<dynamic>(
                                                  stream: firestore
                                                      .collection("chapters")
                                                      .where("examId",
                                                          isEqualTo:
                                                              exams[index].id)
                                                      .orderBy("no")
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      List<ChapterModel>
                                                          chapters = snapshot
                                                              .data!.docs
                                                              .map<ChapterModel>(
                                                                  (e) => ChapterModel
                                                                      .fromJson(
                                                                          e))
                                                              .toList();
                                                      return StaggeredGrid
                                                          .count(
                                                              mainAxisSpacing:
                                                                  Get.width *
                                                                      0.01,
                                                              crossAxisSpacing:
                                                                  Get.width *
                                                                      0.01,
                                                              crossAxisCount: 2,
                                                              children:
                                                                  List.generate(
                                                                chapters.length,
                                                                (index) =>
                                                                    //Custom Summary Card
                                                                    StreamBuilder<
                                                                            dynamic>(
                                                                        stream: firestore
                                                                            .collection(
                                                                                "chapters")
                                                                            .doc(chapters[index]
                                                                                .id)
                                                                            .collection(
                                                                                "participants")
                                                                            .doc(authController
                                                                                .getCurrentUser())
                                                                            .snapshots(),
                                                                        builder:
                                                                            (context,
                                                                                sn) {
                                                                          if (sn
                                                                              .hasData) {
                                                                            if (sn.data.exists) {
                                                                              ParticipantModel participant = ParticipantModel.fromJson(sn.data!);
                                                                              return CustomSummaryChapterCard(
                                                                                name: chapters[index].name,
                                                                                totalQuestions: chapters[index].totalQuestions,
                                                                                correct: participant.correct,
                                                                                attempted: participant.attempted,
                                                                                cardColor: AppColors.colorList[int.parse(index.remainder(10).toString())],
                                                                              );
                                                                            } else {
                                                                              return CustomSummaryChapterCard(
                                                                                name: chapters[index].name,
                                                                                totalQuestions: chapters[index].totalQuestions,
                                                                                correct: 0,
                                                                                attempted: 0,
                                                                                cardColor: AppColors.colorList[int.parse(index.remainder(10).toString())],
                                                                              );
                                                                            }
                                                                          } else {
                                                                            return const SizedBox();
                                                                          }
                                                                        }),
                                                              ));
                                                    } else {
                                                      return const Loading(
                                                        text: "Loading Summary",
                                                      ).paddingT(20);
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ),
                                        10.heightBox,
                                        //Mock Exams
                                        GestureDetector(
                                          onTap: () {
                                            if (showMockExam.value ==
                                                exams[index].id) {
                                              showMockExam.value = '';
                                            } else {
                                              showMockExam.value =
                                                  exams[index].id;
                                            }
                                          },
                                          child: Container(
                                            color: Ex.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Mock Exam",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.poppinsBold,
                                                      fontSize: 18,
                                                      color: themeController
                                                              .isDarkMode
                                                          ? DarkModeColors
                                                              .kWhite
                                                          : AppColors.kPrimary),
                                                ),
                                                Icon(
                                                  showMockExam.value !=
                                                          exams[index].id
                                                      ? Icons
                                                          .keyboard_arrow_down
                                                      : Icons.keyboard_arrow_up,
                                                  color: themeController
                                                          .isDarkMode
                                                      ? DarkModeColors.kWhite
                                                      : AppColors.kBlack,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: showMockExam.value ==
                                              exams[index].id,
                                          child: Column(
                                            children: [
                                              5.heightBox, //Grid View Mock Exam
                                              StreamBuilder<dynamic>(
                                                  stream: firestore
                                                      .collection(
                                                          "mockExamChapters")
                                                      .where("examId",
                                                          isEqualTo:
                                                              exams[index].id)
                                                      .orderBy("no")
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      List<MockChapterModel>
                                                          chapters = snapshot
                                                              .data!.docs
                                                              .map<MockChapterModel>((e) =>
                                                                  MockChapterModel
                                                                      .fromJson(
                                                                          e))
                                                              .toList();
                                                      return StaggeredGrid.count(
                                                          mainAxisSpacing:
                                                              Get.width * 0.01,
                                                          crossAxisSpacing:
                                                              Get.width * 0.01,
                                                          crossAxisCount: 2,
                                                          children: List.generate(
                                                              chapters.length,
                                                              (index) => MockExamSummaryChapterCard(
                                                                  chapter:
                                                                      chapters[
                                                                          index],
                                                                  cardColor: AppColors
                                                                          .colorList[
                                                                      int.parse(index
                                                                          .remainder(
                                                                              10)
                                                                          .toString())])));
                                                    } else {
                                                      return const Loading(
                                                        text: "Loading Summary",
                                                      ).paddingT(20);
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ),
                                        10.heightBox,
                                        //Flash Cards
                                        GestureDetector(
                                          onTap: () {
                                            if (showFlashCard.value ==
                                                exams[index].id) {
                                              showFlashCard.value = '';
                                            } else {
                                              showFlashCard.value =
                                                  exams[index].id;
                                            }
                                          },
                                          child: Container(
                                            color: Ex.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Flash Cards",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.poppinsBold,
                                                      fontSize: 18,
                                                      color: themeController
                                                              .isDarkMode
                                                          ? DarkModeColors
                                                              .kWhite
                                                          : AppColors.kPrimary),
                                                ),
                                                Icon(
                                                  showFlashCard.value !=
                                                          exams[index].id
                                                      ? Icons
                                                          .keyboard_arrow_down
                                                      : Icons.keyboard_arrow_up,
                                                  color: themeController
                                                          .isDarkMode
                                                      ? DarkModeColors.kWhite
                                                      : AppColors.kBlack,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: showFlashCard.value ==
                                              exams[index].id,
                                          child: Column(
                                            children: [
                                              5.heightBox, //Grid View Flash Cards
                                              StreamBuilder<dynamic>(
                                                  stream: firestore
                                                      .collection(
                                                          "flashCardChapters")
                                                      .where("examId",
                                                          isEqualTo:
                                                              exams[index].id)
                                                      .orderBy("no")
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      List<ChapterModel>
                                                          chapters = snapshot
                                                              .data!.docs
                                                              .map<ChapterModel>(
                                                                  (e) => ChapterModel
                                                                      .fromJson(
                                                                          e))
                                                              .toList();
                                                      return StaggeredGrid
                                                          .count(
                                                              mainAxisSpacing:
                                                                  Get.width *
                                                                      0.01,
                                                              crossAxisSpacing:
                                                                  Get.width *
                                                                      0.01,
                                                              crossAxisCount: 2,
                                                              children:
                                                                  List.generate(
                                                                chapters.length,
                                                                (index) => FlashCardSummaryChapterCard(
                                                                    chapter:
                                                                        chapters[
                                                                            index],
                                                                    cardColor: AppColors
                                                                            .colorList[
                                                                        int.parse(index
                                                                            .remainder(10)
                                                                            .toString())]),
                                                              ));
                                                    } else {
                                                      return const Loading(
                                                        text: "Loading Summary",
                                                      ).paddingT(20);
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ).paddingT(20);
                                  })),
                        );
                      } else {
                        return const Loading();
                      }
                    }).paddingHrz(10),
                SizedBox(
                  height: Get.height * 0.01,
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class CustomSummaryChapterCard extends StatelessWidget {
  const CustomSummaryChapterCard({
    super.key,
    required this.name,
    required this.totalQuestions,
    required this.correct,
    required this.cardColor,
    required this.attempted,
  });
  final String name;
  final int totalQuestions;
  final int correct;
  final int attempted;
  final Color? cardColor;
  @override
  Widget build(BuildContext context) {
    int score = ((correct / (attempted == 0 ? 1 : attempted)) * 100).toInt();
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              name,
              maxLines: 2,
              minFontSize: 10,
              style: const TextStyle(
                  fontSize: 16,
                  fontFamily: AppFonts.poppinsBold,
                  color: AppColors.kWhite),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: StepProgressIndicator(
                    size: 5,
                    padding: 0,
                    totalSteps: totalQuestions == 0 ? 1 : totalQuestions,
                    currentStep: attempted,
                    roundedEdges: const Radius.circular(10),
                    selectedColor: AppColors.kPrimary,
                    unselectedColor: AppColors.kWhite,
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.02,
                ),
                Text.rich(TextSpan(
                    text: '$attempted',
                    style: const TextStyle(
                        fontFamily: AppFonts.poppinsBold,
                        color: AppColors.kWhite,
                        fontSize: 14),
                    children: [
                      TextSpan(
                        text: '/$totalQuestions',
                        style: const TextStyle(
                            fontFamily: AppFonts.poppinsMedium,
                            color: AppColors.kWhite,
                            fontSize: 13),
                      )
                    ])),
              ],
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Row(
              children: [
                Text(
                  '$score%',
                  style: const TextStyle(
                    fontFamily: AppFonts.poppinsBold,
                    color: AppColors.kWhite,
                  ),
                ),
                const AutoSizeText(
                  ' - Correct',
                  maxLines: 1,
                  minFontSize: 8,
                  style: TextStyle(
                      fontFamily: AppFonts.poppinsRegular,
                      color: AppColors.kWhite,
                      fontSize: 12),
                ).flexible,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FlashCardSummaryChapterCard extends StatelessWidget {
  const FlashCardSummaryChapterCard({
    super.key,
    required this.chapter,
    required this.cardColor,
  });
  final ChapterModel chapter;
  final Color? cardColor;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              chapter.name,
              maxLines: 2,
              minFontSize: 10,
              style: const TextStyle(
                  fontSize: 16,
                  fontFamily: AppFonts.poppinsBold,
                  color: AppColors.kWhite),
            ),
            SizedBox(
              height: Get.height * 0.01,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        width: Get.width * 0.02,
                      ),
                      Text.rich(TextSpan(
                          text:
                              '${snapshot.hasData ? snapshot.data.docs.length : 0}',
                          style: const TextStyle(
                              fontFamily: AppFonts.poppinsBold,
                              color: AppColors.kWhite,
                              fontSize: 14),
                          children: [
                            TextSpan(
                              text:
                                  '/${chapter.totalQuestions == 0 ? 1 : chapter.totalQuestions}',
                              style: const TextStyle(
                                  fontFamily: AppFonts.poppinsMedium,
                                  color: AppColors.kWhite,
                                  fontSize: 13),
                            )
                          ])),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class MockExamSummaryChapterCard extends StatelessWidget {
  const MockExamSummaryChapterCard({
    super.key,
    required this.chapter,
    required this.cardColor,
  });
  final MockChapterModel chapter;
  final Color? cardColor;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              chapter.name,
              maxLines: 2,
              minFontSize: 10,
              style: const TextStyle(
                  fontSize: 16,
                  fontFamily: AppFonts.poppinsBold,
                  color: AppColors.kWhite),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Row(
              children: [
                Text(
                  '${chapter.participants.where((e) => e.uid == authController.getCurrentUser()).isNotEmpty ? chapter.participants.where((e) => e.uid == authController.getCurrentUser()).first.score.toStringAsFixed(0) : 0} %',
                  style: const TextStyle(
                    fontFamily: AppFonts.poppinsBold,
                    color: AppColors.kWhite,
                  ),
                ),
                const AutoSizeText(
                  ' - Score',
                  maxLines: 1,
                  minFontSize: 8,
                  style: TextStyle(
                      fontFamily: AppFonts.poppinsRegular,
                      color: AppColors.kWhite,
                      fontSize: 12),
                ).flexible,
              ],
            ),
            Row(
              children: [
                Text(
                  '${chapter.participants.where((e) => e.uid == authController.getCurrentUser()).isNotEmpty ? chapter.participants.where((e) => e.uid == authController.getCurrentUser()).first.time.toStringAsFixed(1) : 0} s',
                  style: const TextStyle(
                    fontFamily: AppFonts.poppinsBold,
                    color: AppColors.kWhite,
                  ),
                ),
                const AutoSizeText(
                  ' - Time per Question',
                  maxLines: 1,
                  minFontSize: 8,
                  style: TextStyle(
                      fontFamily: AppFonts.poppinsRegular,
                      color: AppColors.kWhite,
                      fontSize: 12),
                ).flexible,
              ],
            ),
            Row(
              children: [
                Text(
                  chapter.participants
                          .where(
                              (e) => e.uid == authController.getCurrentUser())
                          .isNotEmpty
                      ? chapter.participants
                          .where(
                              (e) => e.uid == authController.getCurrentUser())
                          .first
                          .totalTime
                      : "00:00",
                  style: const TextStyle(
                    fontFamily: AppFonts.poppinsBold,
                    color: AppColors.kWhite,
                  ),
                ),
                const AutoSizeText(
                  ' - Total Time',
                  maxLines: 1,
                  minFontSize: 8,
                  style: TextStyle(
                      fontFamily: AppFonts.poppinsRegular,
                      color: AppColors.kWhite,
                      fontSize: 12),
                ).flexible,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTitleCircularProgressCard extends StatelessWidget {
  const CustomTitleCircularProgressCard({
    super.key,
    required this.title,
    required this.totalQuestion,
    required this.attemptedQuestion,
    required this.score,
  });
  final String title;
  final int totalQuestion;
  final int attemptedQuestion;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: themeController.isDarkMode
          ? DarkModeColors.kBodyColor
          : AppColors.kWhite,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: AppColors.kPrimary)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontFamily: AppFonts.poppinsBold,
                  fontSize: 18,
                  color: themeController.isDarkMode
                      ? DarkModeColors.kWhite
                      : AppColors.kPrimary),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircularStepProgressIndicator(
                  height: 120,
                  width: 120,
                  selectedColor: AppColors.kPrimary,
                  unselectedColor: const Color.fromARGB(255, 199, 224, 211),
                  roundedCap: (index, _) => true,
                  padding: 0,
                  totalSteps: totalQuestion,
                  currentStep: attemptedQuestion,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$attemptedQuestion / $totalQuestion',
                        style: const TextStyle(
                            fontFamily: AppFonts.poppinsBold,
                            fontSize: 20,
                            color: AppColors.kPrimary),
                      ),
                      const Text(
                        'Questions',
                        style: TextStyle(
                            fontFamily: AppFonts.poppinsMedium,
                            fontSize: 16,
                            color: AppColors.kPrimary),
                      )
                    ],
                  )),
                ),
                CircularStepProgressIndicator(
                  height: 120,
                  width: 120,
                  selectedColor: AppColors.kPrimary,
                  unselectedColor: const Color.fromARGB(255, 199, 224, 211),
                  roundedCap: (index, _) => true,
                  padding: 0,
                  totalSteps: 100,
                  currentStep: score,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$score%',
                        style: const TextStyle(
                            fontFamily: AppFonts.poppinsBold,
                            fontSize: 20,
                            color: AppColors.kPrimary),
                      ),
                      const Text(
                        'Score',
                        style: TextStyle(
                            fontFamily: AppFonts.poppinsMedium,
                            fontSize: 16,
                            color: AppColors.kPrimary),
                      )
                    ],
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
