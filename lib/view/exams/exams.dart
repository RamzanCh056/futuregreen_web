import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:future_green_world/models/exam.dart';
import 'package:future_green_world/res/assets/icon_assets.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/custom_elevated_button.dart';
import 'package:future_green_world/res/components/custom_snackbar.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:future_green_world/view/chapter/chapter_screen.dart';
import 'package:future_green_world/view/factSheet/facts.dart';
import 'package:future_green_world/view/flashCards/flash_card_chapter_screen.dart';
import 'package:future_green_world/view/mockExam/chapter_screen.dart';
import 'package:future_green_world/view/practice/practice_quiz_screen.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../res/controller/controller_instances.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key, required this.examData});
  final ExamModel examData;

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  bool isPracticeSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                const Text(
                  "Manual Mode",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<dynamic>(
              initialData: widget.examData.toJson(),
              stream: firestore
                  .collection("exams")
                  .doc(widget.examData.id)
                  .snapshots(),
              builder: (context, snapshot) {
                ExamModel exam = ExamModel.fromJson(snapshot.data);
                return Column(
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
                        // if (exam.mockExamAllowed
                        //     .contains(authController.getCurrentUser())) {
                        Get.to(() => PracticeQuizScreen(
                              exam: exam,
                            ));
                        // } else {
                        // showErrorSnackbar(
                        //     "Practice Exams are locked!", context);
                        // }
                      },
                      child: ManualWidget(
                        imageUrl: 'assets/icons/practice_exam.png',
                        text: "Practice Exam",
                        switchIcon: Transform.scale(
                          scale: 0.7,
                          child: Switch(
                              value: !isPracticeSwitched,
                              onChanged: null,
                              activeTrackColor: AppColors.greenColor),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (exam.allowedUsers
                            .contains(authController.getCurrentUser())) {
                          Get.to(() => ChapterScreen(
                                exam: exam,
                              ));
                        } else {
                          showErrorSnackbar("Chapters are locked!", context);
                        }
                      },
                      child: ManualWidget(
                        imageUrl: 'assets/icons/practice chapter.png',
                        text: "Practice By Chapter",
                        switchIcon: Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: exam.allowedUsers
                                .contains(authController.getCurrentUser()),
                            onChanged: null,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (exam.mockExamAllowed
                            .contains(authController.getCurrentUser())) {
                          Get.to(() => MockExamChapterScreen(exam: exam));
                        } else {
                          showErrorSnackbar("Mock Exam is locked!", context);
                        }
                      },
                      child: ManualWidget(
                        imageUrl: 'assets/icons/exam.png',
                        text: "Mock Exam",
                        switchIcon: Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: exam.mockExamAllowed
                                .contains(authController.getCurrentUser()),
                            onChanged: null,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (exam.factsAllowed
                            .contains(authController.getCurrentUser())) {
                          Get.to(() => FactsScreen(
                                examId: exam.id,
                              ));
                        } else {
                          showErrorSnackbar("Facts are locked!", context);
                        }
                      },
                      child: ManualWidget(
                        imageUrl: 'assets/icons/fact_icon.png',
                        text: "Fact Sheet",
                        switchIcon: Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: exam.factsAllowed
                                .contains(authController.getCurrentUser()),
                            onChanged: null,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (exam.flashCardAllowed
                            .contains(authController.getCurrentUser())) {
                          Get.to(() => FlashCardChapterScreen(
                                exam: exam,
                              ));
                        } else {
                          showErrorSnackbar("Flash Cards are locked!", context);
                        }
                      },
                      child: ManualWidget(
                        imageUrl: 'assets/icons/flash card.png',
                        text: "Flash Card",
                        switchIcon: Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: exam.flashCardAllowed
                                .contains(authController.getCurrentUser()),
                            onChanged: null,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (exam.flashCardAllowed
                            .contains(authController.getCurrentUser())) {
                          Get.to(() => FlashCardChapterScreen(
                            exam: exam,
                          ));
                        } else {
                          showErrorSnackbar("Flash Cards are locked!", context);
                        }
                      },
                      child: ManualWidget(
                        imageUrl: "assets/icons/study note.png",
                        text: "Study Notes",
                        switchIcon: Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: exam.flashCardAllowed
                                .contains(authController.getCurrentUser()),
                            onChanged: null,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ],
      ),
    ));
  }
}

