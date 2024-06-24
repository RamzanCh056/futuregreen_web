import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileViewModel extends GetxController {
  RxBool editProfile = false.obs;
  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
}
