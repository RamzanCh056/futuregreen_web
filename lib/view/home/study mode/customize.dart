
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:timeline_tile/timeline_tile.dart';
// ;

// class CustomizedScreen1 extends StatelessWidget {
//   const CustomizedScreen1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<Chapters> exercises = [
//       Chapters(
//         name: 'Chapter 1',
//         totalQuestions: 52,
//         isCompleted: true,
//       ),
//       Chapters(
//         name: 'Chapter 2',
//         totalQuestions: 50,
//         isCompleted: false,
//       ),
//       Chapters(
//         name: 'Chapter 3',
//         totalQuestions: 90,
//         isCompleted: false,
//       ),
//       Chapters(
//         name: 'Chapter 4',
//         totalQuestions: 20,
//         isCompleted: false,
//       ),
//       Chapters(
//         name: 'Chapter 5',
//         totalQuestions: 20,
//         isCompleted: false,
//       ),
//     ];

//     final width = MediaQuery.sizeOf(context).width;
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child:
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: const Icon(Icons.arrow_back_ios),
//                   ),
//                   Text(
//                     "Customized Study",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Customized Study",
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     "CFA ESG Investings",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Container(
//                     margin: EdgeInsets.only(top: 15),
//                     decoration: BoxDecoration(
//                       color: AppColors.lightBlue,
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           vertical: 15, horizontal: 10),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: AppColors.lightBlue,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(6),
//                               child: Image.asset(
//                                 'assets/icons/calender.png',
//                                 height: 40,
//                                 width: 40,
//                                 color: Colors.blue.shade800,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Estimated to complete',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Text(
//                                 '30 July 2024',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Row(
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Initial Assessment',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               'Mock Exam A',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Spacer(),
//                         SizedBox(
//                           width: width * 0.2 - 10,
//                           height: width * 0.2 - 10,
//                           child: Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               SfCircularChart(
//                                 series: <CircularSeries>[
//                                   RadialBarSeries<ChartData, String>(
//                                     innerRadius: '80%',
//                                     maximumValue: 100,
//                                     radius: '90%',
//                                     cornerStyle: CornerStyle.bothCurve,
//                                     pointColorMapper: (ChartData data, _) =>
//                                     data.color,
//                                     dataSource: [
//                                       ChartData(
//                                         "",
//                                         60,
//                                         AppColors.darkGreenColor,
//                                       ),
//                                     ],
//                                     xValueMapper: (ChartData data, _) => data.x,
//                                     yValueMapper: (ChartData data, _) => data.y,
//                                   ),
//                                 ],
//                               ),
//                               Text(
//                                 "60%",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   StreamBuilder<dynamic>(

//                       stream: firestore.collection("exams").snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           List<ExamModel> exams = snapshot.data!.docs
//                               .map<ExamModel>((e) => ExamModel.fromJson(e))
//                               .toList();
//                           return StreamBuilder<dynamic>(
//                               stream: firestore
//                                   .collection(
//                                   "chapters")
//                                   .where("examId",
//                                   isEqualTo:
//                                   exams[0].id)
//                                   .orderBy("no")
//                                   .snapshots(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   List<ChapterModel>
//                                   chapters = snapshot
//                                       .data!.docs
//                                       .map<ChapterModel>(
//                                           (e) => ChapterModel
//                                           .fromJson(
//                                           e))
//                                       .toList();
//                                   return   ListView.builder(
//                                     shrinkWrap: true,
//                                     itemCount: chapters.length,
//                                     physics: const NeverScrollableScrollPhysics(),
//                                     itemBuilder: (context, index) {
//                                       return Padding(
//                                         padding: const EdgeInsets.only(top: 10.0),
//                                         child: CustomTimelineTile(
//                                           isFirst: index == 0,
//                                           isLast: index == chapters.length - 1,
//                                           chapters: chapters[index].name,
//                                           totalQuestions:chapters[index].totalQuestions,
//                                         ),
//                                       );
//                                     },
//                                   );
//                                 } else {
//                                   return const Loading(
//                                     text: "Loading Summary",
//                                   ).paddingT(20);
//                                 }
//                               });

//                         } else {
//                           return const Loading();
//                         }
//                       }),
//                   // Column(
//                   //   crossAxisAlignment: CrossAxisAlignment.center,
//                   //   children: [
//                   //
//                   //
//                   //
//                   //     SizedBox(
//                   //       height: 580,
//                   //       child: ListView.builder(
//                   //         itemCount: exercises.length,
//                   //         physics: const NeverScrollableScrollPhysics(),
//                   //         itemBuilder: (context, index) {
//                   //           return Padding(
//                   //             padding: const EdgeInsets.only(top: 10.0),
//                   //             child: CustomTimelineTile(
//                   //               isFirst: index == 0,
//                   //               isLast: index == exercises.length - 1,
//                   //               chapters: exercises[index],
//                   //             ),
//                   //           );
//                   //         },
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                 ],
//               ),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// class CustomTimelineTile extends StatelessWidget {
//   final bool isFirst;
//   final bool isLast;
//   final String chapters;
//   final int totalQuestions;

