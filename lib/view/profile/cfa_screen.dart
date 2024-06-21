
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/view/profile/mockExam.dart';
import 'package:future_green_world/view/profile/profile_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../flashCards/flash card.dart';
import 'chapter_screen.dart';



class CfaScreen extends StatelessWidget {
  const CfaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
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
                    "CFA ESG Investing",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: width * 0.32 - 10,
                  height: width * 0.32 - 10,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SfCircularChart(
                        series: <CircularSeries>[
                          RadialBarSeries<ChartData, String>(
                            innerRadius: '80%',
                            maximumValue: 1155,
                            radius: '90%',
                            cornerStyle: CornerStyle.bothCurve,
                            pointColorMapper: (ChartData data, _) => data.color,
                            dataSource: [
                              ChartData(
                                "",
                                110,
                                AppColors.darkGreenColor,
                              ),
                            ],
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                          ),
                        ],
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "110/ 1155",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "Questions",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: width * 0.32 - 10,
                  height: width * 0.32 - 10,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SfCircularChart(
                        series: <CircularSeries>[
                          RadialBarSeries<ChartData, String>(
                            innerRadius: '80%',
                            maximumValue: 100,
                            radius: '90%',
                            cornerStyle: CornerStyle.bothCurve,
                            pointColorMapper: (ChartData data, _) => data.color,
                            dataSource: [
                              ChartData(
                                "",
                                60,
                                AppColors.darkGreenColor,
                              ),
                            ],
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                          ),
                        ],
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "60%",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12
                            ),
                          ),
                          Text(
                            "Score",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: width * 0.32 - 10,
                  height: width * 0.32 - 10,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SfCircularChart(
                        series: <CircularSeries>[
                          RadialBarSeries<ChartData, String>(
                            innerRadius: '80%',
                            maximumValue: 100,
                            radius: '90%',
                            cornerStyle: CornerStyle.bothCurve,
                            pointColorMapper: (ChartData data, _) => data.color,
                            dataSource: [
                              ChartData(
                                "",
                                50,
                                AppColors.darkGreenColor,
                              ),
                            ],
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                          ),
                        ],
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "50/100",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "Practice",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            for (final cat in categories)
              GestureDetector(
                onTap: () {
                  if (cat['title'] == 'Mock Exam') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MockExam()));
                  }
                  if(      cat["title"] =="Flash Card"){
                    print("object");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FlahCardScreen()));

                  }
                  if(      cat["title"] =="Chapters"){
                    print("object");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChapterScreenLession()));

                  }

                },
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(10),
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
                  child: Row(
                    children: [
                      Image.asset(
                        height: 50,
                        "${cat["image"]}",
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${cat["title"]}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: ((cat["progress"] as int) / 100),
                                    valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                      AppColors.darkGreenColor,
                                    ),
                                    backgroundColor: AppColors.lightGreyColor,
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "${cat["progress"]}%",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            GestureDetector(
              // onTap: () {
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => Settings()));
              // },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(10),
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
                child: Row(
                  children: [
                    Image.asset(
                      "assets/icons/image 3.png",
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final categories = [
  {
    "image": "assets/icons/Chapter.png",
    "title": "Chapters",
    "progress": 30,
  },
  {
    "image": "assets/icons/exam.png",
    "title": "Mock Exam",
    "progress": 70,
  },
  {
    "image": "assets/icons/flash card.png",
    "title": "Flash Card",
    "progress": 60,
  }
];
