import 'package:get/get.dart';

import 'date_controller.dart';

class OnboardingDateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingDateController>(OnboardingDateController.new);
  }
}
