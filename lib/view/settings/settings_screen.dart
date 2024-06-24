import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_green_world/main.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/custom_safe_area.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:future_green_world/view/profile/profile_screen.dart';
import 'package:future_green_world/view/settings/delete_account.dart';
import 'package:future_green_world/view/settings/fav_flash_cards.dart';
import 'package:future_green_world/view/settings/questions_visibility.dart';
import 'package:future_green_world/view/settings/update_practice_question_count.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../res/components/custom_pop_up.dart';
import '../../res/controller/controller_instances.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
  bool _switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: themeController.isDarkMode
      ? DarkModeColors.kBodyColor
      : AppColors.kWhite,
          appBar: AppBar(
    backgroundColor: themeController.isDarkMode
        ? DarkModeColors.kAppBarColor
        : AppColors.kWhite,
    elevation: 5,
    title: Text(
      'Settings',
      style: TextStyle(
          fontFamily: AppFonts.poppinsBold,
          color: themeController.isDarkMode
              ? DarkModeColors.kWhite
              : AppColors.kBlack),
    ),
    centerTitle: true,
          ),
          body: ListView(
    children: [
      // (Get.height * 0.02).heightBox,
      //
      // Container(
      //   padding: const EdgeInsets.symmetric(horizontal: 10),
      //   child: Row(
      //     children: [
      //       IconButton(
      //         onPressed: () {
      //           Navigator.pop(context);
      //         },
      //         icon: const Icon(Icons.arrow_back_ios),
      //       ),
      //       Text(
      //         "Settings",
      //         style: TextStyle(
      //             fontFamily: AppFonts.poppinsBold,
      //             color: themeController.isDarkMode
      //                 ? DarkModeColors.kWhite
      //                 : AppColors.kBlack),
      //       ),
      //     ],
      //   ),
      // ),
      //  SizedBox(height: GetHeight(20).h),
      Container(
        height: 1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
      // SizedBox(height: GetHeight(20).h),
      GestureDetector(
        onTap: () {
          Get.to(() => ProfileScreen(
                    name: userName.value,
                  ))!
              .then((value) {
            setState(() {
              getUser();
            });
          });
        },
        child: Container(
          //padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Image.asset(
                'assets/images/Avatar.png',
                width: 70,
                height: 70,
              ),
            ),
            title: Text(
              userName.value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.poppinsMedium,
                fontSize: 20,
                color: themeController.isDarkMode
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            subtitle: Text(
              "Opportunities don't happen, you....",
              style: TextStyle(
                  //  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyColor),
            ),
          ),
        ),
      ),
      // GestureDetector(
      //   onTap: () {
      //     Get.to(() => ProfileScreen(
      //               name: userName.value,
      //             ))!
      //         .then((value) {
      //       setState(() {
      //         getUser();
      //       });
      //     });
      //   },
      //   child: Container(
      //     height: Get.height / 6,
      //     margin: const EdgeInsets.only(bottom: 20),
      //     decoration: BoxDecoration(
      //       color: AppColors.kPrimary,
      //       borderRadius: BorderRadius.circular(16),
      //     ),
      //     child: Stack(
      //       children: [
      //         Align(
      //           alignment: Alignment.bottomLeft,
      //           child: CircleAvatar(
      //             radius: 100,
      //             backgroundColor: AppColors.kWhite.withOpacity(.1),
      //           ),
      //         ),
      //         Align(
      //           alignment: Alignment.center,
      //           child: CircleAvatar(
      //             radius: 400,
      //             backgroundColor: AppColors.kWhite.withOpacity(.05),
      //           ),
      //         ),
      //         Container(
      //           margin: const EdgeInsets.all(10),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Row(
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                 children: [
      //                   Obx(() {
      //                     return CircleAvatar(
      //                       radius: Get.height / 22,
      //                       backgroundColor: AppColors.kWhite,
      //                       child: Text(
      //                         userName.value[0].toUpperCase(),
      //                         style: const TextStyle(
      //                             fontWeight: FontWeight.bold,
      //                             fontSize: 35,
      //                             color: AppColors.kPrimary,
      //                             fontFamily: AppFonts.poppinsMedium),
      //                       ).center,
      //                     );
      //                   }),
      //                   15.widthBox,
      //                   Obx(() {
      //                     return Expanded(
      //                       child: Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           AutoSizeText(
      //                             userName.value,
      //                             maxLines: 1,
      //                             overflow: TextOverflow.ellipsis,
      //                             style: const TextStyle(
      //                               fontWeight: FontWeight.bold,
      //                               fontFamily: AppFonts.poppinsMedium,
      //                               fontSize: 25,
      //                               color: Colors.white,
      //                             ),
      //                           ).flexible,
      //                           AutoSizeText(
      //                             userEmail.value,
      //                             maxLines: 1,
      //                             overflow: TextOverflow.ellipsis,
      //                             style: const TextStyle(
      //                                 fontSize: 16,
      //                                 color: Colors.white,
      //                                 fontFamily: AppFonts.poppinsRegular),
      //                           ),
      //                         ],
      //                       ),
      //                     );
      //                   }),
      //                 ],
      //               ).flexible,
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),


      Container(
         // padding: EdgeInsets.symmetric(horizontal: GetWidth(20).w),
          child: const Divider()),
      GestureDetector(
        onTap:
            () {
              Get.bottomSheet(
                const UpdatePracticeQuestionsCount(),
                backgroundColor: themeController.isDarkMode
                    ? DarkModeColors.kBodyColor
                    : AppColors.kWhite,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
              ).then((value) {
                setState(() {});
              });
        },
        child:  SettingsWidget(
          imageUrl: 'assets/icons/practice_questions.png',
          title: "Practice Questions",
          subtitle: sharedPreferences!.getInt("questionsCount") ==
              null
              ? "50"
              : sharedPreferences!
              .getInt("questionsCount")
              .toString(),
        ),
      ),
      GestureDetector(
        onTap: () {
          Get.bottomSheet(
            const QuestionsVisibility(),
            backgroundColor: themeController.isDarkMode
                ? DarkModeColors.kBodyColor
                : AppColors.kWhite,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
          ).then((value) {
            setState(() {});
          });
          //showUnsolvedOnly(context);
        },
        child:  SettingsWidget(
          imageUrl: 'assets/icons/questions_visibility.png',
          title: "Questions Visibility",
          subtitle:  sharedPreferences!
              .getString("questionsVisibility") ==
              null
              ? "Show Unsolved Only"
              : sharedPreferences!
              .getString("questionsVisibility")
              .toString(),
        ),
      ),
      GestureDetector(
        onTap: () {
          Get.to(() => const FavouriteFlashCardScreen());
        },
        child:  SettingsWidget(
          imageUrl: 'assets/icons/questions_visibility.png',
          title: "Flash Card",
          subtitle: 'Favourites',
        ),
      ),
      Container(
      //  padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            child: Image.asset(
              'assets/icons/dark_mode.png',
              width: 40,
              height: 40,
            ),
          ),
          title: Text(
            "Dark Mode",
            style: TextStyle(
             // fontSize: 14.sp,
              fontWeight: FontWeight.w700,
                color: themeController.isDarkMode
                                    ? DarkModeColors.kWhite
                                    : AppColors.kBlack,
            ),
          ),
          subtitle: Text(
            themeController.isDarkMode
                ? "Enabled"
                : "Disabled",
            style: TextStyle(
               // fontSize: 12.sp,
                fontWeight: FontWeight.w600,
          color: themeController.isDarkMode
                                      ? DarkModeColors.kWhite
                                      :
                AppColors.greyColor),
          ),
          trailing: CupertinoSwitch(
            value: _switchValue,
            onChanged: (value) {
              setState(() {
                _switchValue = value;
                print("$value");
                themeController.toggleDarkMode();
              });
            },
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const BookMarks()));
        },
        child: const SettingsWidget(
          imageUrl: 'assets/icons/bookmark.png',
          title: "Bookmarks",
          subtitle: 'Favorite',
        ),
      ),
      GestureDetector(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const StudyMode()));
        },
        child: const SettingsWidget(
          imageUrl: 'assets/icons/practice_questions.png',
          title: "Study mode :",
          subtitle: '',
        ),
      ),
      GestureDetector(
        onTap: (){
          showCustomPopUp(
              context,
              "Logout",
              "Are you sure to logout?",
              "Cancel",
              AppColors.kGreen,
              "Logout",
              AppColors.kRed,
                  () => authController.signOut());
        },
        child: const SettingsWidget(

          imageUrl: 'assets/icons/log_out.png',
          title: "Log Out",
          subtitle: '',
        ),
      ),
      GestureDetector(
      onTap: (){
        Get.to(() => const DeleteAccountScreen());
      },
        child: const SettingsWidget(
          imageUrl: 'assets/icons/delete_account.png',
          title: "Delete Account",
          subtitle: '',
        ),
      ),
      // Container(
      //   margin: const EdgeInsets.only(bottom: 20),
      //   decoration: BoxDecoration(
      //       color: themeController.isDarkMode
      //           ? DarkModeColors.kAppBarColor
      //           : AppColors.kPrimary.withOpacity(0.15),
      //       borderRadius: BorderRadius.circular(16)),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       ListView.separated(
      //         separatorBuilder: (context, index) {
      //           return Divider(
      //             color: AppColors.kBlack.withOpacity(0.4),
      //           );
      //         },
      //         itemCount: 4,
      //         itemBuilder: (BuildContext context, int index) {
      //           if (index == 0) {
      //             return settingsItem(
      //                 icon: Icons.numbers,
      //                 iconBackground: AppColors.kYellowColor,
      //                 title: "Practice Questions",
      //                 subTitle:
      //                     sharedPreferences!.getInt("questionsCount") ==
      //                             null
      //                         ? "50"
      //                         : sharedPreferences!
      //                             .getInt("questionsCount")
      //                             .toString(),
      //                 trailing: Icon(
      //                   Icons.navigate_next,
      //                   size: 20,
      //                   color: themeController.isDarkMode
      //                       ? DarkModeColors.kWhite
      //                       : AppColors.kBlack,
      //                 ),
      //                 onTap: () => Get.bottomSheet(
      //                       const UpdatePracticeQuestionsCount(),
      //                       backgroundColor: themeController.isDarkMode
      //                           ? DarkModeColors.kBodyColor
      //                           : AppColors.kWhite,
      //                       isScrollControlled: true,
      //                       shape: const RoundedRectangleBorder(
      //                           borderRadius: BorderRadius.only(
      //                               topLeft: Radius.circular(30),
      //                               topRight: Radius.circular(30))),
      //                     ).then((value) {
      //                       setState(() {});
      //                     }));
      //           } else if (index == 1) {
      //             return settingsItem(
      //                 icon: Icons.preview,
      //                 iconBackground: AppColors.kLinkedinColor,
      //                 title: "Questions Visibility",
      //                 subTitle: sharedPreferences!
      //                             .getString("questionsVisibility") ==
      //                         null
      //                     ? "Show Unsolved Only"
      //                     : sharedPreferences!
      //                         .getString("questionsVisibility")
      //                         .toString(),
      //                 trailing: Icon(
      //                   Icons.navigate_next,
      //                   size: 20,
      //                   color: themeController.isDarkMode
      //                       ? DarkModeColors.kWhite
      //                       : AppColors.kBlack,
      //                 ),
      //                 onTap: () => Get.bottomSheet(
      //                       const QuestionsVisibility(),
      //                       backgroundColor: themeController.isDarkMode
      //                           ? DarkModeColors.kBodyColor
      //                           : AppColors.kWhite,
      //                       isScrollControlled: true,
      //                       shape: const RoundedRectangleBorder(
      //                           borderRadius: BorderRadius.only(
      //                               topLeft: Radius.circular(30),
      //                               topRight: Radius.circular(30))),
      //                     ).then((value) {
      //                       setState(() {});
      //                     }));
      //           } else if (index == 2) {
      //             return settingsItem(
      //                 icon: themeController.isDarkMode
      //                     ? Icons.dark_mode
      //                     : Icons.light_mode,
      //                 iconBackground: AppColors.kRed,
      //                 title: "Dark Mode",
      //                 subTitle: themeController.isDarkMode
      //                     ? "Enabled"
      //                     : "Disabled",
      //                 trailing: Icon(
      //                   themeController.isDarkMode
      //                       ? Icons.toggle_on
      //                       : Icons.toggle_off,
      //                   color: themeController.isDarkMode
      //                       ? DarkModeColors.kWhite
      //                       : AppColors.kBlack,
      //                 ),
      //                 onTap: () {
      //                   themeController.toggleDarkMode();
      //                 });
      //           } else {
      //             return settingsItem(
      //                 icon: Icons.favorite,
      //                 iconBackground: Ex.blue400,
      //                 title: "Flash Cards",
      //                 subTitle: "Favourites",
      //                 trailing: Icon(
      //                   Icons.navigate_next,
      //                   size: 20,
      //                   color: themeController.isDarkMode
      //                       ? DarkModeColors.kWhite
      //                       : AppColors.kBlack,
      //                 ),
      //                 onTap: () =>
      //                     Get.to(() => const FavouriteFlashCardScreen()));
      //           }
      //         },
      //         shrinkWrap: true,
      //         padding: EdgeInsets.zero,
      //         physics: const ScrollPhysics(),
      //       ),
      //     ],
      //   ),
      // ),
      // Container(
      //   margin: const EdgeInsets.only(bottom: 20),
      //   decoration: BoxDecoration(
      //       color: themeController.isDarkMode
      //           ? DarkModeColors.kAppBarColor
      //           : AppColors.kPrimary.withOpacity(0.15),
      //       borderRadius: BorderRadius.circular(16)),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       ListView.separated(
      //         separatorBuilder: (context, index) {
      //           return Divider(
      //             color: AppColors.kBlack.withOpacity(0.4),
      //           );
      //         },
      //         itemCount: 2,
      //         itemBuilder: (BuildContext context, int index) {
      //           if (index == 0) {
      //             return settingsItem(
      //                 icon: Icons.delete_outline,
      //                 title: "Delete Account",
      //                 trailing: Icon(
      //                   Icons.navigate_next,
      //                   size: 20,
      //                   color: themeController.isDarkMode
      //                       ? DarkModeColors.kWhite
      //                       : AppColors.kBlack,
      //                 ),
      //                 onTap: () {
      //                   Get.to(() => const DeleteAccountScreen());
      //                 });
      //           } else {
      //             return settingsItem(
      //                 icon: Icons.exit_to_app_outlined,
      //                 title: "Logout",
      //                 trailing: Icon(
      //                   Icons.navigate_next,
      //                   size: 20,
      //                   color: themeController.isDarkMode
      //                       ? DarkModeColors.kWhite
      //                       : AppColors.kBlack,
      //                 ),
      //                 onTap: () {
      //                   showCustomPopUp(
      //                       context,
      //                       "Logout",
      //                       "Are you sure to logout?",
      //                       "Cancel",
      //                       AppColors.kGreen,
      //                       "Logout",
      //                       AppColors.kRed,
      //                       () => authController.signOut());
      //                 });
      //           }
      //         },
      //         shrinkWrap: true,
      //         padding: EdgeInsets.zero,
      //         physics: const ScrollPhysics(),
      //       ),
      //     ],
      //   ),
      // ),
    ],
          ).paddingHrz(15),
        );
  }

  ClipRRect settingsItem(
      {required IconData icon,
      Color? iconBackground,
      required String title,
      String? subTitle,
      required Widget trailing,
      required Function() onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ListTile(
        onTap: onTap,
        leading: iconBackground != null
            ? Container(
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(5),
                child: Icon(
                  icon,
                  size: 25,
                  color: AppColors.kWhite,
                ),
              )
            : Icon(
                icon,
                size: 24,
                color: themeController.isDarkMode
                    ? DarkModeColors.kWhite
                    : AppColors.kBlack,
              ),
        title: Text(
          title,
          style: TextStyle(
              color: themeController.isDarkMode
                  ? DarkModeColors.kWhite
                  : AppColors.kBlack,
              fontFamily: AppFonts.poppinsRegular,
              fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subTitle != null
            ? Text(
                subTitle,
                style: TextStyle(
                    color: themeController.isDarkMode
                        ? DarkModeColors.kWhite
                        : AppColors.kBlack,
                    fontFamily: AppFonts.poppinsLight,
                    fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}

class SettingsWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const SettingsWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
     // padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          child: Image.asset(
            // 'assets/icons/practice_questions.png',
            imageUrl,
            width: 40,
            height: 40,
          ),
        ),
        title: Text(
          // "Practice Questions",
          title,
          style: TextStyle(
            //fontSize: 14.sp,
            fontWeight: FontWeight.w700,
              color: themeController.isDarkMode
                                  ? DarkModeColors.kWhite
                                  : AppColors.kBlack,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
             /// fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: themeController.isDarkMode
                                    ? DarkModeColors.kWhite
                                    :
              AppColors.greyColor),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }
}

void showPracticeQuestionsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: GetWidth(15).w),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.darkGreenColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Practice Questions",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "50",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(

                    child: Container(
                      width: GetWidth(126).w,
                      decoration: BoxDecoration(
                        color: AppColors.darkGreenColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(

                    child: Container(
                      width: GetWidth(126).w,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

void showUnsolvedOnly(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: GetWidth(15).w),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.darkGreenColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Show Unsolved Only",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Show All",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGreenColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
