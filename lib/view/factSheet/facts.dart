import 'package:flutter/material.dart';
import 'package:future_green_world/res/components/loading.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../res/colors/app_colors.dart';
import '../../res/components/custom_safe_area.dart';
import '../../res/controller/controller_instances.dart';
import '../../res/fonts/app_fonts.dart';

class FactsScreen extends StatelessWidget {
  const FactsScreen({super.key, required this.examId});
  final String examId;

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        backgroundColor: themeController.isDarkMode
            ? DarkModeColors.kBodyColor
            : AppColors.kWhite,
        appBar: AppBar(
          backgroundColor: themeController.isDarkMode
              ? DarkModeColors.kAppBarColor
              : AppColors.kWhite,
          elevation: 0,
          title: Text(
            "Fact Sheet",
            style: TextStyle(
              fontFamily: AppFonts.poppinsBold,
              color: themeController.isDarkMode
                  ? DarkModeColors.kWhite
                  : AppColors.kBlack,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: themeController.isDarkMode
                    ? DarkModeColors.kWhite
                    : AppColors.kBlack.withOpacity(0.7),
              )),
        ),
        body: FutureBuilder<dynamic>(
            future: firestore.collection("factSheets").doc(examId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SfPdfViewer.network(
                   snapshot.data["url"],
                  enableTextSelection: false,
                );
              } else {
                return const Center(child: Loading());
              }
            }),
      ),
    );
  }
}
