import 'package:get/get.dart';

import 'gender_controller.dart';

class OnboardingGenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingGenderController>(OnboardingGenderController.new);
  }
}
