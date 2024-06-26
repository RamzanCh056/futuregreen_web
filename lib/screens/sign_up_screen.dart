import 'package:flutter/material.dart';
import 'package:future_green_world/res/authentication_view_model_controller.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:future_green_world/res/components/web_custom_elevated_button.dart';
import 'package:future_green_world/res/components/web_custom_text_field.dart';
import 'package:future_green_world/res/components/web_scaffold.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_validator/the_validator.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final authVMController = Get.put(AuthenticationViewModel());
    return WebScaffold(
          body: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Form(
      key: formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const Text(
            'Create Account',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.kBlack,
                fontSize: 25,
                fontFamily: AppFonts.poppinsMedium,
                fontWeight: FontWeight.w900),
          ),
          const Text(
            'Follow the instructions to make it easier to register',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.kGrey,
                fontSize: 15,
                fontFamily: AppFonts.inter,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: Get.height * 0.03,
          ),
          WebCustomTextField(
              controller: authVMController.nameController.value,
              hintText: 'Username',
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: FieldValidator.required(),
              savedValue: (_) {},
              isPrefixIconEnabled: true,
              icon: Icons.person_outline),
          SizedBox(
            height: Get.height * 0.03,
          ),
          WebCustomTextField(
              controller: authVMController.emailController.value,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: FieldValidator.email(),
              savedValue: (_) {},
              isPrefixIconEnabled: true,
              icon: Icons.email_outlined),
          SizedBox(
            height: Get.height * 0.03,
          ),
          WebCustomTextField(
            controller: authVMController.passwordController.value,
            hintText: 'Password',
            obscure: true,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            validator: FieldValidator.password(
                minLength: 8,
                errorMessage:
                    "Password must contain at least 8 characters"),
            savedValue: (_) {},
            isPrefixIconEnabled: true,
            icon: Icons.lock_outline,
          ),
          SizedBox(
            height: Get.height * 0.03,
          ),
          SizedBox(
            height: Get.height * 0.04,
          ),
          Center(
              child: WebCustomElevatedButton(
            title: 'Create Account',
            onPress: () {
              if (formKey.currentState!.validate()) {
              //   loadingDialog("Signing Up...");
              //   authController
              //       .register(
              //           UserModel(
              //             name: authVMController.nameController.value.text,
              //             email:
              //                 authVMController.emailController.value.text,
              //             isVerified: false,
              //           ),
              //           authVMController.passwordController.value.text,
              //           context)
              //       .then((value) {
              //     if (value != null) {
              //       Get.back();
              //       showErrorSnackbar(
              //         value,
              //         context,
              //       );
              //     } else {
              //       Get.offAll(() => const BottomNavigationBarScreen());
              //     }
              //   });
              }
            },
            width: Get.width * 0.6,
            height:60,

          )),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
                child: Text(
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
        );
  }
}