class ManualWidget extends StatelessWidget {
  final String imageUrl;
  final String text;
  final Widget? switchIcon;
  const ManualWidget({
    super.key,
    required this.imageUrl,
    required this.text,
    this.switchIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Image.asset(
              imageUrl,
              // 'assets/icons/practice_exam.png',
              height: 50,
              width: 50,
            ),
            const SizedBox(width: 5),
            Text(
              text,
              // "Practice Exam",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            switchIcon ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}

// void showPracticeQuestionsDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         insetPadding: EdgeInsets.symmetric(horizontal: 15),
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               const SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: AppColors.darkGreenColor),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                   child: Center(
//                     child: Column(
//                       children: [
//                         Text(
//                           "Practice Questions",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           "50",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     width: 126,
//                     decoration: BoxDecoration(
//                       color: AppColors.darkGreenColor,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Center(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 10),
//                         child: Text(
//                           "Save",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: 126,
//                     decoration: BoxDecoration(
//                       color: AppColors.greyColor,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Center(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 10),
//                         child: Text(
//                           "Cancel",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

// void showUnsolvedOnly(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         insetPadding: EdgeInsets.symmetric(horizontal: 15),
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               const SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: AppColors.darkGreenColor),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                   child: Center(
//                     child: Column(
//                       children: [
//                         Text(
//                           "Show Unsolved Only",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           "Show All",
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.darkGreenColor),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.assetImage,
    required this.title,
    required this.quote,
    required this.onPress,
    required this.buttonText,
    required this.color,
  });
  final String assetImage;
  final String title;
  final String quote;
  final String buttonText;
  final Color color;
  final void Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppColors.kTransparent,
      color: color.withOpacity(0.15),
      shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.5,
            color: themeController.isDarkMode
                ? DarkModeColors.kWhite
                : AppColors.kBlack,
          ),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  assetImage,
                  height: 60,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: AppFonts.poppinsBold,
                    color: themeController.isDarkMode
                        ? DarkModeColors.kWhite
                        : AppColors.kBlack,
                  ),
                ).paddingHrz(5).center.flexible,
              ],
            ),
            // 2.h.heightBox,
            Text(
              quote,
              style: TextStyle(
                  color: themeController.isDarkMode
                      ? DarkModeColors.kWhite
                      : AppColors.kBlack,
                  fontSize: 16,
                  fontFamily: AppFonts.poppinsRegular),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            CustomElevatedButton(
              title: buttonText,
              onPress: onPress,
              width: double.maxFinite,
              borderRadius: 20,
              buttonColor: color,
            )
          ],
        ),
      ),
    );
  }
}

//Custom Card
// CustomCard(
//     assetImage: IconAssets.learningIcon,
//     title: exam.allowedUsers
//             .contains(authController.getCurrentUser())
//         ? 'Practice Exam'
//         : "Trial Exam",
//     quote:
//         'Practice puts brains in your muscles. - Sam Snead',
//     buttonText: exam.allowedUsers
//             .contains(authController.getCurrentUser())
//         ? 'Start Practice'
//         : exam.trialEnd
//                 .contains(authController.getCurrentUser())
//             ? "Trial has Ended!"
//             : "Start Trial",
//     color: AppColors.kPrimary,
//     onPress: () {
//       if (exam.trialEnd.contains(
//               authController.getCurrentUser()) &&
//           !exam.allowedUsers.contains(
//               authController.getCurrentUser())) {
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               backgroundColor: themeController.isDarkMode
//                   ? DarkModeColors.kAppBarColor
//                   : AppColors.kWhite,
//               shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(
//                       Radius.circular(16))),
//               title: Text(
//                 'Trial Ends'.toUpperCase(),
//                 style: TextStyle(
//                     fontFamily: AppFonts.poppinsBold,
//                     color: themeController.isDarkMode
//                         ? DarkModeColors.kWhite
//                         : AppColors.kBlack,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 3),
//               ),
//               content: Text(
//                 'Your free trial is over please subscribe to our packages to get full access.',
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: themeController.isDarkMode
//                         ? DarkModeColors.kWhite
//                         : AppColors.kBlack),
//               ),
//               actions: <Widget>[
//                 MaterialButton(
//                   child: const Text(
//                     "Cancel",
//                     style: TextStyle(
//                         fontSize: 15,
//                         color: AppColors.kGreen),
//                   ),
//                   onPressed: () {
//                     Get.close(1);
//                   },
//                 ),
//                 MaterialButton(
//                   onPressed: () async {
//                     Get.close(1);
//                     await launchUrl(Uri.parse(
//                         "https://www.futuregreenworld.com/"));
//                   },
//                   child: const Text(
//                     "Subscribe",
//                     style: TextStyle(
//                         fontSize: 15,
//                         color: AppColors.kRed),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         Get.to(() => PracticeQuizScreen(
//               exam: exam,
//             ));
//       }
//     }),

