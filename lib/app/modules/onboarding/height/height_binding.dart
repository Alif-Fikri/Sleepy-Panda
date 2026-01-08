import 'package:get/get.dart';

import 'height_controller.dart';

class OnboardingHeightBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingHeightController>(OnboardingHeightController.new);
  }
}
