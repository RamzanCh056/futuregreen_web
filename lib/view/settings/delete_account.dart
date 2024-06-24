import 'package:flutter/material.dart';
import 'package:future_green_world/res/components/custom_elevated_button.dart';
import 'package:future_green_world/res/components/custom_safe_area.dart';
import 'package:future_green_world/res/components/custom_snackbar.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/components/loading.dart';
import 'package:get/get.dart';
import 'package:the_validator/the_validator.dart';

import '../../res/colors/app_colors.dart';
import '../../res/components/custom_pop_up.dart';
import '../../res/components/custom_text_field.dart';
import '../../res/controller/controller_instances.dart';
import '../../res/fonts/app_fonts.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

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
          title: const Text(
            "Delete Account",
            style: TextStyle(
              fontFamily: AppFonts.poppinsBold,
              color: AppColors.kRed,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'All of your account info and progress will be deleted permanently!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: themeController.isDarkMode
                        ? DarkModeColors.kWhite
                        : AppColors.kBlack,
                    fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: _formKey,
              child: CustomTextField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
                hintText: 'Your Current Password',
                validator: FieldValidator.password(
                    minLength: 8,
                    errorMessage:
                        "Password must contain at least 8 characters"),
                labelText: 'Password',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomElevatedButton(
                title: "Delete Account",
                width: Get.width,
                buttonColor: AppColors.kRed,
                onPress: () async {
                  if (_formKey.currentState!.validate()) {
                    showCustomPopUp(
                        context,
                        "Delete Account",
                        "Are you sure to delete your account?",
                        "Cancel",
                        AppColors.kGreen,
                        "Delete",
                        AppColors.kRed, () async {
                      loadingDialog("Deleting Account...");
                      await authController
                          .deleteUserAccount(passwordController.text)
                          .then((result) {
                        if (result != null) {
                          Get.close(2);
                          showErrorSnackbar(result, context);
                        } else {
                          Get.back();
                          showMessageSnackbar(
                              "Account deleted successfully", context);
                        }
                      });
                    });
                  }
                })
          ],
        ).paddingHrz(15),
      ),
    );
  }
}