// Column(
//   children: [
//     SizedBox(
//       height: Get.height * 0.01,
//     ),
//     //Chapters Card
//     CustomCard(
//         assetImage: IconAssets.bookIcon,
//         title: 'Chapters',
//         quote:
//             'Wisdom is not a product of schooling but of the lifelong attempt to acquire it. - Albert Einstein',
//         buttonText: exam.allowedUsers
//                 .contains(authController.getCurrentUser())
//             ? 'Choose Chapter'
//             : "Locked",
//         color: AppColors.kYellowColor,
//         onPress: () {
//           if (exam.allowedUsers
//               .contains(authController.getCurrentUser())) {
//             Get.to(() => ChapterScreen(
//                   exam: exam,
//                 ));
//           } else {
//             showErrorSnackbar(
//                 "Chapters are locked!", context);
//           }
//         }),
//     SizedBox(
//       height: Get.height * 0.01,
//     ),
//     //Custom Card
//     CustomCard(
//         assetImage: IconAssets.examIcon,
//         title: 'Mock Exam',
//         quote:
//             'Trust yourself, you know more than you think you do. - Benjamin Spock',
//         buttonText: exam.mockExamAllowed
//                 .contains(authController.getCurrentUser())
//             ? 'Start Practice'
//             : "Locked",
//         color: Ex.purple800,
//         onPress: () {
//           if (exam.mockExamAllowed
//               .contains(authController.getCurrentUser())) {
//             Get.to(() => MockExamChapterScreen(exam: exam));
//           } else {
//             showErrorSnackbar(
//                 "Mock Exam is locked!", context);
//           }
//         }),
//     SizedBox(
//       height: Get.height * 0.01,
//     ),

//     //Custom Card
//     CustomCard(
//         assetImage: IconAssets.flashCardIcon,
//         title: 'Flash Cards',
//         quote:
//             'Knowledge is of no value unless you put it into practice. - Anton Chekhov',
//         buttonText: exam.flashCardAllowed
//                 .contains(authController.getCurrentUser())
//             ? 'Start Practice'
//             : "Locked!",
//         color: Ex.blue400,
//         onPress: () {
//           if (exam.flashCardAllowed
//               .contains(authController.getCurrentUser())) {
//             Get.to(() => FlashCardChapterScreen(
//                   exam: exam,
//                 ));
//           } else {
//             showErrorSnackbar(
//                 "Flash Cards are locked!", context);
//           }
//         }),
//     SizedBox(
//       height: Get.height * 0.01,
//     ),
//     //Custom Card
//     CustomCard(
//         assetImage: IconAssets.factIcon,
//         title: 'Fact Sheet',
//         quote:
//             'Facts that are not frankly faced have a habit of stabbing us in the back. - Sir Harold Bowden',
//         buttonText: exam.factsAllowed
//                 .contains(authController.getCurrentUser())
//             ? 'Explore'
//             : "Locked",
//         color: Ex.orange800,
//         onPress: () {
//           if (exam.factsAllowed
//               .contains(authController.getCurrentUser())) {
//             Get.to(() => FactsScreen(
//                   examId: exam.id,
//                 ));
//           } else {
//             showErrorSnackbar("Facts are locked!", context);
//           }
//         }),
//     SizedBox(
//       height: Get.height * 0.05,
//     ),
//   ],
// ),
