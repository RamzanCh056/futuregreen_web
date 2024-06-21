import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/colors/app_primary_color.dart';
import 'package:future_green_world/res/components/extensions.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/theme_controller.dart';
import 'firebase_options.dart';
import 'res/components/loading.dart';
import 'view_model/controller/authentication/auth_controller.dart';
import 'view_model/services/db_controller.dart';

SharedPreferences? sharedPreferences;
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    Get.put(AuthController());
    Get.put(DatabaseController());
    Get.put(ThemeController());
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FutureGreenWorld",
      defaultTransition: Transition.rightToLeft,
      theme: ThemeData(
          primarySwatch: primary,
          highlightColor: Ex.getMaterialColor(AppColors.kPrimary)),
      darkTheme: ThemeData(
          primarySwatch: primary,
          highlightColor: Ex.getMaterialColor(AppColors.kPrimary)),
      home: const Center(child: Loading()),
    );
  }
}
