import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/controller/controller_instances.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:get/get.dart';

import '../flashCards/flash card.dart';
import '../profile/chapter_screen.dart';
import '../profile/mockExam.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userName = "Name...".obs;
  var userEmail = "Email...".obs;
  void getUser() {
    firestore
        .collection("users")
        .doc(authController.getCurrentUser())
        .get()
        .then((user) {
      userEmail.value = user["email"];
      userName.value = user["name"];
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Obx(() {
                      return CircleAvatar(
                        radius: Get.height / 22,
                        backgroundColor: AppColors.greyColor.withOpacity(0.2),
                        child: Text(
                          userName.value[0].toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: AppColors.kPrimary,
                              fontFamily: AppFonts.poppinsMedium),
                        ).center,
                      );
                    }),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome Back, ${userName.value.toUpperCase()}'),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/time.png',
                                  height: 16,
                                  width: 16,
                                ),
                                const SizedBox(width: 2),
                                const Text(
                                  '25 Mins',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/flame_color.png',
                                  height: 16,
                                  width: 16,
                                ),
                                const SizedBox(width: 2),
                                const Text(
                                  '2 Days',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/certificate.png',
                                  height: 16,
                                  width: 16,
                                ),
                                const SizedBox(width: 2),
                                const Text(
                                  '1 Certificate',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "CFA ESG Investing",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_upward_sharp,
                                size: 14,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: (30 / 100),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    AppColors.darkGreenColor,
                                  ),
                                  backgroundColor: AppColors.lightGreyColor,
                                  minHeight: 15,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Image.asset(
                                'assets/icons/Medal.png',
                                height: 24,
                                width: 24,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              for (final cat in categories)
                GestureDetector(
                  onTap: () {
                    if(      cat["title"] =="Mock Exam"){
                      print("object");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MockExam()));

                    } if(      cat["title"] =="Flash Card"){
                      print("object");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FlahCardScreen()));

                    }
                    if(      cat["title"] =="Chapters"){
                      print("object");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChapterScreenLession()));

                    }

                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                          "${cat["image"]}",
                          height: 40,
                          width: 40,
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
            ],
          ),
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
    "image": "assets/icons/practice_exam.png",
    "title": "Practice Exam",
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
  },
  {
    "image": "assets/icons/study note.png",
    "title": "Study Note",
    "progress": 60,
  },
  {
    "image": "assets/icons/fact_icon.png",
   // "image": "assets/icons/Facts.png",
    "title": "Fact Sheet",
    "progress": 60,
  },
];
