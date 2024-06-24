import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:future_green_world/controllers/theme_controller.dart';
import 'package:future_green_world/view_model/controller/authentication/auth_controller.dart';

import '../../view_model/services/db_controller.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
AuthController authController = AuthController.instance;
DatabaseController db = DatabaseController.instance;
ThemeController themeController = ThemeController.instance;
