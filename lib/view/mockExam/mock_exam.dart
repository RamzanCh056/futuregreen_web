import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:future_green_world/controllers/timer_controller.dart';
import 'package:future_green_world/controllers/quiz_controller.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/custom_safe_area.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/components/loading.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:future_green_world/view/mockExam/quiz_result.dart';
import 'package:future_green_world/view_model/controller/quiz/quiz_view_model_controller.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../models/mock_chapter.dart';
import '../../models/mock_exam_question.dart';
import '../../res/components/custom_pop_up.dart';
import '../../res/components/custom_snackbar.dart';
import '../../res/controller/controller_instances.dart';

class MockExamScreen extends StatefulWidget {
  const MockExamScreen({super.key, required this.chapter});
  final MockChapterModel chapter;

  @override
  State<MockExamScreen> createState() => _MockExamScreenState();
}

class _MockExamScreenState extends State<MockExamScreen> {
  final timerController = Get.put(TimerController());
  final quizVMController = Get.put(QuizViewModel());
  final quizController = Get.put(QuizController());
  var quizStarted = false.obs;
  var correctQuestions = 0.obs;
  var attempted = 0.obs;
  var viewTimer = true.obs;
  List<MockExamQuestionModel> attemptedQuestions = [];

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

  formattedTime({required int time}) {
    int sec = time % 60;
    int min = (time / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
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
            GestureDetector(
              onTap: () => viewTimer.value = !viewTimer.value,
              child: Padding(
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
                        return Obx(() {
                          return Center(
                            child: Text(
                              viewTimer.value ? displayTime : 'Time',
                              style: const TextStyle(
                                  color: AppColors.kWhite,
                                  fontFamily: AppFonts.poppinsMedium),
                            ),
                          );
                        });
                      }),
                ),
              ),
            ),
          ],
        ),
        body: StreamBuilder<dynamic>(
            stream: firestore
                .collection("mockExamQuestions")
                .where("chapterId", isEqualTo: widget.chapter.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<MockExamQuestionModel> questions = snapshot.data.docs
                    .map<MockExamQuestionModel>(
                        (e) => MockExamQuestionModel.fromJson(e))
                    .toList();
                // questions = questions.take(10).toList();

                return Obx(() {
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

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       'Performance',
                        //       style: TextStyle(
                        //         fontFamily: AppFonts.poppinsMedium,
                        //         color: themeController.isDarkMode
                        //             ? DarkModeColors.kWhite
                        //             : AppColors.kBlack,
                        //       ),
                        //     ),
                        //     //Attempted & Total Questions
                        //     Text(
                        //       '${((correctQuestions.value / (attempted.value == 0 ? 1 : attempted.value)) * 100).toStringAsFixed(0)}%',
                        //       style: const TextStyle(
                        //         fontSize: 16,
                        //         fontFamily: AppFonts.poppinsBold,
                        //         color: AppColors.kPrimary,
                        //       ),
                        //     ),
                        //   ],
                        // ),
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
                        Container(
                          color: AppColors.kTransparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (!questions[
                                                quizController.questionNo.value]
                                            .participants
                                            .contains(authController
                                                .getCurrentUser())) {
                                          if (questions[quizController
                                                      .questionNo.value]
                                                  .choices[index] ==
                                              questions[quizController
                                                      .questionNo.value]
                                                  .correct) {
                                            correctQuestions.value++;
                                          }
                                          attempted.value++;
                                          await firestore
                                              .collection("mockExamQuestions")
                                              .doc(questions[quizController
                                                      .questionNo.value]
                                                  .id)
                                              .update({
                                            "participants":
                                                FieldValue.arrayUnion([
                                              authController.getCurrentUser()
                                            ]),
                                            "attempted": FieldValue.arrayUnion([
                                              AttemptedModel(
                                                      uid: authController
                                                          .getCurrentUser(),
                                                      selected: questions[
                                                              quizController
                                                                  .questionNo
                                                                  .value]
                                                          .choices[index])
                                                  .toMap()
                                            ])
                                          });
                                        }
                                      },
                                      child: Obx(() {
                                        return Card(
                                          color: questions[quizController
                                                          .questionNo.value]
                                                      .participants
                                                      .contains(authController
                                                          .getCurrentUser()) &&
                                                  questions[quizController
                                                              .questionNo.value]
                                                          .attempted
                                                          .where((e) =>
                                                              e.uid ==
                                                              authController
                                                                  .getCurrentUser())
                                                          .first
                                                          .selected ==
                                                      questions[quizController
                                                              .questionNo.value]
                                                          .choices[index]
                                              ? Ex.blue400.withOpacity(0.4)
                                              : themeController.isDarkMode
                                                  ? DarkModeColors.kBodyColor
                                                  : AppColors.kWhite,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Row(
                                                  children: [
                                                    Card(
                                                      color: questions[quizController
                                                                      .questionNo
                                                                      .value]
                                                                  .participants
                                                                  .contains(
                                                                      authController
                                                                          .getCurrentUser()) &&
                                                              questions[quizController
                                                                          .questionNo
                                                                          .value]
                                                                      .attempted
                                                                      .where((e) =>
                                                                          e.uid ==
                                                                          authController
                                                                              .getCurrentUser())
                                                                      .first
                                                                      .selected ==
                                                                  questions[quizController
                                                                          .questionNo
                                                                          .value]
                                                                      .choices[index]
                                                          ? Ex.blue400
                                                          : AppColors.kTransparent,
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
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
                                                                horizontal: 10,
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
                                                              color: themeController
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
                                                        questions[quizController
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
                                                                    radius: 10,
                                                                    child: Icon(
                                                                      Icons
                                                                          .check,
                                                                      size: 14,
                                                                      color: AppColors
                                                                          .kWhite,
                                                                    ),
                                                                  )
                                                                : const CircleAvatar(
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .kRed,
                                                                    radius: 10,
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 14,
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
                                    visible: quizController.questionNo.value >
                                            0 &&
                                        quizController.questionNo.value + 1 <
                                            questions.length,
                                    child: SizedBox(
                                      width: Get.height * 0.01,
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
                                        width: Get.width,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.kPrimary,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                          onPressed: () {
                                            if (questions[quizController
                                                    .questionNo.value]
                                                .participants
                                                .contains(authController
                                                    .getCurrentUser())) {
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
                                          backgroundColor: AppColors.kGreen,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                        onPressed: () async {
                                          if (questions[quizController
                                                  .questionNo.value]
                                              .participants
                                              .contains(authController
                                                  .getCurrentUser())) {
                                            timerController.stopWatchTimer
                                                .onStopTimer();
                                            Get.off(() => MockExamResultScreen(
                                                chapter: widget.chapter,
                                                score: ((correctQuestions
                                                            .value /
                                                        (attempted.value == 0
                                                            ? 1
                                                            : attempted
                                                                .value)) *
                                                    100),
                                                time:
                                                    StopWatchTimer.getRawSecond(
                                                        timerController
                                                            .stopWatchTimer
                                                            .rawTime
                                                            .value),
                                                totalQuestion:
                                                    questions.length));
                                            if (widget.chapter.participants
                                                .where((e) =>
                                                    e.uid ==
                                                    authController
                                                        .getCurrentUser())
                                                .isNotEmpty) {
                                              await firestore
                                                  .collection(
                                                      "mockExamChapters")
                                                  .doc(widget.chapter.id)
                                                  .update({
                                                "participants":
                                                    FieldValue.arrayRemove([
                                                  widget.chapter.participants
                                                      .where((e) =>
                                                          e.uid ==
                                                          authController
                                                              .getCurrentUser())
                                                      .first
                                                      .toJson()
                                                ]),
                                              });
                                            }
                                            firestore
                                                .collection("mockExamChapters")
                                                .doc(widget.chapter.id)
                                                .update({
                                              "participants":
                                                  FieldValue.arrayUnion([
                                                MockParticipantModel(
                                                        uid: authController
                                                            .getCurrentUser(),
                                                        totalTime: formattedTime(
                                                            time: StopWatchTimer.getRawSecond(
                                                                timerController
                                                                    .stopWatchTimer
                                                                    .rawTime
                                                                    .value)),
                                                        score: ((correctQuestions
                                                                    .value /
                                                                (attempted.value ==
                                                                        0
                                                                    ? 1
                                                                    : attempted
                                                                        .value)) *
                                                            100),
                                                        time: StopWatchTimer.getRawSecond(
                                                                timerController
                                                                    .stopWatchTimer
                                                                    .rawTime
                                                                    .value) /
                                                            questions.length)
                                                    .toJson()
                                              ])
                                            });
                                          } else {
                                            showErrorSnackbar(
                                                "Please attempt this question to see result!",
                                                context);
                                          }
                                        },
                                        icon: const Text(
                                          "See Result",
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
                            ],
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
