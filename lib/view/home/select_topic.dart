import 'package:flutter/material.dart';
import 'package:future_green_world/models/exam.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/loading.dart';
import 'package:future_green_world/res/controller/controller_instances.dart';
import 'package:future_green_world/view/exams/exams.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../res/components/continue_button.dart';

class SelectTopic extends StatefulWidget {
  const SelectTopic({super.key});

  @override
  State<SelectTopic> createState() => _SelectTopicState();
}

class _SelectTopicState extends State<SelectTopic> {
  int? selectedExamIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: const Text(
                "Select Topic Study",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
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
            const SizedBox(height: 30),
            StreamBuilder<dynamic>(
                stream: firestore.collection("exams").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ExamModel> exams = snapshot.data!.docs
                        .map<ExamModel>((e) => ExamModel.fromJson(e))
                        .toList();
                    return Column(
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
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 15),
                              decoration: BoxDecoration(
                                color: selectedExamIndex == index
                                    ? AppColors.greenColor.withOpacity(0.2)
                                    : null,
                                border: Border.all(
                                    color:
                                        AppColors.greyColor.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/CFA_Book.png',
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
                                            width: 20)
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.31),
                        GestureDetector(
                          onTap: () {
                            if (selectedExamIndex != null) {
                              Get.to(() => ExamsScreen(
                                    examData: exams[selectedExamIndex!],
                                  ));
                            }
                          },
                          child: const ContinueButton(),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Loading());
                  }
                }),
          ],
        ),
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CustomSafeArea(
//         child: Scaffold(
//       backgroundColor: themeController.isDarkMode
//           ? DarkModeColors.kBodyColor
//           : AppColors.kWhite,
//       appBar: AppBar(
//         backgroundColor: themeController.isDarkMode
//             ? DarkModeColors.kAppBarColor
//             : AppColors.kWhite,
//         automaticallyImplyLeading: false,
//         elevation: 0,
//         title: GestureDetector(
//           // onTap: () async {
//           //   await firestore
//           //       .collection("mockExamChapters")
//           //       .get()
//           //       .then((value) async {
//           //     for (dynamic exam in value.docs) {
//           //       await firestore
//           //           .collection("mockExamChapters")
//           //           .doc(exam["id"])
//           //           .update({
//           //         "score": 0,
//           //         "time": 0,
//           //       });
//           //     }
//           //   });
//           // },
//           child: Text(
//             'FutureGreenWorld',
//             style: TextStyle(
//                 fontSize: 24,
//                 fontFamily: AppFonts.poppinsBold,
//                 color: themeController.isDarkMode
//                     ? DarkModeColors.kWhite
//                     : AppColors.kPrimary),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: ListView(
//           physics: const BouncingScrollPhysics(),
//           children: [
//             (Get.height * 0.01).heightBox,
//             Row(
//               children: [
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 const Text(
//                   'Welcome ',
//                   style: TextStyle(
//                       fontFamily: AppFonts.poppinsRegular,
//                       fontSize: 20,
//                       color: AppColors.kPrimary),
//                 ),
//                 //User Name
//                 StreamBuilder(
//                     stream: firestore
//                         .collection("users")
//                         .doc(authController.getCurrentUser())
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         var user = snapshot.data!;
//                         return Flexible(
//                           child: Text(
//                             user['name'],
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                                 fontFamily: AppFonts.poppinsMedium,
//                                 fontSize: 22,
//                                 color: AppColors.kPrimary),
//                           ),
//                         );
//                       } else {
//                         return const Loading(
//                           size: 20,
//                         );
//                       }
//                     }),
//               ],
//             ),
//             SizedBox(
//               height: Get.height * 0.01,
//             ),
//             //exams
//             StreamBuilder<dynamic>(
//                 stream: firestore.collection("exams").snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     List<ExamModel> exams = snapshot.data!.docs
//                         .map<ExamModel>((e) => ExamModel.fromJson(e))
//                         .toList();
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         ...List.generate(
//                             exams.length,
//                             (index) => customExamCard(context, exams[index],
//                                 index == 0 ? "esg" : "scr")),
//                       ],
//                     );
//                   } else {
//                     return const Center(child: Loading());
//                   }
//                 }),
//           ],
//         ),
//       ),
//     ));
//   }

//   Widget customExamCard(BuildContext context, ExamModel exam, String image) {
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => ExamsScreen(
//               examData: exam,
//             ));
//       },
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: Ex.rounded,
//             image: DecorationImage(
//                 image: AssetImage("assets/images/$image.jpg"),
//                 fit: BoxFit.cover,
//                 opacity: 1)),
//         width: double.infinity,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: Ex.rounded,
//             color: AppColors.kBlack.withOpacity(0.4),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                     width: 45,
//                     height: 45,
//                     decoration: const BoxDecoration(
//                         color: AppColors.kWhite, shape: BoxShape.circle),
//                     child: const Center(
//                         child: Icon(
//                       Icons.sticky_note_2,
//                       size: 28,
//                       color: AppColors.kGreen,
//                     ))),
//                 SizedBox(
//                   height: 4.h,
//                 ),
//                 Text(
//                   exam.name,
//                   style: const TextStyle(
//                       fontFamily: AppFonts.poppinsBold,
//                       fontSize: 24,
//                       color: AppColors.kWhite),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ).paddingVert(10),
//     );
//   }
// }










// Container(
            //   margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(15),
            //     child: Row(
            //       children: [
            //         Image.asset(
            //           'assets/icons/GARP_book.png',
            //           height: 40,
            //           width: 40,
            //         ),
            //         const SizedBox(width: 5),
            //         const Text(
            //           "GARP SCR",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //         const Spacer(),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(15),
            //     child: Row(
            //       children: [
            //         Image.asset(
            //           'assets/icons/CAIA_book-1.png',
            //           height: 40,
            //           width: 40,
            //         ),
            //         const SizedBox(width: 5),
            //         const Text(
            //           "CAIA",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //         const Spacer(),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(15),
            //     child: Row(
            //       children: [
            //         Image.asset(
            //           'assets/icons/CAIA_book.png',
            //           height: 40,
            //           width: 40,
            //         ),
            //         const SizedBox(width: 5),
            //         const Text(
            //           "CIPM",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //         const Spacer(),
            //       ],
            //     ),
            //   ),
            // ),


            
            // Container(
            //   margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(15),
            //     child: Row(
            //       children: [
            //         Image.asset(
            //           'assets/icons/GARP_book.png',
            //           height: 40,
            //           width: 40,
            //         ),
            //         const SizedBox(width: 5),
            //         const Text(
            //           "GARP SCR",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //         const Spacer(),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(15),
            //     child: Row(
            //       children: [
            //         Image.asset(
            //           'assets/icons/CAIA_book-1.png',
            //           height: 40,
            //           width: 40,
            //         ),
            //         const SizedBox(width: 5),
            //         const Text(
            //           "CAIA",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //         const Spacer(),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(15),
            //     child: Row(
            //       children: [
            //         Image.asset(
            //           'assets/icons/CAIA_book.png',
            //           height: 40,
            //           width: 40,
            //         ),
            //         const SizedBox(width: 5),
            //         const Text(
            //           "CIPM",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //         const Spacer(),
            //       ],
            //     ),
            //   ),
            // ),