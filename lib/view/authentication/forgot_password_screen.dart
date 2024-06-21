import 'package:flutter/material.dart';
import 'package:future_green_world/res/assets/image_assets.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/custom_elevated_button.dart';
import 'package:future_green_world/res/components/custom_safe_area.dart';
import 'package:future_green_world/res/components/custom_text_field.dart';
import 'package:future_green_world/res/fonts/app_fonts.dart';
import 'package:future_green_world/view_model/controller/authentication/authentication_view_model_controller.dart';
import 'package:get/get.dart';
import 'package:the_validator/the_validator.dart';

import '../../res/controller/controller_instances.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final authVMController = Get.put(AuthenticationViewModel());
    return CustomSafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kTransparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.kBlack,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
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
                  height: 250,
                  width: 250,
                ),
              ),
              const Text(
                'Forgot Password',
                style: TextStyle(
                    color: AppColors.kTextPrimary,
                    fontSize: 24,
                    fontFamily: AppFonts.poppinsRegular),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              CustomTextField(
                controller: authVMController.emailController.value,
                hintText: 'Your Email',
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: FieldValidator.email(),
                savedValue: (_) {},
                isPrefixIconEnabled: true,
                icon: Icons.email_outlined,
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Center(
                child: CustomElevatedButton(
                  title: 'Submit',
                  onPress: () {
                    if (formKey.currentState!.validate()) {
                      authController.sendPasswordResetEmail(
                          authVMController.emailController.value.text, context);
                    }
                    authVMController.clearController();
                  },
                  width: Get.width * 0.9,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
