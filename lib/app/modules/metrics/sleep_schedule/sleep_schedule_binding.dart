import 'package:get/get.dart';

import 'sleep_schedule_controller.dart';

class SleepScheduleBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SleepScheduleController>()) {
      Get.lazyPut<SleepScheduleController>(SleepScheduleController.new);
    }
  }
}
