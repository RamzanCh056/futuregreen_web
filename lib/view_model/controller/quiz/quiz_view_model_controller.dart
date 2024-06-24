import 'package:get/get.dart';

class QuizViewModel extends GetxController {
  RxString selectedAnswer = ''.obs;
  RxBool examStatus = false.obs;
}
