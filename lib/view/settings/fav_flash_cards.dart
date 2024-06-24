import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:future_green_world/res/components/custom_safe_area.dart';
import 'package:future_green_world/res/components/custom_text_field.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:get/get.dart';
import 'package:the_validator/the_validator.dart';

import '../../models/flash_card.dart';
import '../../res/colors/app_colors.dart';
import '../../res/components/loading.dart';
import '../../res/controller/controller_instances.dart';
import '../../res/fonts/app_fonts.dart';

class FavouriteFlashCardScreen extends StatefulWidget {
  const FavouriteFlashCardScreen({super.key});

  @override
  State<FavouriteFlashCardScreen> createState() =>
      _FavouriteFlashCardScreenState();
}

class _FavouriteFlashCardScreenState extends State<FavouriteFlashCardScreen> {
  FlipCardController cardController = FlipCardController();
  final answerController = TextEditingController();

  final pageViewController = PageController();

  void showCardHint() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cardController.hint(
        duration: const Duration(milliseconds: 400),
        total: const Duration(seconds: 2),
      );
    });
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: themeController.isDarkMode
              ? DarkModeColors.kBodyColor
              : AppColors.kWhite,
          appBar: AppBar(
            backgroundColor: themeController.isDarkMode
                ? DarkModeColors.kAppBarColor
                : AppColors.kWhite,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: themeController.isDarkMode
                    ? DarkModeColors.kWhite
                    : AppColors.kBlack,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            title: Text(
              'Favourite Flash Cards',
              style: TextStyle(
                fontFamily: AppFonts.poppinsBold,
                color: themeController.isDarkMode
                    ? DarkModeColors.kWhite
                    : AppColors.kBlack,
              ),
            ),
            centerTitle: true,
          ),
          body: StreamBuilder<dynamic>(
              stream: firestore
                  .collection("flashCards")
                  .where("favourites",
                      arrayContains: authController.getCurrentUser())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<FlashCardModel> flashCards = snapshot.data.docs
                      .map<FlashCardModel>((e) => FlashCardModel.fromJson(e))
                      .toList();

                  showCardHint();
                  if (flashCards.isNotEmpty) {
                    return PageView.builder(
                      onPageChanged: (value) => answerController.clear(),
                      controller: pageViewController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListView(
                          children: [
                            FlipCard(
                              controller: cardController,
                              fill: Fill.fillBack,
                              direction: FlipDirection.HORIZONTAL,
                              side: CardSide.FRONT,
                              flipOnTouch: true,
                              front: Container(
                                height: 50.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: Ex.blue400,
                                  borderRadius: Ex.rounded,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        50.widthBox,
                                        Text(
                                          "${index + 1}/${flashCards.length}",
                                          style: TextStyle(
                                              color: AppColors.kWhite
                                                  .withOpacity(0.5),
                                              fontSize: 15,
                                              fontFamily:
                                                  AppFonts.poppinsRegular),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            firestore
                                                .collection("flashCards")
                                                .doc(flashCards[index].id)
                                                .update({
                                              "favourites": flashCards[index]
                                                      .favourites
                                                      .contains(authController
                                                          .getCurrentUser())
                                                  ? FieldValue.arrayRemove([
                                                      authController
                                                          .getCurrentUser()
                                                    ])
                                                  : FieldValue.arrayUnion([
                                                      authController
                                                          .getCurrentUser()
                                                    ])
                                            });
                                          },
                                          icon: Icon(
                                            flashCards[index]
                                                    .favourites
                                                    .contains(authController
                                                        .getCurrentUser())
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            size: 30,
                                          ),
                                          color: AppColors.kRed,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                        child: AutoSizeText(
                                      flashCards[index].question,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: AppFonts.poppinsBold,
                                        fontSize: 25,
                                        color: AppColors.kWhite,
                                      ),
                                    ).center.paddingAll(10)),
                                  ],
                                ),
                              ),
                              back: Container(
                                height: 50.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: AppColors.kGreen,
                                  borderRadius: Ex.rounded,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        50.widthBox,
                                        Text(
                                          "${index + 1}/${flashCards.length}",
                                          style: TextStyle(
                                              color: AppColors.kWhite
                                                  .withOpacity(0.5),
                                              fontSize: 15,
                                              fontFamily:
                                                  AppFonts.poppinsRegular),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            firestore
                                                .collection("flashCards")
                                                .doc(flashCards[index].id)
                                                .update({
                                              "favourites": flashCards[index]
                                                      .favourites
                                                      .contains(authController
                                                          .getCurrentUser())
                                                  ? FieldValue.arrayRemove([
                                                      authController
                                                          .getCurrentUser()
                                                    ])
                                                  : FieldValue.arrayUnion([
                                                      authController
                                                          .getCurrentUser()
                                                    ])
                                            });
                                          },
                                          icon: Icon(
                                            flashCards[index]
                                                    .favourites
                                                    .contains(authController
                                                        .getCurrentUser())
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            size: 30,
                                          ),
                                          color: AppColors.kRed,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                        child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            flashCards[index].answer,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              fontFamily:
                                                  AppFonts.poppinsRegular,
                                              fontSize: 14,
                                              color: AppColors.kWhite,
                                            ),
                                          ).center.paddingAll(10),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ).paddingSymmetric(
                              horizontal: 15,
                            ),
                            (2.h).heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    height: 8.h,
                                    width: Get.width,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.kPrimary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                      onPressed: () {
                                        if (index != 0) {
                                          pageViewController.previousPage(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves
                                                  .fastEaseInToSlowEaseOut);
                                        }
                                      },
                                      child: const Icon(
                                        Icons.arrow_back,
                                        color: AppColors.kWhite,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                (Get.height * 0.01).widthBox,
                                //Next Button
                                Flexible(
                                  child: SizedBox(
                                    height: 8.h,
                                    width: Get.width,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.kPrimary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                      onPressed: () {
                                        if (index != flashCards.length - 1) {
                                          pageViewController.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves
                                                  .fastEaseInToSlowEaseOut);
                                        }
                                      },
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.kWhite,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ).paddingHrz(10),
                            2.h.heightBox,
                            StreamBuilder<dynamic>(
                                stream: firestore
                                    .collection("flashCards")
                                    .doc(flashCards[index].id)
                                    .collection("answers")
                                    .doc(authController.getCurrentUser())
                                    .snapshots(),
                                builder: (context, sn) {
                                  if (sn.hasData) {
                                    if (sn.data.exists) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        answerController.text =
                                            sn.data["answer"];
                                      });
                                    }
                                  }
                                  return CustomTextField(
                                          readOnly: true,
                                          controller: answerController,
                                          hintText: "Your Answer",
                                          labelText: "Your Answer",
                                          keyboardType: TextInputType.multiline,
                                          textInputAction:
                                              TextInputAction.newline,
                                          validator: FieldValidator.required())
                                      .paddingAll(10);
                                })
                          ],
                        );
                      },
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Ex.blue400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Icon(
                            Icons.favorite,
                            size: 50,
                            color: AppColors.kWhite,
                          ),
                        ),
                        Text(
                          "Your favourite flash cards\nwill show here!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              color: themeController.isDarkMode
                                  ? DarkModeColors.kWhite
                                  : AppColors.kBlack),
                        ).center.paddingSymmetric(horizontal: 20, vertical: 20),
                      ],
                    );
                  }
                } else {
                  return const Loading().center;
                }
              }),
        ),
      ),
    );
  }
}
