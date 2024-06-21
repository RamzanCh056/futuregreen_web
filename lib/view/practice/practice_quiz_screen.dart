import 'package:flutter/material.dart';
import 'package:future_green_world/models/exam.dart';
import 'package:future_green_world/main.dart';
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
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../res/components/custom_pop_up.dart';
import '../../res/components/custom_snackbar.dart';
import '../../res/controller/controller_instances.dart';

class PracticeQuizScreen extends StatefulWidget {
  const PracticeQuizScreen({super.key, required this.exam});
  final ExamModel exam;

  @override
  State<PracticeQuizScreen> createState() => _PracticeQuizScreenState();
}

class _PracticeQuizScreenState extends State<PracticeQuizScreen> {
  final timerController = Get.put(TimerController());
  final quizVMController = Get.put(QuizViewModel());
  final quizController = Get.put(QuizController());

  var shuffleQuestions = true;
  var correctQuestions = 0.obs;
  var attemptedQuestions = 0.obs;

  @override
  void initState() {
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
            widget.exam.allowedUsers.contains(authController.getCurrentUser())
                ? 'End Practice'
                : "End Trial Exam",
            widget.exam.allowedUsers.contains(authController.getCurrentUser())
                ? 'Are your sure you want to end Practice?'
                : 'Are your sure you want to end trial exam?',
            "Continue",
            AppColors.kGreen,
            widget.exam.allowedUsers.contains(authController.getCurrentUser())
                ? "End Practice"
                : "End Trial Exam",
            AppColors.kRed, () {
          if (attemptedQuestions.value > 0) {
            sharedPreferences!.setInt(
                widget.exam.id,
                ((correctQuestions.value / attemptedQuestions.value) * 100)
                    .toInt());
            sharedPreferences!
                .setInt("${widget.exam.id}Attempted", attemptedQuestions.value);
          }
          db.updateTrial(widget.exam.id);
          Get.close(3);
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
                    widget.exam.allowedUsers
                            .contains(authController.getCurrentUser())
                        ? 'End Practice'
                        : "End Trial Exam",
                    widget.exam.allowedUsers
                            .contains(authController.getCurrentUser())
                        ? 'Are your sure you want to end Practice?'
                        : 'Are your sure you want to end trial exam?',
                    "Continue",
                    AppColors.kGreen,
                    widget.exam.allowedUsers
                            .contains(authController.getCurrentUser())
                        ? "End Practice"
                        : "End Trial Exam",
                    AppColors.kRed, () {
                  if (attemptedQuestions.value > 0) {
                    sharedPreferences!.setInt(
                        widget.exam.id,
                        ((correctQuestions.value / attemptedQuestions.value) *
                                100)
                            .toInt());
                    sharedPreferences!.setInt(
                        "${widget.exam.id}Attempted", attemptedQuestions.value);
                  }
                  db.updateTrial(widget.exam.id);
                  Get.close(3);
                });
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              )),
          title: Text(
            widget.exam.allowedUsers.contains(authController.getCurrentUser())
                ? "Practice Exam"
                : "Trial Exam",
            style: TextStyle(
              fontFamily: AppFonts.poppinsBold,
              color: themeController.isDarkMode
                  ? DarkModeColors.kWhite
                  : AppColors.kBlack,
            ),
          ),
          // centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xffDCEDFB),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/timer.png',
                    height: 25,
                    width: 25,
                  ),
                  const SizedBox(width: 15),
                  StreamBuilder<int>(
                      stream: timerController.stopWatchTimer.rawTime,
                      initialData: timerController.stopWatchTimer.rawTime.value,
                      builder: (context, snapshot) {
                        final value = snapshot.data!;
                        final displayTime = StopWatchTimer.getDisplayTime(value,
                            hours: true, milliSecond: false);
                        return Text(
                          displayTime,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff0C4370)),
                        );
                      }),
                ],
              ),
            )
          ],
        ),
        body: StreamBuilder<dynamic>(
          stream: firestore
              .collection("questions")
              .where("examId", isEqualTo: widget.exam.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<QuestionModel> questions = snapshot.data.docs
                  .map<QuestionModel>((e) => QuestionModel.fromJson(e))
                  .toList();

              if (shuffleQuestions) {
                questions.shuffle();
                shuffleQuestions = false;
              }
              List<QuestionModel> temp = [];
              if (widget.exam.id == "exam1") {
                temp.addAll(questions
                    .where((element) => element.chapterNo == 1)
                    .take(10)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 2)
                    .take(7)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 3)
                    .take(10)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 4)
                    .take(7)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 5)
                    .take(8)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 6)
                    .take(9)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 7)
                    .take(27)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 8)
                    .take(14)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 9)
                    .take(8)
                    .toList());
                questions = temp;
              } else {
                temp.addAll(questions
                    .where((element) => element.chapterNo == 1)
                    .take(7)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 2)
                    .take(12)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 3)
                    .take(10)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 4)
                    .take(10)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 5)
                    .take(10)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 6)
                    .take(14)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 7)
                    .take(10)
                    .toList());
                temp.addAll(questions
                    .where((element) => element.chapterNo == 8)
                    .take(7)
                    .toList());
                questions = temp;
              }
              if (!widget.exam.allowedUsers
                  .contains(authController.getCurrentUser())) {
                questions = questions.take(5).toList();
              }
              return Obx(() {
                quizController.correctAnswer =
                    questions[quizController.questionNo.value].correct.obs;

                quizController.correctIndex.value =
                    questions[quizController.questionNo.value]
                        .choices
                        .indexOf(quizController.correctAnswer.value);

                bool isCorrectSelected(int index) =>
                    (quizController.selectedChoice.value ==
                        quizController.correctAnswer.value);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearProgressIndicator(
                                    value: (quizController.questionNo.value +
                                        1 / questions.length),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      AppColors.darkGreenColor,
                                    ),
                                    backgroundColor: AppColors.lightGreyColor,
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Questions ${quizController.questionNo.value + 1}/${questions.length}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
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
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          color: AppColors.kTransparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Question Number
                                  Obx(() {
                                    return Text(
                                      '${quizController.questionNo.value + 1}. ',
                                      style: TextStyle(
                                          fontFamily: AppFonts.poppinsBold,
                                          color: themeController.isDarkMode
                                              ? DarkModeColors.kWhite
                                              : AppColors.kBlack),
                                    );
                                  }),
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
                                                color:
                                                    themeController.isDarkMode
                                                        ? DarkModeColors.kWhite
                                                        : AppColors.kBlack)),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                              //Answer List
                              ...List.generate(
                                questions[quizController.questionNo.value]
                                    .choices
                                    .length,
                                (index) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child:
                                        quizController
                                                .selectedChoice.value.isEmpty
                                            ? GestureDetector(
                                                onTap: () {
                                                  if (!quizController
                                                      .answered.value) {
                                                    if (quizController
                                                        .skippedIndex
                                                        .contains(quizController
                                                            .questionNo
                                                            .value)) {
                                                      quizController
                                                          .skippedIndex
                                                          .remove(quizController
                                                              .questionNo
                                                              .value);
                                                    }
                                                    quizController
                                                        .selectedChoice
                                                        .value = questions[
                                                            quizController
                                                                .questionNo
                                                                .value]
                                                        .choices[index];
                                                    if (questions[quizController
                                                                .questionNo
                                                                .value]
                                                            .choices[index] ==
                                                        questions[quizController
                                                                .questionNo
                                                                .value]
                                                            .correct) {
                                                      correctQuestions.value++;
                                                      quizController.isCorrect
                                                          .value = true;
                                                    }
                                                    attemptedQuestions.value++;
                                                    quizController.selectedIndex
                                                        .value = index;
                                                    quizController
                                                        .answered.value = true;
                                                  }
                                                },
                                                child: Obx(() {
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                    decoration: BoxDecoration(
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            offset:
                                                                Offset(0, 3),
                                                            blurRadius: 1,
                                                            spreadRadius: 2,
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        border: Border.all(
                                                          color: quizController
                                                                      .selectedIndex
                                                                      .value !=
                                                                  index
                                                              ? AppColors
                                                                  .greyColor
                                                                  .withOpacity(
                                                                      0.4)
                                                              : isCorrectSelected(
                                                                      index)
                                                                  ? AppColors
                                                                      .greenColor
                                                                  : AppColors
                                                                      .kRed,
                                                        ),
                                                        color: quizController
                                                                .selectedChoice
                                                                .value
                                                                .isEmpty
                                                            ? themeController
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .greyColor
                                                                    .withOpacity(
                                                                        0.1)
                                                                : AppColors
                                                                    .kWhite
                                                            : quizController
                                                                        .selectedIndex
                                                                        .value !=
                                                                    index
                                                                ? themeController
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .greyColor
                                                                        .withOpacity(
                                                                            0.1)
                                                                    : AppColors
                                                                        .kWhite
                                                                : isCorrectSelected(
                                                                        index)
                                                                    ? const Color(
                                                                        0xffE6FBEB)
                                                                    : const Color(
                                                                        0xffFFEBEB)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 10),
                                                          child: Row(
                                                            children: [
                                                              Card(
                                                                color: quizController
                                                                        .selectedChoice
                                                                        .value
                                                                        .isEmpty
                                                                    ? AppColors
                                                                        .greyColor
                                                                        .withOpacity(
                                                                            0.2)
                                                                    : quizController.selectedIndex.value !=
                                                                            index
                                                                        ? themeController.isDarkMode
                                                                            ? AppColors.kWhite
                                                                            : AppColors.greyColor.withOpacity(0.3)
                                                                        : isCorrectSelected(index)
                                                                            ? AppColors.greenColor
                                                                            : AppColors.kRed,
                                                                elevation: 0,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8),
                                                                        side:
                                                                            BorderSide(
                                                                          width:
                                                                              1.5,
                                                                          color: quizController.selectedIndex.value != index
                                                                              ? themeController.isDarkMode
                                                                                  ? AppColors.kBlack
                                                                                  : AppColors.kWhite
                                                                              : isCorrectSelected(index)
                                                                                  ? AppColors.greenColor.withOpacity(0.3)
                                                                                  : AppColors.kRed.withOpacity(0.3),
                                                                        )),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          8),
                                                                  child: Text(
                                                                    index == 0
                                                                        ? 'A'
                                                                        : index ==
                                                                                1
                                                                            ? 'B'
                                                                            : index == 2
                                                                                ? 'C'
                                                                                : 'D',
                                                                    style: TextStyle(
                                                                        fontFamily: AppFonts.poppinsBold,
                                                                        color: quizController.selectedIndex.value == index
                                                                            ? AppColors.kWhite
                                                                            : themeController.isDarkMode
                                                                                ? DarkModeColors.kWhite
                                                                                : AppColors.kBlack),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  questions[quizController
                                                                          .questionNo
                                                                          .value]
                                                                      .choices[index],
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .poppinsMedium,
                                                                      color: themeController.isDarkMode
                                                                          ? DarkModeColors
                                                                              .kWhite
                                                                          : AppColors
                                                                              .kBlack),
                                                                ),
                                                              ),
                                                              quizController
                                                                      .selectedChoice
                                                                      .value
                                                                      .isEmpty
                                                                  ? const SizedBox()
                                                                  : quizController
                                                                              .selectedIndex
                                                                              .value !=
                                                                          index
                                                                      ? const SizedBox()
                                                                      : isCorrectSelected(
                                                                              index)
                                                                          ? Image.asset(
                                                                              'assets/icons/tick_mark_correct.png',
                                                                              height:
                                                                                  15,
                                                                              width:
                                                                                  15)
                                                                          : Image.asset(
                                                                              'assets/icons/tick_mark_wrong.png',
                                                                              height: 15,
                                                                              width: 15)
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              )
                                            : Container()),
                              ),
                              (Get.height * 0.01).heightBox,
                              Obx(() {
                                return Visibility(
                                  visible: quizController.answered.value,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Container(
                                      //   height: 80,
                                      //
                                      //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                      //     color: Colors.lightGreen.shade200,
                                      //
                                      //   ),
                                      //   // child: Column(children: [
                                      //   //   Container(
                                      //   //     height: 20,
                                      //   //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                      //   //       color: Colors.green
                                      //   //
                                      //   //     ),
                                      //   //     child: Text("B"),
                                      //   //   )
                                      //   // ],),
                                      // ),
                                      Text.rich(TextSpan(
                                          text: "Correct Answer:  ",
                                          style: TextStyle(
                                              fontFamily: AppFonts.poppinsBold,
                                              color: themeController.isDarkMode
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
                                                    color:
                                                        AppColors.greenColor))
                                          ])),
                                      2.heightBox,
                                      Text.rich(TextSpan(
                                          text: "Explanation: ",
                                          style: TextStyle(
                                              fontFamily: AppFonts.poppinsBold,
                                              color: themeController.isDarkMode
                                                  ? DarkModeColors.kWhite
                                                  : AppColors.kBlack),
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

                              (Get.height * 0.07).heightBox,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
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
                                            backgroundColor: AppColors.kPrimary,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
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
                                    child: GestureDetector(
                                      onTap: (){

                                          quizController.skippedIndex.add(
                                              quizController.questionNo.value);
                                          quizController.skippedIndex.value =
                                              quizController.skippedIndex
                                                  .toSet()
                                                  .toList();
                                          quizController.clearController();
                                          quizController.questionNo.value++;
                                        },

                                      child: Container(
                                        height: 60,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.greyColor.withOpacity(0.4)),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                          child: const Text(
                                            "Skip",
                                            style: TextStyle(
                                                color: AppColors.greyColor,
                                                fontSize: 15,
                                                fontFamily:
                                                    AppFonts.poppinsRegular),
                                          ),
                                        ),
                                      ).paddingHrz(Get.height * 0.01),
                                    ),
                                  ),
                                  //Next Button
                                  Visibility(
                                    visible:
                                        quizController.questionNo.value + 1 <
                                            questions.length,
                                    child: Flexible(
                                      child: SizedBox(
                                        height: 60,
                                        width:80,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.kPrimary,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                          onPressed: () {
                                            if (quizController.answered.value) {
                                              quizController.clearController();
                                              quizController.questionNo.value++;
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
                                          if (widget.exam.allowedUsers.contains(
                                              authController
                                                  .getCurrentUser())) {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      themeController.isDarkMode
                                                          ? DarkModeColors
                                                              .kAppBarColor
                                                          : AppColors.kWhite,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          16))),
                                                  title: Text(
                                                    'End Practice'
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontFamily: AppFonts
                                                            .poppinsBold,
                                                        color: themeController
                                                                .isDarkMode
                                                            ? DarkModeColors
                                                                .kWhite
                                                            : AppColors.kBlack,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 3),
                                                  ),
                                                  content: Text(
                                                    'Are your sure you want to end Practice?',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: themeController
                                                                .isDarkMode
                                                            ? DarkModeColors
                                                                .kWhite
                                                            : AppColors.kBlack),
                                                  ),
                                                  actions: <Widget>[
                                                    MaterialButton(
                                                      child: const Text(
                                                        "Restart Practice",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: AppColors
                                                                .greenColor),
                                                      ),
                                                      onPressed: () {
                                                        quizController
                                                            .clearController();
                                                        quizController
                                                            .questionNo
                                                            .value = 0;
                                                        Get.close(1);
                                                      },
                                                    ),
                                                    MaterialButton(
                                                      onPressed: () {
                                                        Get.close(2);
                                                      },
                                                      child: const Text(
                                                        "End Practice",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                AppColors.kRed),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      themeController.isDarkMode
                                                          ? DarkModeColors
                                                              .kAppBarColor
                                                          : AppColors.kWhite,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          16))),
                                                  title: Text(
                                                    'Trial Ends'.toUpperCase(),
                                                    style: TextStyle(
                                                        fontFamily: AppFonts
                                                            .poppinsBold,
                                                        color: themeController
                                                                .isDarkMode
                                                            ? DarkModeColors
                                                                .kWhite
                                                            : AppColors.kBlack,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 3),
                                                  ),
                                                  content: Text(
                                                    'Your free trial is over please subscribe to our packages to get full access.',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: themeController
                                                                .isDarkMode
                                                            ? DarkModeColors
                                                                .kWhite
                                                            : AppColors.kBlack),
                                                  ),
                                                  actions: <Widget>[
                                                    MaterialButton(
                                                      child: const Text(
                                                        "Close",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: AppColors
                                                                .greenColor),
                                                      ),
                                                      onPressed: () {
                                                        db.updateTrial(
                                                            widget.exam.id);
                                                        Get.close(3);
                                                      },
                                                    ),
                                                    MaterialButton(
                                                      onPressed: () async {
                                                        db.updateTrial(
                                                            widget.exam.id);
                                                        Get.close(3);
                                                        await launchUrl(Uri.parse(
                                                            "https://www.futuregreenworld.com/"));
                                                      },
                                                      child: const Text(
                                                        "Subscribe",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                AppColors.kRed),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
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
                                visible: quizController.skippedIndex.isNotEmpty,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        (index) => GestureDetector(
                                          onTap: (){
                                            quizController
                                                .clearController();
                                            quizController
                                                .questionNo.value =
                                            quizController
                                                .skippedIndex[index];
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColors.greyColor.withOpacity(0.4)),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                                height: 60,
                                                width: Get.width,
                                                child: ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundColor:AppColors.greyColor,
                radius: 20,
                child: Image.asset(
                // 'assets/icons/practice_questions.png',
               'assets/images/Vector.png',
                width: 40,
                height: 40,
                ),
                ),
                                                //  Image.asset("assets/images/Vector.png", color: Colors.green,),

                                                  title: Text(
                                                    "Question ${quizController.skippedIndex[index] + 1}",
                                                    style: const TextStyle(
                                                        color: AppColors.kBlack,
                                                        fontSize: 14,
                                                        fontFamily: AppFonts
                                                            .poppinsRegular),
                                                  ),
                                                  trailing: Icon(Icons.arrow_forward_rounded),

                                                )
                                                // ElevatedButton.icon(
                                                //   style: ElevatedButton.styleFrom(
                                                //     backgroundColor:
                                                //         AppColors.kYellowColor,
                                                //     shape: RoundedRectangleBorder(
                                                //         borderRadius:
                                                //             BorderRadius.circular(
                                                //                 15)),
                                                //   ),
                                                //   // onPressed: () {
                                                //   //   quizController
                                                //   //       .clearController();
                                                //   //   quizController
                                                //   //           .questionNo.value =
                                                //   //       quizController
                                                //   //           .skippedIndex[index];
                                                //   // },
                                                //   icon: const Icon(
                                                //     Icons.fast_forward,
                                                //     color: AppColors.kWhite,
                                                //     size: 18,
                                                //   ),
                                                //   label: Text(
                                                //     "Question ${quizController.skippedIndex[index] + 1}",
                                                //     style: const TextStyle(
                                                //         color: AppColors.kWhite,
                                                //         fontSize: 14,
                                                //         fontFamily: AppFonts
                                                //             .poppinsRegular),
                                                //   ),
                                                // ),
                                              ).paddingB(10),
                                        ))
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
              return const Loading(text: "Preparing Exam").center.paddingT(15);
            }
          },
        ),
        // bottomNavigationBar: Container(
        //   height: 70,
        //   decoration: const BoxDecoration(
        //     color: Colors.white,
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Row(
        //         children: [
        //           Expanded(
        //             child: Visibility(
        //
        //               child: Container(
        //                 margin: const EdgeInsets.only(right: 10, left: 10),
        //                 height: 60,
        //                 decoration: BoxDecoration(
        //                   border: Border.all(
        //                       color: AppColors.greyColor.withOpacity(0.4)),
        //                   borderRadius: BorderRadius.circular(15),
        //                 ),
        //                 child: const Center(
        //                   child: Text(
        //                     "Skip",
        //                     style: TextStyle(
        //                         fontSize: 14,
        //                         fontWeight: FontWeight.w600,
        //                         color: AppColors.greyColor),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //           Expanded(
        //             child: Visibility(
        //               visible:  quizController.questionNo.value > 0,
        //               child: GestureDetector(
        //                 onTap: (){
        //                   quizController.clearController();
        //                   quizController.questionNo.value--;
        //                 },
        //                 child: Container(
        //                   margin: const EdgeInsets.only(right: 10),
        //                   height: 60,
        //                   decoration: BoxDecoration(
        //                     border: Border.all(color: AppColors.darkGreenColor),
        //                     borderRadius: BorderRadius.circular(15),
        //                   ),
        //                   child: const Center(
        //                     child: Text(
        //                       "Previous",
        //                       style: TextStyle(
        //                           fontSize: 14,
        //                           fontWeight: FontWeight.w600,
        //                           color: AppColors.darkGreenColor),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //           Expanded(
        //             child: Visibility(
        //              // visible: ,
        //               child: Container(
        //                 margin: const EdgeInsets.only(right: 10),
        //                 height: 60,
        //                 decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.circular(15),
        //                     color: AppColors.darkGreenColor),
        //                 child: const Center(
        //                   child: Text(
        //                     "Next",
        //                     style: TextStyle(
        //                         fontSize: 14,
        //                         fontWeight: FontWeight.w600,
        //                         color: Colors.white),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ),
    ));
  }
}



          // * The user has selected wrong option
          // Container(
          //   height: 120.h,
          //   decoration: const BoxDecoration(
          //     color: Colors.white,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black12,
          //         offset: Offset(0, -2),
          //         blurRadius: 7,
          //         spreadRadius: 1,
          //       ),
          //     ],
          //   ),
          //   child: Column(
          //     children: [
          //       Container(
          //         margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
          //         child: Row(
          //           children: [
          //             Image.asset(
          //               'assets/icons/wrong.png',
          //               height: 25.h,
          //               width: 25.w,
          //             ),
          //             SizedBox(width: 20.w),
          //             Text(
          //               "Try Again",
          //               style: TextStyle(
          //                 fontSize: 14.sp,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //             ),
          //             const Spacer(),
          //             Image.asset(
          //               'assets/icons/flag.png',
          //               height: 25.h,
          //               width: 25.w,
          //             ),
          //           ],
          //         ),
          //       ),
          //       ContinueButton(),
          //     ],
          //   ),
          // ),

          // * The user has selected a correct option
          //     Container(
          //   height: 120.h,
          //   decoration: const BoxDecoration(
          //     color: Colors.white,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black12,
          //         offset: Offset(0, -2),
          //         blurRadius: 7,
          //         spreadRadius: 1,
          //       ),
          //     ],
          //   ),
          //   child: Column(
          //     children: [
          //       Container(
          //         margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
          //         child: Row(
          //           children: [
          //             Image.asset(
          //               'assets/icons/correct.png',
          //               height: 25.h,
          //               width: 25.w,
          //             ),
          //             SizedBox(width: 20.w),
          //             Text(
          //               "Good Job!",
          //               style: TextStyle(
          //                 fontSize: 14.sp,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //             ),
          //             const Spacer(),
          //             Image.asset(
          //               'assets/icons/flag.png',
          //               height: 25.h,
          //               width: 25.w,
          //             ),
          //           ],
          //         ),
          //       ),
          //       ContinueButton(),
          //     ],
          //   ),
          // ),

          // * show this when the user select an option
        //   Container(
        // height: 70.h,
        // decoration: const BoxDecoration(
        //   color: Colors.white,
        // ),
        // child: Column(
        //   children: [
            // * skipped questions Container

            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 20.w),
            //   padding: EdgeInsets.all(15.h),
            //   decoration: BoxDecoration(
            //       color: AppColors.orangeColor.withOpacity(0.2),
            //       borderRadius: BorderRadius.circular(10)),
            //   child: Row(
            //     children: [
            //       Image.asset('assets/icons/calender.png',
            //           height: 25.h, width: 25.w),
            //       SizedBox(width: 15.w),
            //       Text(
            //         "You have 4 questions skipped",
            //         style: TextStyle(
            //           fontSize: 14.sp,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //       Spacer(),
            //       Container(
            //         height: 30.h,
            //         width: 45.w,
            //         decoration: BoxDecoration(
            //             color: AppColors.orangeColor,
            //             borderRadius: BorderRadius.circular(5)),
            //         child: Center(
            //           child: Text(
            //             "View",
            //             style: TextStyle(
            //               fontSize: 12.sp,
            //               fontWeight: FontWeight.w600,
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // SizedBox(height: 10.h),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Container(
            //         margin: EdgeInsets.only(right: 10.w, left: 10.w),
            //         height: 60.h,
            //         decoration: BoxDecoration(
            //           border: Border.all(
            //               color: AppColors.greyColor.withOpacity(0.4)),
            //           borderRadius: BorderRadius.circular(15),
            //         ),
            //         child: Center(
            //           child: Text(
            //             "Skip",
            //             style: TextStyle(
            //                 fontSize: 14.sp,
            //                 fontWeight: FontWeight.w600,
            //                 color: AppColors.greyColor),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: Container(
            //         margin: EdgeInsets.only(right: 10.w),
            //         height: 60.h,
            //         decoration: BoxDecoration(
            //           border: Border.all(color: AppColors.darkGreenColor),
            //           borderRadius: BorderRadius.circular(15),
            //         ),
            //         child: Center(
            //           child: Text(
            //             "Previous",
            //             style: TextStyle(
            //                 fontSize: 14.sp,
            //                 fontWeight: FontWeight.w600,
            //                 color: AppColors.darkGreenColor),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: Container(
            //         margin: EdgeInsets.only(right: 10.w),
            //         height: 60.h,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(15),
            //             color: AppColors.darkGreenColor),
            //         child: Center(
            //           child: Text(
            //             "Next",
            //             style: TextStyle(
            //                 fontSize: 14.sp,
            //                 fontWeight: FontWeight.w600,
            //                 color: Colors.white),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),