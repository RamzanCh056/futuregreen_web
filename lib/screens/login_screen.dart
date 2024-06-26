import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:future_green_world/res/assets/image_assets.dart';
import 'package:future_green_world/res/authentication_view_model_controller.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/custom_safe_area.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/components/web_custom_elevated_button.dart';
import 'package:future_green_world/res/components/web_custom_text_field.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:future_green_world/screens/sign_up_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_validator/the_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final AuthenticationViewModel authVMController = Get.put(AuthenticationViewModel());

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      // Uncomment these lines if you want to pre-fill the fields during debug mode
      // authVMController.emailController.value.text = "test@gmail.com";
      // authVMController.passwordController.value.text = "12345678";
    }
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
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.kBlack,
                    fontSize: 18,
                    fontFamily: AppFonts.inter,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: Get.height * 0.03),
                WebCustomTextField(
                  title: "Email",
                  controller: authVMController.emailController.value,
                  hintText: 'dimitridangeros@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  floatingLabelBehaviour: false,
                  textInputAction: TextInputAction.next,
                  validator: FieldValidator.email(),
                  savedValue: (_) {},
                ),
                SizedBox(height: Get.height * 0.03),
                WebCustomTextField(
                  title: "Password",
                  controller: authVMController.passwordController.value,
                  hintText: '************',
                  keyboardType: TextInputType.text,
                  floatingLabelBehaviour: false,
                  textInputAction: TextInputAction.done,
                  validator: FieldValidator.password(),
                  savedValue: (_) {},
                  obscure: true,
                ),
                SizedBox(height: Get.height * 0.02),
                SizedBox(height: Get.height * 0.2),
                Center(
                  child: WebCustomElevatedButton(
                    title: 'Login',
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        // Perform login action
                        // authController.login(authVMController.emailController.value.text, authVMController.passwordController.value.text);
                      }
                    },
                    width: Get.width * 0.9,
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => {
                        Get.to(() => const SignUpScreen()),
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
      ),
    );
  }
}
