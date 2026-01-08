import 'package:get/get.dart';

import 'weight_controller.dart';

class OnboardingWeightBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingWeightController>(OnboardingWeightController.new);
  }
}
