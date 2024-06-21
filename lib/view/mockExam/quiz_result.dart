import 'package:flutter/material.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:get/get.dart';
import '../../models/mock_chapter.dart';
import '../../models/mock_exam_question.dart';
import '../../res/colors/app_colors.dart';
import '../../res/components/loading.dart';
import '../../res/controller/controller_instances.dart';
import '../../res/fonts/app_fonts.dart';

class MockExamResultScreen extends StatelessWidget {
  const MockExamResultScreen(
      {super.key,
      required this.chapter,
      required this.score,
      required this.time,
      required this.totalQuestion});

  final MockChapterModel chapter;
  final double score;
  final int totalQuestion;
  final int time;

  formattedTime({required int time}) {
    int sec = time % 60;
    int min = (time / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? DarkModeColors.kBodyColor
          : AppColors.kWhite,
      appBar: AppBar(
        backgroundColor: themeController.isDarkMode
            ? DarkModeColors.kBodyColor
            : AppColors.kWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.cancel,
            color: AppColors.kRed,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "${chapter.name} Result",
          style: TextStyle(
            fontFamily: AppFonts.poppinsBold,
            color: themeController.isDarkMode
                ? DarkModeColors.kWhite
                : AppColors.kBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          statsWidget("Score", "${score.toStringAsFixed(1)} %",
              score < 33 ? AppColors.kRed : AppColors.kGreen),
          statsWidget(
              "Total Time", formattedTime(time: time), AppColors.kGreen),
          statsWidget("Average Time Per Question", "${time / totalQuestion} S",
              AppColors.kGreen),
          StreamBuilder<dynamic>(
              stream: firestore
                  .collection("mockExamQuestions")
                  .where("chapterId", isEqualTo: chapter.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<MockExamQuestionModel> questions = snapshot.data!.docs
                      .map<MockExamQuestionModel>(
                          (e) => MockExamQuestionModel.fromJson(e))
                      .toList();
                  // questions = questions.take(10).toList();
                  return Column(children: [
                    ...List.generate(
                        questions.length,
                        (index) => questionWidget(
                            questions[index], index + 1, context))
                  ]);
                } else {
                  return const Loading();
                }
              }),
        ],
      ),
    );
  }

  Widget statsWidget(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            width: 0.5,
            color: themeController.isDarkMode
                ? DarkModeColors.kWhite
                : AppColors.kBlack),
        color: AppColors.kPrimary.withOpacity(0.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: themeController.isDarkMode
                    ? DarkModeColors.kWhite
                    : AppColors.kBlack,
                fontFamily: AppFonts.poppinsRegular),
          ).flexible,
          Text(
            value,
            style: TextStyle(
                color: color, fontSize: 18, fontFamily: AppFonts.poppinsBold),
          ).paddingL(10),
        ],
      ),
    ).paddingSymmetric(horizontal: 15, vertical: 5);
  }

  Widget questionWidget(MockExamQuestionModel question, int number, context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: Get.width,
      decoration: BoxDecoration(
          color: themeController.isDarkMode
              ? DarkModeColors.kBodyColor
              : AppColors.kWhite,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: question.attempted
                          .where((element) =>
                              element.uid == authController.getCurrentUser())
                          .first
                          .selected ==
                      question.correct
                  ? AppColors.kGreen
                  : AppColors.kRed,
              width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number) ${question.question}",
            style: TextStyle(
                color: themeController.isDarkMode
                    ? DarkModeColors.kWhite
                    : AppColors.kBlack,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.poppinsBold,
                fontSize: 15),
          ),
          8.heightBox,
          ...List.generate(
            4,
            (index) => Text.rich(TextSpan(
                text: index == 0
                    ? "A) "
                    : index == 1
                        ? "B) "
                        : index == 2
                            ? "C) "
                            : "D) ",
                style: TextStyle(
                    fontFamily: AppFonts.poppinsBold,
                    color: themeController.isDarkMode
                        ? DarkModeColors.kWhite
                        : AppColors.kBlack),
                children: [
                  TextSpan(
                      text: question.choices[index],
                      style: TextStyle(
                          fontFamily: AppFonts.poppinsRegular,
                          fontSize: 14,
                          color: question.attempted
                                      .where((element) =>
                                          element.uid ==
                                          authController.getCurrentUser())
                                      .first
                                      .selected ==
                                  question.choices[index]
                              ? Ex.blue400
                              : themeController.isDarkMode
                                  ? DarkModeColors.kWhite
                                  : AppColors.kBlack))
                ])),
          ),
          10.heightBox,
          Text.rich(TextSpan(
              text: "Correct Answer:  ",
              style: TextStyle(
                  fontFamily: AppFonts.poppinsBold,
                  color: themeController.isDarkMode
                      ? DarkModeColors.kWhite
                      : AppColors.kBlack),
              children: [
                TextSpan(
                    text: question.correct,
                    style: const TextStyle(
                        fontFamily: AppFonts.poppinsBold,
                        fontSize: 14,
                        color: AppColors.kGreen))
              ])),
          Text.rich(TextSpan(
              text: "Explanation:  ",
              style: TextStyle(
                  fontFamily: AppFonts.poppinsBold,
                  color: themeController.isDarkMode
                      ? DarkModeColors.kWhite
                      : AppColors.kBlack),
              children: [
                TextSpan(
                    text: question.explanation,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppinsMedium,
                      fontSize: 14,
                    ))
              ]))
        ],
      ),
    ).paddingSymmetric(vertical: 10, horizontal: 15);
  }
}
