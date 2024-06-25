import 'package:get/get.dart';

class QuizController extends GetxController {
  RxInt questionNo = 0.obs;
  RxBool answered = false.obs;
  RxInt selectedIndex = 99.obs;
  RxInt correctIndex = 99.obs;
  RxString correctAnswer = ''.obs;
  RxString selectedChoice = ''.obs;
  RxBool isCorrect = false.obs;

  RxList skippedIndex = [].obs;

  void clearController() {
    answered.value = false;
    selectedIndex.value = 99;
    correctIndex.value = 99;
    correctAnswer.value = '';
  }
}
