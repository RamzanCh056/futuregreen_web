
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_green_world/res/components/extensions.dart';

import '../../models/chapter.dart';
import '../../models/exam.dart';
import '../../res/colors/app_colors.dart';
import '../../res/components/loading.dart';
import '../../res/controller/controller_instances.dart';

class FlahCardScreen extends StatefulWidget {
  const FlahCardScreen({Key? key}) : super(key: key);

  @override
  State<FlahCardScreen> createState() => _FlahCardScreenState();
}

class _FlahCardScreenState extends State<FlahCardScreen> {
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
                      "Manual Mode",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Flash Cards",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 10),
          
              ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  StreamBuilder<dynamic>(
          
                      stream: firestore.collection("exams").snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<ExamModel> exams = snapshot.data!.docs
                              .map<ExamModel>((e) => ExamModel.fromJson(e))
                              .toList();
                          return StreamBuilder<dynamic>(
                              stream: firestore
                                  .collection(
                                  "flashCardChapters")
                                  .where("examId",
                                  isEqualTo:
                                  exams[0].id)
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
                                  return   GridView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: 0.9,
                                    ),
                                    itemCount: chapters.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return  Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.greyColor.withOpacity(0.4)),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: AssetImage('assets/images/Rectangle 907.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  chapters[index].name,
                                                  style: TextStyle(
                                                    fontSize: 18, // Adjust as needed
                                                   // fontWeight: FontWeight.bold,
                                                    color: Colors.black, // Change to match your design
                                                  ),
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Text(
                                                  "Total Questions:  ${snapshot.hasData ? snapshot.data.docs.length : 0}/${chapters[index].totalQuestions == 0 ? 1 : chapters[index].totalQuestions}",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Spacer(),
                                                Icon(Icons.refresh)
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: LinearProgressIndicator(
                                                      value: (chapters[index].totalQuestions / 100),
                                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                                        AppColors.darkGreenColor,
                                                      ),
                                                      backgroundColor: AppColors.lightGreyColor,
                                                      minHeight: 8,
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: AppColors.darkGreenColor,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 0),
                                                        child: Center(
                                                          child: Text(
                                                            "Start",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return const Loading(
                                    text: "Loading Summary",
                                  ).paddingT(20);
                                }
                              });
          
                        } else {
                          return const Loading();
                        }
                      }).paddingHrz(10),
                ],
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
//
// class ManualWidget extends StatelessWidget {
//   const ManualWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         border: Border.all(color: AppColors.greyColor.withOpacity(0.4)),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 100,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               image: DecorationImage(
//                 image: AssetImage('assets/images/Rectangle 929.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Center(
//               child: Text(
//                 'Chapter Name',
//                 // style: TextStyle(
//                 //   fontSize: 24, // Adjust as needed
//                 //   fontWeight: FontWeight.bold,
//                 //   color: Colors.white, // Change to match your design
//                 // ),
//               ),
//             ),
//           ),
//
//           SizedBox(height: 5),
//           Row(
//             children: [
//               Text(
//                 "Total Questions: 93/100",
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Spacer(),
//               Icon(Icons.refresh)
//             ],
//           ),
//           SizedBox(height: 10),
//           Expanded(
//             child: Column(
//               children: [
//                 Container(
//                   child: LinearProgressIndicator(
//                     value: (40 / 100),
//                     valueColor: const AlwaysStoppedAnimation<Color>(
//                       AppColors.darkGreenColor,
//                     ),
//                     backgroundColor: AppColors.lightGreyColor,
//                     minHeight: 8,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: AppColors.darkGreenColor,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 0),
//                       child: Center(
//                         child: Text(
//                           "Start",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
