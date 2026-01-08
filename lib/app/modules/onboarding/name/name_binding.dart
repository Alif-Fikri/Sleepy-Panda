import 'package:get/get.dart';

import 'name_controller.dart';

class OnboardingNameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingNameController>(OnboardingNameController.new);
  }
}
