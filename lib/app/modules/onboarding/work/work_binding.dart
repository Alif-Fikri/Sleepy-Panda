import 'package:get/get.dart';

import 'work_controller.dart';

class OnboardingWorkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingWorkController>(OnboardingWorkController.new);
  }
}