//   const CustomTimelineTile({
//     super.key,
//     required this.isFirst,
//     required this.isLast,
//     required this.chapters,
//     required this.totalQuestions,
//   });

//   String getImagePath(String chapterName, bool isCompleted) {
//     switch (chapterName) {
//       case 'Chapter 1':
//         return isCompleted
//             ? 'assets/icons/time_line_finished.png'
//             : 'assets/icons/chapter01.png';
//       case 'Chapter 2':
//         return isCompleted
//             ? 'assets/icons/time_line_finished.png'
//             : 'assets/icons/chapter02.png';
//       case 'Chapter 3':
//         return isCompleted
//             ? 'assets/icons/time_line_finished.png'
//             : 'assets/icons/chapter03.png';
//       case 'Chapter 4':
//         return isCompleted
//             ? 'assets/icons/time_line_finished.png'
//             : 'assets/icons/chapter03.png';
//       case 'Chapter 5':
//         return isCompleted
//             ? 'assets/icons/time_line_finished.png'
//             : 'assets/icons/chapter01.png';
//       case 'Chapter 6':
//         return isCompleted
//             ? 'assets/icons/time_line_finished.png'
//             : 'assets/icons/chapter01.png';
//       case 'Chapter 7':
//         return isCompleted
//             ? 'assets/icons/time_line_finished.png'
//             : 'assets/icons/chapter01.png';
//       case 'Chapter 8':
//         return isCompleted
//             ? 'assets/icons/time_line_finished.png'
//             : 'assets/icons/chapter01.png';
//       case 'Chapter 9':
//         return isCompleted
//             ? 'assets/icons/time_line_finished.png'
//             : 'assets/icons/chapter01.png';
//       case 'Chapter 10':
//         return isCompleted
//             ? 'assets/icons/time_line_finished.png'
//             : 'assets/icons/chapter01.png';
//       default:
//         return '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(left: 8, bottom: 8, top: 8),
//       child: TimelineTile(
//         isFirst: isFirst,
//         isLast: isLast,
//         indicatorStyle: IndicatorStyle(
//             width: 35,
//             height: 35,
//             color:
//             //chapters.isCompleted ?
//            // Colors.green ,
//                  Colors.grey,
//             indicator: Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color:
//                 //  chapters.isCompleted ?
//                  // Colors.green :
//                   Colors.grey,
//                 ),
//                 child: Row(
//                   children: [
//                     Image.asset(
//                      "assets/icons/time_line_finished.png"
//                     ),
//                   ],
//                 ))),
//         afterLineStyle: LineStyle(
//           thickness: 5,
//           color:
//          // chapters ?
//           Colors.green ,
//          // Colors.grey,
//         ),
//         beforeLineStyle: LineStyle(
//           thickness: 5,
//           color:
//         //  chapters.isCompleted ?
//           Colors.green ,
//           //Colors.grey,
//         ),
//         endChild:Container(
//           padding: EdgeInsets.only(top: 10, right: 10),
//           child: Row(
//             children: [
//               SizedBox(width: 8),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     chapters,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   SizedBox(height: 3),
//                   Text(
//                     'Total Questions: ${totalQuestions}',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//               Spacer(),
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                 decoration: BoxDecoration(
//                   color: AppColors.greyColor.withOpacity(0.4),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Image.asset(
//                       'assets/icons/lock.png',
//                       height: 20,
//                       width: 20,
//                     ),
//                     SizedBox(width: 5),
//                     Text(
//                       'Locked',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w800,
//                         color: AppColors.greyColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ChaptersCard extends StatelessWidget {
//   final Chapters chapter;

//   const ChaptersCard({super.key, required this.chapter});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(top: 10, right: 10),
//       child: Row(
//         children: [
//           SizedBox(width: 8),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 chapter.name,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               SizedBox(height: 3),
//               Text(
//                 'Total Questions: ${chapter.totalQuestions}',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ],
//           ),
//           Spacer(),
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//             decoration: BoxDecoration(
//               color: AppColors.greyColor.withOpacity(0.4),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.asset(
//                   'assets/icons/lock.png',
//                   height: 20,
//                   width: 20,
//                 ),
//                 SizedBox(width: 5),
//                 Text(
//                   'Locked',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w800,
//                     color: AppColors.greyColor,
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

// class Chapters {
//   final String name;
//   final int totalQuestions;
//   bool isCompleted;

//   Chapters({
//     required this.name,
//     required this.totalQuestions,
//     this.isCompleted = false,
//   });
// }
