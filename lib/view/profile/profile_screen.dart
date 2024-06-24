// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:future_green_world/res/colors/app_colors.dart';
// import 'package:future_green_world/res/components/extensions.dart';
// import 'package:future_green_world/res/controller/controller_instances.dart';
// import 'package:future_green_world/res/fonts/app_fonts.dart';
// import 'package:future_green_world/view/profile/cfa_screen.dart';
// import 'package:future_green_world/view_model/controller/profile/profile_view_model_controller.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
//
// class ProfileScreen extends StatefulWidget {
//   final String name;
//   const ProfileScreen({super.key, required this.name});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final profileVMController = Get.put(ProfileViewModel());
//   @override
//   void initState() {
//     profileVMController.nameController.value.text = widget.name;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.sizeOf(context).width;
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: GetHeight(20).h),
//               Image.asset(
//                 "assets/images/Avatar.png",
//               ),
//               SizedBox(height: GetHeight(10).h),
//               const Text(
//                 "Albert Flores",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//                SizedBox(height: GetHeight(5).h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "albertflores@mail.com",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   SizedBox(width: GetWidth(5).w),
//                   Icon(
//                     Icons.check_circle_outline_outlined,
//                     size: 18,
//                     color: AppColors.greenColor,
//                   ),
//                 ],
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: GetWidth(40).w, vertical: GetHeight(20).h),
//                 padding: EdgeInsets.symmetric(vertical: GetHeight(10).h),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                     color: AppColors.borderColor,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Edit Profile",
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.greyColor,
//                       ),
//                     ),
//                     SizedBox(width: GetWidth(5).w),
//                     Icon(
//                       Icons.keyboard_arrow_down_sharp,
//                       size: 18,
//                       color: AppColors.greyColor,
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: GetWidth(20).w),
//                 padding: EdgeInsets.symmetric(vertical: GetHeight(20).h, horizontal: GetWidth(20).w),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.r),
//                   border: Border.all(
//                     color: AppColors.borderColor,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         for (var i = 0; i < weekDays.length; i++)
//                           Column(
//                             children: [
//                               Image.asset(
//                                 "assets/icons/${i == 0 || i == 1 ? "flame_color" : "flame"}.png",
//                                 width: GetWidth(20).w,
//                               ),
//                               Text(
//                                 weekDays[i],
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//                     const Divider(
//                       color: AppColors.borderColor,
//                       thickness: 1,
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           "Strikes",
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const Spacer(),
//                         Image.asset(
//                           "assets/icons/flame_color.png",
//                           width: GetWidth(20).w,
//                         ),
//                         SizedBox(width: GetWidth(5).w),
//                         Text(
//                           "6 Days",
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // SizedBox(height: GetHeight(20).h),
//               // Container(
//               //   margin: EdgeInsets.symmetric(horizontal: GetWidth(10).w),
//               //   padding: EdgeInsets.symmetric(vertical: GetHeight(10).h, horizontal: GetWidth(10).w),
//               //   decoration: BoxDecoration(
//               //     borderRadius: BorderRadius.circular(10.r),
//               //     border: Border.all(
//               //       color: AppColors.borderColor,
//               //     ),
//               //   ),
//               //   child: Column(
//               //     mainAxisSize: MainAxisSize.min,
//               //     children: [
//               //       Row(
//               //         children: [
//               //           Text(
//               //             "CFA ESG Investing",
//               //             style: TextStyle(
//               //               fontSize: 16,
//               //               fontWeight: FontWeight.w700,
//               //             ),
//               //           ),
//               //           const Spacer(),
//               //           InkWell(
//               //             onTap: () {
//               //               Navigator.of(context).push(
//               //                 MaterialPageRoute(
//               //                   builder: (context) => const CfaScreen(),
//               //                 ),
//               //               );
//               //             },
//               //             child: Text(
//               //               "More",
//               //               style: TextStyle(
//               //                 fontSize: 14,
//               //                 fontWeight: FontWeight.w400,
//               //                 color: AppColors.darkGreenColor,
//               //               ),
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//               //       const Divider(
//               //         color: AppColors.borderColor,
//               //         thickness: 1,
//               //       ),
//               //       Row(
//               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //         children: [
//               //           SizedBox(
//               //             width: width * 0.32 - GetWidth(10).w,
//               //             height: width * 0.32 - GetWidth(10).w,
//               //             child: Stack(
//               //               alignment: Alignment.center,
//               //               children: [
//               //                 SfCircularChart(
//               //                   series: <CircularSeries>[
//               //                     RadialBarSeries<ChartData, String>(
//               //                       innerRadius: '80%',
//               //                       maximumValue: 1155,
//               //                       radius: '90%',
//               //                       cornerStyle: CornerStyle.bothCurve,
//               //                       pointColorMapper: (ChartData data, _) =>
//               //                       data.color,
//               //                       dataSource: [
//               //                         ChartData(
//               //                           "",
//               //                           110,
//               //                           AppColors.darkGreenColor,
//               //                         ),
//               //                       ],
//               //                       xValueMapper: (ChartData data, _) => data.x,
//               //                       yValueMapper: (ChartData data, _) => data.y,
//               //                     ),
//               //                   ],
//               //                 ),
//               //                 Column(
//               //                   mainAxisSize: MainAxisSize.min,
//               //                   mainAxisAlignment: MainAxisAlignment.center,
//               //                   children: [
//               //                     Text(
//               //                       "110/ 1155",
//               //                       style: TextStyle(
//               //                         fontWeight: FontWeight.w600,
//               //                         fontSize: 12,
//               //                       ),
//               //                     ),
//               //                     Text(
//               //                       "Questions",
//               //                       style: TextStyle(
//               //                         fontSize: 10,
//               //                         fontWeight: FontWeight.w400,
//               //                       ),
//               //                     ),
//               //                   ],
//               //                 ),
//               //               ],
//               //             ),
//               //           ),
//               //           SizedBox(
//               //             width: width * 0.32 - GetWidth(10).w,
//               //             height: width * 0.32 - GetWidth(10).w,
//               //             child: Stack(
//               //               alignment: Alignment.center,
//               //               children: [
//               //                 SfCircularChart(
//               //                   series: <CircularSeries>[
//               //                     RadialBarSeries<ChartData, String>(
//               //                       innerRadius: '80%',
//               //                       maximumValue: 100,
//               //                       radius: '90%',
//               //                       cornerStyle: CornerStyle.bothCurve,
//               //                       pointColorMapper: (ChartData data, _) =>
//               //                       data.color,
//               //                       dataSource: [
//               //                         ChartData(
//               //                           "",
//               //                           60,
//               //                           AppColors.darkGreenColor,
//               //                         ),
//               //                       ],
//               //                       xValueMapper: (ChartData data, _) => data.x,
//               //                       yValueMapper: (ChartData data, _) => data.y,
//               //                     ),
//               //                   ],
//               //                 ),
//               //                 Column(
//               //                   mainAxisSize: MainAxisSize.min,
//               //                   mainAxisAlignment: MainAxisAlignment.center,
//               //                   children: [
//               //                     Text(
//               //                       "60%",
//               //                       style: TextStyle(
//               //                         fontWeight: FontWeight.w600,
//               //                         fontSize: 12,
//               //                       ),
//               //                     ),
//               //                     Text(
//               //                       "Score",
//               //                       style: TextStyle(
//               //                         fontSize: 10,
//               //                         fontWeight: FontWeight.w400,
//               //                       ),
//               //                     ),
//               //                   ],
//               //                 ),
//               //               ],
//               //             ),
//               //           ),
//               //           SizedBox(
//               //             width: width * 0.32 - GetWidth(10).w,
//               //             height: width * 0.32 - GetWidth(10).w,
//               //             child: Stack(
//               //               alignment: Alignment.center,
//               //               children: [
//               //                 SfCircularChart(
//               //                   series: <CircularSeries>[
//               //                     RadialBarSeries<ChartData, String>(
//               //                       innerRadius: '80%',
//               //                       maximumValue: 100,
//               //                       radius: '90%',
//               //                       cornerStyle: CornerStyle.bothCurve,
//               //                       pointColorMapper: (ChartData data, _) =>
//               //                       data.color,
//               //                       dataSource: [
//               //                         ChartData(
//               //                           "",
//               //                           50,
//               //                           AppColors.darkGreenColor,
//               //                         ),
//               //                       ],
//               //                       xValueMapper: (ChartData data, _) => data.x,
//               //                       yValueMapper: (ChartData data, _) => data.y,
//               //                     ),
//               //                   ],
//               //                 ),
//               //                 Column(
//               //                   mainAxisSize: MainAxisSize.min,
//               //                   mainAxisAlignment: MainAxisAlignment.center,
//               //                   children: [
//               //                     Text(
//               //                       "50/100",
//               //                       style: TextStyle(
//               //                         fontWeight: FontWeight.w600,
//               //                         fontSize: 12,
//               //                       ),
//               //                     ),
//               //                     Text(
//               //                       "Practice",
//               //                       style: TextStyle(
//               //                         fontSize: 10,
//               //                         fontWeight: FontWeight.w400,
//               //                       ),
//               //                     ),
//               //                   ],
//               //                 ),
//               //               ],
//               //             ),
//               //           ),
//               //         ],
//               //       )
//               //     ],
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//
//
//     //   CustomSafeArea(
//     //     child: Scaffold(
//     //   backgroundColor: themeController.isDarkMode
//     //       ? DarkModeColors.kBodyColor
//     //       : AppColors.kWhite,
//     //   appBar: AppBar(
//     //     backgroundColor: themeController.isDarkMode
//     //         ? DarkModeColors.kAppBarColor
//     //         : AppColors.kWhite,
//     //     elevation: 0,
//     //     title: Text(
//     //       "Edit Profile",
//     //       style: TextStyle(
//     //         fontFamily: AppFonts.poppinsBold,
//     //         color: themeController.isDarkMode
//     //             ? DarkModeColors.kWhite
//     //             : AppColors.kBlack,
//     //       ),
//     //     ),
//     //     centerTitle: true,
//     //     leading: IconButton(
//     //         onPressed: () => Get.back(),
//     //         icon: Icon(
//     //           Icons.arrow_back,
//     //           color: themeController.isDarkMode
//     //               ? DarkModeColors.kWhite
//     //               : AppColors.kBlack.withOpacity(0.7),
//     //         )),
//     //   ),
//     //   body: ListView(
//     //     physics: const BouncingScrollPhysics(),
//     //     children: [
//     //       SizedBox(
//     //         height: Get.height * 0.04,
//     //       ),
//     //       CustomTextField(
//     //           controller: profileVMController.nameController.value,
//     //           hintText: 'Your Name',
//     //           labelText: 'Name',
//     //           keyboardType: TextInputType.name,
//     //           textInputAction: TextInputAction.done,
//     //           validator: FieldValidator.required(),
//     //           savedValue: (_) {}),
//     //       SizedBox(
//     //         height: Get.height * 0.04,
//     //       ),
//     //       Row(
//     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //         children: [
//     //           CustomElevatedButton(
//     //             title: 'Cancel',
//     //             buttonColor: AppColors.kGrey,
//     //             onPress: () {
//     //               Get.back();
//     //             },
//     //             width: Get.width * 0.35,
//     //           ),
//     //           CustomElevatedButton(
//     //             title: 'Save',
//     //             onPress: () {
//     //               if (profileVMController.nameController.value.text
//     //                   .trim()
//     //                   .isNotEmpty) {
//     //                 db
//     //                     .updateUser(
//     //                         profileVMController.nameController.value.text
//     //                             .trim(),
//     //                         context)
//     //                     .then((value) {
//     //                   Get.back();
//     //                 });
//     //               } else {
//     //                 showErrorSnackbar("Please Enter a valid Name!", context);
//     //               }
//     //             },
//     //             width: Get.width * 0.35,
//     //           ),
//     //         ],
//     //       )
//     //     ],
//     //   ).paddingHrz(15),
//     // ));
//   }
// }
//
// class CustomTextContainer extends StatelessWidget {
//   const CustomTextContainer({
//     super.key,
//     required this.title,
//     required this.content,
//   });
//   final String title;
//   final String content;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//               fontFamily: AppFonts.poppinsMedium,
//               fontSize: 18,
//               color: themeController.isDarkMode
//                   ? DarkModeColors.kWhite
//                   : AppColors.kBlack),
//         ),
//         SizedBox(
//           height: Get.height * 0.01,
//         ),
//         Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(
//                   width: 2,
//                   color: themeController.isDarkMode
//                       ? DarkModeColors.kWhite
//                       : AppColors.kBlack)),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//             child: Row(
//               children: [
//                 Flexible(
//                   child: Text(
//                     content,
//                     style: TextStyle(
//                         fontFamily: AppFonts.poppinsRegular,
//                         fontSize: 16,
//                         color: themeController.isDarkMode
//                             ? DarkModeColors.kWhite
//                             : AppColors.kBlack),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
// final weekDays = [
//   "M",
//   "T",
//   "W",
//   "T",
//   "F",
//   "S",
//   "S",
// ];
//
// class ChartData {
//   ChartData(this.x, this.y, this.color);
//   final String x;
//   final double y;
//   final Color color;
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_green_world/view/profile/cfa_screen.dart';
import 'package:future_green_world/view_model/controller/profile/profile_view_model_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../res/colors/app_colors.dart';

