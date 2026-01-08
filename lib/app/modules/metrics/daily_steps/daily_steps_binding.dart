import 'package:get/get.dart';

import 'daily_steps_controller.dart';

class DailyStepsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DailyStepsController>()) {
      Get.lazyPut<DailyStepsController>(DailyStepsController.new);
    }
  }
}
