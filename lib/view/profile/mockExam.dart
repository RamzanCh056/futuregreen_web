import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../models/exam.dart';
import '../../models/mock_chapter.dart';
import '../../res/components/loading.dart';
import '../../res/controller/controller_instances.dart';


class MockExam extends StatelessWidget {
   MockExam({super.key});
  var showMockExam = ''.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(
                      "Mock Exam",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: 0.7,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.darkGreenColor,
                            ),
                            backgroundColor: AppColors.lightGreyColor,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "70%",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  StreamBuilder<dynamic>(

                      stream: firestore.collection("exams").snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<ExamModel> exams = snapshot.data!.docs
                              .map<ExamModel>((e) => ExamModel.fromJson(e))
                              .toList();
                          return SingleChildScrollView(

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                  exams.length,
                                      (index) =>  StreamBuilder<dynamic>(
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
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                itemCount: chapters.length,
                                                  itemBuilder: (context, index)
                                                  {
                                                    return  Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                      padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.1),
                                                            blurRadius: 10,
                                                            spreadRadius: 0,
                                                            offset: const Offset(0, 0),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              chapters[index].name,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.w700,
                                                              ),
                                                            ),
                                                            SizedBox(height: 20),
                                                            Row(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/icons/image 31.png',
                                                                  height: 15,
                                                                ),
                                                                const SizedBox(width: 10),
                                                                Text(
                                                                  "Score",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  '${chapters[index].participants.where((e) => e.uid == authController.getCurrentUser()).isNotEmpty ? chapters[index].participants.where((e) => e.uid == authController.getCurrentUser()).first.score.toStringAsFixed(0) : 0} %',
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 10),
                                                            Row(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/icons/chronometer.png',
                                                                  height: 15,
                                                                ),
                                                                const SizedBox(width: 10),
                                                                Text(
                                                                  "Time per question",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  '${chapters[index].participants.where((e) => e.uid == authController.getCurrentUser()).isNotEmpty ?chapters[index].participants.where((e) => e.uid == authController.getCurrentUser()).first.time.toStringAsFixed(1) : 0} s',
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 10),
                                                            Row(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/icons/image 33.png',
                                                                  height: 15,
                                                                ),
                                                                const SizedBox(width: 10),
                                                                Text(
                                                                  "Total time",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Text(
                                                                  chapters[index].participants
                                                                      .where(
                                                                          (e) => e.uid == authController.getCurrentUser())
                                                                      .isNotEmpty
                                                                      ? chapters[index].participants
                                                                      .where(
                                                                          (e) => e.uid == authController.getCurrentUser())
                                                                      .first
                                                                      .totalTime
                                                                      : "00:00",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                            
                                              );
                            
                            
                            
                                              //   StaggeredGrid.count(
                                              //     mainAxisSpacing:
                                              //     Get.width * 0.01,
                                              //     crossAxisSpacing:
                                              //     Get.width * 0.01,
                                              //     crossAxisCount: 2,
                                              //     children: List.generate(
                                              //         chapters.length,
                                              //             (index) =>   Container(
                                              //               margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              //               padding: EdgeInsets.all(10),
                                              //               decoration: BoxDecoration(
                                              //                 color: Colors.white,
                                              //                 borderRadius: BorderRadius.circular(10),
                                              //                 boxShadow: [
                                              //                   BoxShadow(
                                              //                     color: Colors.black.withOpacity(0.1),
                                              //                     blurRadius: 10,
                                              //                     spreadRadius: 0,
                                              //                     offset: const Offset(0, 0),
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //               child: Container(
                                              //                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              //                 child: Column(
                                              //                   crossAxisAlignment: CrossAxisAlignment.start,
                                              //                   children: [
                                              //                     Text(
                                              //                       "Mock Exam A",
                                              //                       style: TextStyle(
                                              //                         fontSize: 18,
                                              //                         fontWeight: FontWeight.w700,
                                              //                       ),
                                              //                     ),
                                              //                     SizedBox(height: 20),
                                              //                     Row(
                                              //                       children: [
                                              //                         Image.asset(
                                              //                           'assets/icons/image 31.png',
                                              //                           height: 15,
                                              //                         ),
                                              //                         const SizedBox(width: 10),
                                              //                         Text(
                                              //                           "Score",
                                              //                           style: TextStyle(
                                              //                             fontSize: 12,
                                              //                             fontWeight: FontWeight.w600,
                                              //                           ),
                                              //                         ),
                                              //                         const Spacer(),
                                              //                         Text(
                                              //                           "80",
                                              //                           style: TextStyle(
                                              //                             fontSize: 12,
                                              //                             fontWeight: FontWeight.w600,
                                              //                           ),
                                              //                         ),
                                              //                       ],
                                              //                     ),
                                              //                     SizedBox(height: 10),
                                              //                     Row(
                                              //                       children: [
                                              //                         Image.asset(
                                              //                           'assets/icons/chronometer.png',
                                              //                           height: 15,
                                              //                         ),
                                              //                         const SizedBox(width: 10),
                                              //                         Text(
                                              //                           "Time per question",
                                              //                           style: TextStyle(
                                              //                             fontSize: 12,
                                              //                             fontWeight: FontWeight.w600,
                                              //                           ),
                                              //                         ),
                                              //                         const Spacer(),
                                              //                         Text(
                                              //                           "49.23s",
                                              //                           style: TextStyle(
                                              //                             fontSize: 12,
                                              //                             fontWeight: FontWeight.w600,
                                              //                           ),
                                              //                         ),
                                              //                       ],
                                              //                     ),
                                              //                     SizedBox(height: 10),
                                              //                     Row(
                                              //                       children: [
                                              //                         Image.asset(
                                              //                           'assets/icons/image 33.png',
                                              //                           height: 15,
                                              //                         ),
                                              //                         const SizedBox(width: 10),
                                              //                         Text(
                                              //                           "Total time",
                                              //                           style: TextStyle(
                                              //                             fontSize: 12,
                                              //                             fontWeight: FontWeight.w600,
                                              //                           ),
                                              //                         ),
                                              //                         const Spacer(),
                                              //                         Text(
                                              //                           "25:12m",
                                              //                           style: TextStyle(
                                              //                             fontSize: 12,
                                              //                             fontWeight: FontWeight.w600,
                                              //                           ),
                                              //                         ),
                                              //                       ],
                                              //                     ),
                                              //                   ],
                                              //                 ),
                                              //               ),
                                              //             ),
                                              //
                                              //
                                              //     )
                                              // );
                                            } else {
                                              return const Loading(
                                                text: "Loading Summary",
                                              ).paddingT(20);
                                            }
                                          }),
                                  )),
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


              // *

              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.1),
              //         blurRadius: 10,
              //         spreadRadius: 0,
              //         offset: const Offset(0, 0),
              //       ),
              //     ],
              //   ),
              //   child: Container(
              //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Mock Exam B",
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.w700,
              //           ),
              //         ),
              //         SizedBox(height: 20),
              //         Row(
              //           children: [
              //             Image.asset(
              //               'assets/icons/image 31.png',
              //               height: 15,
              //             ),
              //             const SizedBox(width: 10),
              //             Text(
              //               "Score",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             const Spacer(),
              //             Text(
              //               "80",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 10),
              //         Row(
              //           children: [
              //             Image.asset(
              //               'assets/icons/chronometer.png',
              //               height: 15,
              //             ),
              //             const SizedBox(width: 10),
              //             Text(
              //               "Time per question",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             const Spacer(),
              //             Text(
              //               "49.23s",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 10),
              //         Row(
              //           children: [
              //             Image.asset(
              //               'assets/icons/image 33.png',
              //               height: 15,
              //             ),
              //             const SizedBox(width: 10),
              //             Text(
              //               "Total time",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             const Spacer(),
              //             Text(
              //               "25:12m",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              //
              // // *
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.1),
              //         blurRadius: 10,
              //         spreadRadius: 0,
              //         offset: const Offset(0, 0),
              //       ),
              //     ],
              //   ),
              //   child: Container(
              //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Mock Exam C",
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.w700,
              //           ),
              //         ),
              //         SizedBox(height: 20),
              //         Row(
              //           children: [
              //             Image.asset(
              //               'assets/icons/image 31.png',
              //               height: 15,
              //             ),
              //             const SizedBox(width: 10),
              //             Text(
              //               "Score",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             const Spacer(),
              //             Text(
              //               "80",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 10),
              //         Row(
              //           children: [
              //             Image.asset(
              //               'assets/icons/chronometer.png',
              //               height: 15,
              //             ),
              //             const SizedBox(width: 10),
              //             Text(
              //               "Time per question",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             const Spacer(),
              //             Text(
              //               "49.23s",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 10),
              //         Row(
              //           children: [
              //             Image.asset(
              //               'assets/icons/image 33.png',
              //               height: 15,
              //             ),
              //             const SizedBox(width: 10),
              //             Text(
              //               "Total time",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             const Spacer(),
              //             Text(
              //               "25:12m",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              //
              // // *
              //
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.1),
              //         blurRadius: 10,
              //         spreadRadius: 0,
              //         offset: const Offset(0, 0),
              //       ),
              //     ],
              //   ),
              //   child: Container(
              //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Mock Exam D",
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.w700,
              //           ),
              //         ),
              //         SizedBox(height: 20),
              //         Row(
              //           children: [
              //             Image.asset(
              //               'assets/icons/image 31.png',
              //               height: 15,
              //             ),
              //             const SizedBox(width: 10),
              //             Text(
              //               "Score",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             const Spacer(),
              //             Text(
              //               "80",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 10),
              //         Row(
              //           children: [
              //             Image.asset(
              //               'assets/icons/chronometer.png',
              //               height: 15,
              //             ),
              //             const SizedBox(width: 10),
              //             Text(
              //               "Time per question",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             const Spacer(),
              //             Text(
              //               "49.23s",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 10),
              //         Row(
              //           children: [
              //             Image.asset(
              //               'assets/icons/image 33.png',
              //               height: 15,
              //             ),
              //             const SizedBox(width: 10),
              //             Text(
              //               "Total time",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             const Spacer(),
              //             Text(
              //               "25:12m",
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
