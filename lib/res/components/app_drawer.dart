import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60, // Set the width of the drawer to limit it to icon size
      color: AppColors.kWhite, // Set a background color for the sidebar
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: AppColors.greyColor),
            onPressed: () {
              // Replace with actual navigation
              // Get.to(() => HomeScreen());
            },
          ),
          IconButton(
            icon: const Icon(Icons.shop, color: AppColors.greyColor),
            onPressed: () {
              // Replace with actual navigation
              // Get.to(() => ShopScreen());
            },
          ),
          IconButton(
            icon: const Icon(Icons.school, color: AppColors.greyColor),
            onPressed: () {
              // Replace with actual navigation
              // Get.to(() => StudyScreen());
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.greyColor),
            onPressed: () {
              // Replace with actual navigation
              // Get.to(() => UserProfileScreen());
            },
          ),
        ],
      ),
    );
  }
}
