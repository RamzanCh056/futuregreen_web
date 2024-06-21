import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:future_green_world/res/assets/image_assets.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/custom_elevated_button.dart';
import 'package:future_green_world/res/components/custom_safe_area.dart';
import 'package:future_green_world/res/components/custom_text_field.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:future_green_world/view/authentication/sign_up_screen.dart';
import 'package:future_green_world/view/bottomNavBar/bottom_nav_bar_screen.dart';
import 'package:future_green_world/view_model/controller/authentication/authentication_view_model_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_validator/the_validator.dart';

import '../../res/components/custom_snackbar.dart';
import '../../res/components/loading.dart';
import '../../res/controller/controller_instances.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authVMController = Get.put(AuthenticationViewModel());
    if (kDebugMode) {
      // authVMController.emailController.value.text = "test@gmail.com";
      // authVMController.passwordController.value.text = "12345678";
    }
    return CustomSafeArea(
        child: Scaffold(
      backgroundColor: themeController.isDarkMode
          ? DarkModeColors.kBodyColor
          : AppColors.kWhite,
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
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.kBlack,
                    fontSize: 18,
                    fontFamily: AppFonts.inter,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              CustomTextField(
                title: "Email",
                controller: authVMController.emailController.value,
                hintText: 'dimitridangeros@gmail.com',
                // labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                floatingLabelBehaviour: false,
                textInputAction: TextInputAction.next,
                validator: FieldValidator.email(),
                savedValue: (_) {},
                // isPrefixIconEnabled: true,
                // icon: Icons.email_outlined,
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              CustomTextField(
                title: "Password",
                controller: authVMController.passwordController.value,
                hintText: '************',
                // labelText: '',
                keyboardType: TextInputType.text,
                floatingLabelBehaviour: false,
                textInputAction: TextInputAction.next,
                validator: FieldValidator.password(),
                savedValue: (_) {},
                // isPrefixIconEnabled: true,
                // icon: Icons.email_outlined,
              ),
              // CustomPasswordTextField(
              //
              //   controller: authVMController.passwordController.value,
              //   hintText: '*****************',
              //
              //   labelText: 'Password',
              //   keyboardType: TextInputType.visiblePassword,
              //   textInputAction: TextInputAction.done,
              //   validator: FieldValidator.password(
              //       minLength: 8,
              //       errorMessage:
              //           "Password must contain at least 8 characters"),
              //   savedValue: (_) {},
              //   isPrefixIconEnabled: true,
              //   icon: Icons.lock_outline_rounded,
              // ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     GestureDetector(
              //       onTap: () => Get.to(() => const ForgotPasswordScreen()),
              //       child: const Text(
              //         'Forgot Password?',
              //         style: TextStyle(
              //           color: AppColors.kPrimary,
              //           fontFamily: AppFonts.poppinsMedium,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: Get.height * 0.2,
              ),
              Center(
                child: CustomElevatedButton(
                  title: 'Login',
                  onPress: () {
                    if (formKey.currentState!.validate()) {
                      loadingDialog("Signing In...");
                      authController
                          .login(authVMController.emailController.value.text,
                              authVMController.passwordController.value.text)
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
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: GoogleFonts.playfairDisplay(
                        color: themeController.isDarkMode
                            ? AppColors.kLightGrey
                            : AppColors.kGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  5.widthBox,
                  GestureDetector(
                    onTap: () => {
                      Get.to(() => SignUpScreen()),
                      authVMController.clearController()
                    },
                    child: Text(
                      'Sign Up',
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
