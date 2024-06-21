import 'package:flutter/material.dart';
import 'package:future_green_world/res/assets/image_assets.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/custom_elevated_button.dart';
import 'package:future_green_world/res/components/custom_safe_area.dart';
import 'package:future_green_world/res/components/custom_text_field.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:future_green_world/view_model/controller/authentication/authentication_view_model_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_validator/the_validator.dart';

import '../../models/user.dart';
import '../../res/components/custom_snackbar.dart';
import '../../res/components/loading.dart';
import '../../res/controller/controller_instances.dart';
import '../bottomNavBar/bottom_nav_bar_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final authVMController = Get.put(AuthenticationViewModel());
    return CustomSafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [

              Center(
                child: Image.asset(
                  ImageAssets.appLogo,
                  height: 150,
                  width: 150,
                ),
              ).paddingVert(2.h),
              const Text(
                'Create An Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.kBlack,
                    fontSize: 18,
                    fontFamily: AppFonts.inter,
                    fontWeight: FontWeight.w700
                ),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              CustomTextField(
                title: "Name",
                  controller: authVMController.nameController.value,
                  hintText: 'dimitridangeros',
                  labelText: 'Name',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: FieldValidator.required(),
                  savedValue: (_) {},
                  // isPrefixIconEnabled: true,
                  // icon: Icons.person_outline
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              CustomTextField(
                title: "Email Address",
                  controller: authVMController.emailController.value,
                  hintText: 'dimitridangeros@gmail.com',
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: FieldValidator.email(),
                  savedValue: (_) {},
                  // isPrefixIconEnabled: true,
                  // icon: Icons.email_outlined
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              CustomTextField(
                title: "Password",
                  controller: authVMController.passwordController.value,
                  hintText: 'dimitridangeros',
                  obscure: true,
                  labelText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  validator: FieldValidator.password(
                      minLength: 8,
                      errorMessage:
                          "Password must contain at least 8 characters"),
                  savedValue: (_) {},
                  // isPrefixIconEnabled: true,
                  // icon: Icons.lock_outline
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              CustomTextField(
                  title: "Confirm Password",
                  controller: authVMController.passwordController.value,
                  hintText: 'dimitridangeros',
                  obscure: true,
                  labelText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  validator: FieldValidator.password(
                      minLength: 8,
                      errorMessage:
                      "Password must contain at least 8 characters"),
                  savedValue: (_) {},
                  // isPrefixIconEnabled: true,
                  // icon: Icons.lock_outline
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              Center(
                  child: CustomElevatedButton(
                title: 'Sign Up',
                onPress: () {
                  if (formKey.currentState!.validate()) {
                    loadingDialog("Signing Up...");
                    authController
                        .register(
                            UserModel(
                              name: authVMController.nameController.value.text,
                              email:
                                  authVMController.emailController.value.text,
                              isVerified: false,
                            ),
                            authVMController.passwordController.value.text,
                            context)
                        .then((value) {
                      if (value != null) {
                        Get.back();
                        showErrorSnackbar(
                          value,
                          context,
                        );
                      } else {
                        Get.offAll(() => const BottomNavigationBarScreen());
                      }
                    });
                  }
                },
                width: Get.width * 0.9,
              )),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    'Already have an account?',
                    style: GoogleFonts.playfairDisplay(
                      color: AppColors.kGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,


                    ),
                  ),
                  5.widthBox,
                  GestureDetector(
                    onTap: () =>
                        {Get.back(), authVMController.clearController()},
                    child:  Text(
                      'Login',
                      style: GoogleFonts.playfairDisplay(
                        color: AppColors.kPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,


                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
