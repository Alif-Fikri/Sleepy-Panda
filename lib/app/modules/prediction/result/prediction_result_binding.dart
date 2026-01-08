import 'package:get/get.dart';

import 'prediction_result_controller.dart';

class PredictionResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PredictionResultController>(PredictionResultController.new);
  }
}