class ProfileScreen extends StatefulWidget {

  final String name;
  const ProfileScreen({ required this.name,super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
    final profileVMController = Get.put(ProfileViewModel());
  @override
  void initState() {
    profileVMController.nameController.value.text = widget.name;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset(
                "assets/images/Avatar.png",
              ),
              SizedBox(height: 10),
              Text(
                profileVMController.nameController.value.text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "albertflores@mail.com",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.check_circle_outline_outlined,
                    size: 18,
                    color: AppColors.greenColor,
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.borderColor,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.greyColor,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.keyboard_arrow_down_sharp,
                      size: 18,
                      color: AppColors.greyColor,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.borderColor,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i = 0; i < weekDays.length; i++)
                          Column(
                            children: [
                              Image.asset(
                                "assets/icons/${i == 0 || i == 1 ? "flame_color" : "flame"}.png",
                                width: 20,
                              ),
                              Text(
                                weekDays[i],
                                style: TextStyle(
                                 fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const Divider(
                      color: AppColors.borderColor,
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        Text(
                          "Strikes",
                          style: TextStyle(
                           fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Image.asset(
                          "assets/icons/flame_color.png",
                          width: 20,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "6 Days",
                          style: TextStyle(
                           fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.borderColor,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          "CFA ESG Investing",
                          style: TextStyle(
                           fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CfaScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "More",
                            style: TextStyle(
                             fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: AppColors.borderColor,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    pointColorMapper: (ChartData data, _) =>
                                    data.color,
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
                              Column(
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
                                  //    fontSize: 10.sp,
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
                                    pointColorMapper: (ChartData data, _) =>
                                    data.color,
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
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "60%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                     fontSize: 12,
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
                                    pointColorMapper: (ChartData data, _) =>
                                    data.color,
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
                              Column(
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final weekDays = [
  "M",
  "T",
  "W",
  "T",
  "F",
  "S",
  "S",
];

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
