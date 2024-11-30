import 'package:get/get.dart';

class HomeController extends GetxController {
  final carousalCurrentIndex = 0.obs;

  void updatePageIndicator(int index) {
    carousalCurrentIndex.value = index;
  }
} 