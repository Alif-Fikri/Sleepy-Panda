import 'package:get/get.dart';

import 'blood_pressure_controller.dart';

class BloodPressureBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<BloodPressureController>()) {
      Get.lazyPut<BloodPressureController>(BloodPressureController.new);
    }
  }
}
