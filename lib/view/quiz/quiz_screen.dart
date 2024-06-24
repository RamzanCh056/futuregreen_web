import 'package:flutter/material.dart';
import 'package:future_green_world/models/chapter.dart';
import 'package:future_green_world/models/question.dart';
import 'package:future_green_world/controllers/timer_controller.dart';
import 'package:future_green_world/controllers/quiz_controller.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/custom_safe_area.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/components/loading.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:future_green_world/view_model/controller/quiz/quiz_view_model_controller.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../main.dart';
import '../../res/components/custom_pop_up.dart';
import '../../res/components/custom_snackbar.dart';
import '../../res/controller/controller_instances.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.chapter});
  final ChapterModel chapter;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final timerController = Get.put(TimerController());
  final quizVMController = Get.put(QuizViewModel());
  final quizController = Get.put(QuizController());
  var quizStarted = false.obs;
  var correctQuestions = 0.obs;
  var attempted = 0.obs;
  var questionsCount = 0.obs;
  List<QuestionModel> attemptedQuestions = [];

  @override
  void initState() {
    questionsCount.value = sharedPreferences!.getInt("questionsCount") ?? 50;
    timerController.stopWatchTimer.onStartTimer();
    super.initState();
  }

  @override
  void dispose() {
    timerController.stopWatchTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: WillPopScope(
      onWillPop: () async {
        showCustomPopUp(
            context,
            'End Exam',
            'Are your sure you want to end Exam?',
            "Continue",
            AppColors.kGreen,
            "End Exam",
            AppColors.kRed, () {
          Get.close(2);
          // Get.offAll(() => const QuizzesHomeScreen());
        });
        return false;
      },
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
              onPressed: () {
                showCustomPopUp(
                    context,
                    'End Exam',
                    'Are your sure you want to end Exam?',
                    "Continue",
                    AppColors.kGreen,
                    "End Exam",
                    AppColors.kRed, () {
                  Get.close(2);
                });
              },
              icon: const Icon(
                Icons.cancel,
                color: AppColors.kRed,
                size: 35,
              )),
          title: Text(
            widget.chapter.name,
            style: TextStyle(
                fontFamily: AppFonts.poppinsBold,
                color: themeController.isDarkMode
                    ? DarkModeColors.kWhite
                    : AppColors.kBlack),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                width: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2),
                  color: AppColors.kPrimary,
                ),
                child: StreamBuilder<int>(
                    stream: timerController.stopWatchTimer.rawTime,
                    initialData: timerController.stopWatchTimer.rawTime.value,
                    builder: (context, snapshot) {
                      final value = snapshot.data!;
                      final displayTime = StopWatchTimer.getDisplayTime(value,
                          hours: true, milliSecond: false);
                      return Center(
                        child: Text(
                          displayTime,
                          style: const TextStyle(
                              color: AppColors.kWhite,
                              fontFamily: AppFonts.poppinsMedium),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
        body: StreamBuilder<dynamic>(
            stream: firestore
                .collection("questions")
                .where("chapterId", isEqualTo: widget.chapter.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QuestionModel> questions = snapshot.data.docs
                    .map<QuestionModel>((e) => QuestionModel.fromJson(e))
                    .toList();

                var visibility =
                    sharedPreferences!.getString("questionsVisibility") == null
                        ? "Show Unsolved Only"
                        : sharedPreferences!.getString("questionsVisibility")!;
                if (quizStarted.value) {
                  questions.removeWhere((value) => attemptedQuestions
                      .where((element) => value.id == element.id)
                      .isNotEmpty);
                }

                return Obx(() {
                  if (visibility == "Show Unsolved Only" &&
                      quizController.questionNo.value + 1 != questions.length &&
                      !quizStarted.value) {
                    attemptedQuestions = questions
                        .where((element) => element.attempted
                            .where(
                                (e) => e.uid == authController.getCurrentUser())
                            .isNotEmpty)
                        .toList();
                    questions
                        .removeWhere((e) => attemptedQuestions.contains(e));
                    quizStarted.value = true;
                  } else if (visibility == "Show All" && !quizStarted.value) {
                    attempted.value = questions
                        .where((element) => element.attempted
                            .where(
                                (e) => e.uid == authController.getCurrentUser())
                            .isNotEmpty)
                        .toList()
                        .length;
                    var tempQuesList = questions
                        .where((element) => element.attempted
                            .where(
                                (e) => e.uid == authController.getCurrentUser())
                            .isNotEmpty)
                        .toList();

                    for (var ques in tempQuesList) {
                      if (ques.choices.indexOf(ques.correct) ==
                          ques.attempted
                              .firstWhere((element) =>
                                  element.uid ==
                                  authController.getCurrentUser())
                              .selectedIndex) {
                        correctQuestions.value++;
                      }
                    }
                    quizStarted.value = true;
                  }

                  if (questions.length > questionsCount.value) {
                    questions = questions.take(questionsCount.value).toList();
                  }

                  quizController.answered
                      .value = questions[quizController.questionNo.value]
                          .attempted
                          .isNotEmpty
                      ? questions[quizController.questionNo.value]
                          .attempted
                          .where((element) =>
                              element.uid == authController.getCurrentUser())
                          .toList()
                          .isNotEmpty
                      : false;

                  quizController.selectedIndex.value =
                      questions[quizController.questionNo.value]
                              .attempted
                              .isNotEmpty
                          ? questions[quizController.questionNo.value]
                                  .attempted
                                  .where((element) =>
                                      element.uid ==
                                      authController.getCurrentUser())
                                  .toList()
                                  .isNotEmpty
                              ? questions[quizController.questionNo.value]
                                  .attempted
                                  .where((element) =>
                                      element.uid ==
                                      authController.getCurrentUser())
                                  .toList()
                                  .first
                                  .selectedIndex
                              : 99
                          : 99;

                  quizController.correctAnswer =
                      questions[quizController.questionNo.value].correct.obs;

                  quizController.correctIndex.value =
                      questions[quizController.questionNo.value]
                          .choices
                          .indexOf(quizController.correctAnswer.value);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode
                                ? DarkModeColors.kWhite
                                : AppColors.kBlack,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child:
                                //Progress Bar
                                StepProgressIndicator(
                              size: 8,
                              padding: 0,
                              totalSteps: questions.length,
                              currentStep: quizController.questionNo.value + 1,
                              roundedEdges: const Radius.circular(10),
                              selectedColor: AppColors.kYellowColor,
                              unselectedColor: themeController.isDarkMode
                                  ? DarkModeColors.kAppBarColor
                                  : AppColors.kWhite,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: TextStyle(
                                fontFamily: AppFonts.poppinsMedium,
                                color: themeController.isDarkMode
                                    ? DarkModeColors.kWhite
                                    : AppColors.kBlack,
                              ),
                            ),
                            //Attempted & Total Questions
                            Text(
                              '${quizController.questionNo.value + 1}/${questions.length} Questions',
                              style: TextStyle(
                                fontFamily: AppFonts.poppinsMedium,
                                color: themeController.isDarkMode
                                    ? DarkModeColors.kWhite
                                    : AppColors.kBlack,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Performance',
                              style: TextStyle(
                                fontFamily: AppFonts.poppinsMedium,
                                color: themeController.isDarkMode
                                    ? DarkModeColors.kWhite
                                    : AppColors.kBlack,
                              ),
                            ),
                            //Attempted & Total Questions
                            Text(
                              '${((correctQuestions.value / (attempted.value == 0 ? 1 : attempted.value)) * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: AppFonts.poppinsBold,
                                color: AppColors.kPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Divider(
                          thickness: 2,
                          color: themeController.isDarkMode
                              ? DarkModeColors.kWhite
                              : AppColors.kBlack,
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        SwipeTo(
                          iconOnLeftSwipe: Icons.arrow_forward,
                          iconOnRightSwipe: Icons.arrow_back,
                          iconColor: themeController.isDarkMode
                              ? DarkModeColors.kWhite
                              : AppColors.kBlack,
                          onLeftSwipe: (details) {
                            if (quizController.answered.value) {
                              if (quizController.questionNo.value + 1 <
                                  questions.length) {
                                quizController.clearController();
                                quizController.questionNo.value++;
                              } else {
                                showErrorSnackbar("End of Quiz!", context);
                              }
                            } else {
                              showErrorSnackbar(
                                  "Please attempt this question to go to next!",
                                  context);
                            }
                          },
                          onRightSwipe: (details) {
                            if (quizController.questionNo.value > 0) {
                              quizController.clearController();
                              quizController.questionNo.value--;
                            } else {
                              showErrorSnackbar(
                                  "This is the first Question", context);
                            }
                          },
                          child: Container(
                            color: AppColors.kTransparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Question Number
                                      Text(
                                        '${quizController.questionNo.value + 1}. ',
                                        style: TextStyle(
                                            fontFamily: AppFonts.poppinsBold,
                                            color: themeController.isDarkMode
                                                ? DarkModeColors.kWhite
                                                : AppColors.kBlack),
                                      ),
                                      Flexible(
                                        child:
                                            //Question
                                            Text(
                                                questions[quizController
                                                        .questionNo.value]
                                                    .question,
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.poppinsBold,
                                                    color: themeController
                                                            .isDarkMode
                                                        ? DarkModeColors.kWhite
                                                        : AppColors.kBlack)),
                                      )
                                    ],
                                  );
                                }),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                //Answer List
                                ...List.generate(
                                  questions[quizController.questionNo.value]
                                      .choices
                                      .length,
                                  (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (!quizController.answered.value) {
                                            if (quizController.skippedIndex
                                                .contains(quizController
                                                    .questionNo.value)) {
                                              quizController.skippedIndex
                                                  .remove(quizController
                                                      .questionNo.value);
                                            }
                                            if (questions[quizController
                                                        .questionNo.value]
                                                    .choices[index] ==
                                                questions[quizController
                                                        .questionNo.value]
                                                    .correct) {
                                              correctQuestions.value++;
                                            }
                                            attempted.value++;
                                            db.questionAttempted(
                                                questions[quizController
                                                        .questionNo.value]
                                                    .id,
                                                index,
                                                index ==
                                                    quizController
                                                        .correctIndex.value,
                                                widget.chapter.id,
                                                context);
                                          }
                                        },
                                        child: Obx(() {
                                          return Card(
                                            color: !quizController
                                                    .answered.value
                                                ? themeController.isDarkMode
                                                    ? DarkModeColors
                                                        .kAppBarColor
                                                    : AppColors.kWhite
                                                : quizController.selectedIndex
                                                            .value !=
                                                        index
                                                    ? themeController.isDarkMode
                                                        ? DarkModeColors
                                                            .kAppBarColor
                                                        : AppColors.kWhite
                                                    : quizController
                                                                .selectedIndex
                                                                .value ==
                                                            quizController
                                                                .correctIndex
                                                                .value
                                                        ? AppColors.kGreen
                                                            .withOpacity(0.3)
                                                        : AppColors.kRed
                                                            .withOpacity(0.3),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                side: BorderSide(
                                                    width: 1.5,
                                                    color: themeController
                                                            .isDarkMode
                                                        ? DarkModeColors.kWhite
                                                        : AppColors.kBlack)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Row(
                                                    children: [
                                                      Card(
                                                        color: !quizController
                                                                .answered.value
                                                            ? AppColors
                                                                .kTransparent
                                                            : quizController
                                                                        .selectedIndex
                                                                        .value !=
                                                                    index
                                                                ? themeController
                                                                        .isDarkMode
                                                                    ? DarkModeColors
                                                                        .kAppBarColor
                                                                    : AppColors
                                                                        .kWhite
                                                                : quizController
                                                                            .selectedIndex
                                                                            .value ==
                                                                        quizController
                                                                            .correctIndex
                                                                            .value
                                                                    ? AppColors
                                                                        .kGreen
                                                                        .withOpacity(
                                                                            0.3)
                                                                    : AppColors
                                                                        .kRed
                                                                        .withOpacity(
                                                                            0.3),
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            side: BorderSide(
                                                                width: 1.5,
                                                                color: themeController
                                                                        .isDarkMode
                                                                    ? DarkModeColors
                                                                        .kWhite
                                                                    : AppColors
                                                                        .kBlack)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 8),
                                                          child: Text(
                                                            index == 0
                                                                ? 'A'
                                                                : index == 1
                                                                    ? 'B'
                                                                    : index == 2
                                                                        ? 'C'
                                                                        : 'D',
                                                            style: TextStyle(
                                                                fontFamily: AppFonts
                                                                    .poppinsBold,
                                                                color: quizController
                                                                            .selectedIndex
                                                                            .value ==
                                                                        index
                                                                    ? AppColors
                                                                        .kWhite
                                                                    : themeController
                                                                            .isDarkMode
                                                                        ? DarkModeColors
                                                                            .kWhite
                                                                        : AppColors
                                                                            .kBlack),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          questions[
                                                                  quizController
                                                                      .questionNo
                                                                      .value]
                                                              .choices[index],
                                                          style: TextStyle(
                                                              color: themeController
                                                                      .isDarkMode
                                                                  ? DarkModeColors
                                                                      .kWhite
                                                                  : AppColors
                                                                      .kBlack,
                                                              fontFamily: AppFonts
                                                                  .poppinsMedium),
                                                        ),
                                                      ),
                                                      !quizController
                                                              .answered.value
                                                          ? const SizedBox()
                                                          : quizController
                                                                      .selectedIndex
                                                                      .value !=
                                                                  index
                                                              ? const SizedBox()
                                                              : quizController
                                                                          .selectedIndex
                                                                          .value ==
                                                                      quizController
                                                                          .correctIndex
                                                                          .value
                                                                  ? const CircleAvatar(
                                                                      backgroundColor:
                                                                          AppColors
                                                                              .kGreen,
                                                                      radius:
                                                                          10,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .check,
                                                                        size:
                                                                            14,
                                                                        color: AppColors
                                                                            .kWhite,
                                                                      ),
                                                                    )
                                                                  : const CircleAvatar(
                                                                      backgroundColor:
                                                                          AppColors
                                                                              .kRed,
                                                                      radius:
                                                                          10,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .close,
                                                                        size:
                                                                            14,
                                                                        color: AppColors
                                                                            .kWhite,
                                                                      ),
                                                                    )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    );
                                  },
                                ),
                                (Get.height * 0.01).heightBox,
                                Obx(() {
                                  return Visibility(
                                    visible: quizController.answered.value,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(TextSpan(
                                            text: "Correct Answer:  ",
                                            style: TextStyle(
                                                fontFamily:
                                                    AppFonts.poppinsBold,
                                                color:
                                                    themeController.isDarkMode
                                                        ? DarkModeColors.kWhite
                                                        : AppColors.kBlack),
                                            children: [
                                              TextSpan(
                                                  text: quizController
                                                              .correctIndex
                                                              .value ==
                                                          0
                                                      ? 'A'
                                                      : quizController
                                                                  .correctIndex
                                                                  .value ==
                                                              1
                                                          ? 'B'
                                                          : quizController
                                                                      .correctIndex
                                                                      .value ==
                                                                  2
                                                              ? 'C'
                                                              : 'D',
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          AppFonts.poppinsBold,
                                                      fontSize: 22,
                                                      color: AppColors.kGreen))
                                            ])),
                                        2.heightBox,
                                        Text.rich(TextSpan(
                                            text: "Explanation: ",
                                            style: TextStyle(
                                              color: themeController.isDarkMode
                                                  ? DarkModeColors.kWhite
                                                  : AppColors.kBlack,
                                              fontFamily: AppFonts.poppinsBold,
                                            ),
                                            children: [
                                              TextSpan(
                                                  text: questions[quizController
                                                          .questionNo.value]
                                                      .explanation,
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        AppFonts.poppinsRegular,
                                                  ))
                                            ])),
                                      ],
                                    ),
                                  );
                                }),
                                (Get.height * 0.03).heightBox,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Previous Button
                                    Visibility(
                                      visible:
                                          quizController.questionNo.value > 0,
                                      child: Flexible(
                                        child: SizedBox(
                                          height: 60,
                                          width: Get.width,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.kPrimary,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                            onPressed: () {
                                              quizController.clearController();
                                              quizController.questionNo.value--;
                                            },
                                            icon: const Icon(
                                              Icons.arrow_back,
                                              color: AppColors.kWhite,
                                              size: 18,
                                            ),
                                            label: const Text(
                                              "Previous",
                                              style: TextStyle(
                                                  color: AppColors.kWhite,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      AppFonts.poppinsRegular),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: quizController.answered.value &&
                                          quizController.questionNo.value > 0 &&
                                          quizController.questionNo.value + 1 <
                                              questions.length,
                                      child: SizedBox(
                                        width: Get.height * 0.01,
                                      ),
                                    ),
                                    Visibility(
                                      visible: !quizController.answered.value &&
                                          quizController.questionNo.value + 1 <
                                              questions.length,
                                      child: SizedBox(
                                        height: 60,
                                        width: 80,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.kYellowColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                          onPressed: () {
                                            quizController.skippedIndex.add(
                                                quizController
                                                    .questionNo.value);
                                            quizController.skippedIndex.value =
                                                quizController.skippedIndex
                                                    .toSet()
                                                    .toList();
                                            quizController.clearController();
                                            quizController.questionNo.value++;
                                          },
                                          child: const Text(
                                            "Skip",
                                            style: TextStyle(
                                                color: AppColors.kWhite,
                                                fontSize: 15,
                                                fontFamily:
                                                    AppFonts.poppinsRegular),
                                          ),
                                        ),
                                      ).paddingHrz(Get.height * 0.01),
                                    ),
                                    //Next Button
                                    Visibility(
                                      visible:
                                          quizController.questionNo.value + 1 <
                                              questions.length,
                                      child: Flexible(
                                        child: SizedBox(
                                          height: 60,
                                          width: Get.width,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.kPrimary,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                            onPressed: () {
                                              if (quizController
                                                  .answered.value) {
                                                quizController
                                                    .clearController();
                                                quizController
                                                    .questionNo.value++;
                                              } else {
                                                showErrorSnackbar(
                                                    "Please attempt this question to go to next!",
                                                    context);
                                              }
                                            },
                                            icon: const Text(
                                              "Next",
                                              style: TextStyle(
                                                  color: AppColors.kWhite,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      AppFonts.poppinsRegular),
                                            ),
                                            label: const Icon(
                                              Icons.arrow_forward,
                                              color: AppColors.kWhite,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //End
                                    Visibility(
                                      visible:
                                          quizController.questionNo.value + 1 ==
                                              questions.length,
                                      child: SizedBox(
                                        height: 60,
                                        width: Get.width,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.kRed,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                          onPressed: () {
                                            Get.close(1);
                                          },
                                          icon: const Text(
                                            "End",
                                            style: TextStyle(
                                                color: AppColors.kWhite,
                                                fontSize: 14,
                                                fontFamily:
                                                    AppFonts.poppinsRegular),
                                          ),
                                          label: const Icon(
                                            Icons.done,
                                            color: AppColors.kWhite,
                                            size: 18,
                                          ),
                                        ),
                                      ).paddingHrz(Get.height * 0.01).flexible,
                                    ),
                                  ],
                                ),
                                (Get.height * 0.03).heightBox,
                                Visibility(
                                  visible:
                                      quizController.skippedIndex.isNotEmpty,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Skipped Questions",
                                          style: TextStyle(
                                              fontFamily: AppFonts.poppinsBold,
                                              color: themeController.isDarkMode
                                                  ? DarkModeColors.kWhite
                                                  : AppColors.kBlack,
                                              fontSize: 20)),
                                      10.heightBox,
                                      ...List.generate(
                                          quizController.skippedIndex.length,
                                          (index) => SizedBox(
                                                height: 60,
                                                width: Get.width,
                                                child: ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.kYellowColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                  ),
                                                  onPressed: () {
                                                    quizController
                                                        .clearController();
                                                    quizController
                                                            .questionNo.value =
                                                        quizController
                                                                .skippedIndex[
                                                            index];
                                                  },
                                                  icon: const Icon(
                                                    Icons.fast_forward,
                                                    color: AppColors.kWhite,
                                                    size: 18,
                                                  ),
                                                  label: Text(
                                                    "Question ${quizController.skippedIndex[index] + 1}",
                                                    style: const TextStyle(
                                                        color: AppColors.kWhite,
                                                        fontSize: 14,
                                                        fontFamily: AppFonts
                                                            .poppinsRegular),
                                                  ),
                                                ),
                                              ).paddingB(10))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                      ],
                    ),
                  );
                });
              } else {
                return const Loading(text: "Preparing Exam")
                    .center
                    .paddingT(15);
              }
            }),
      ),
    ));
  }
}
