import 'package:get/get.dart';

import '../../../data/models/prediction.dart';
import 'prediction_agreement_controller.dart';

class PredictionDailyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PredictionAgreementController>(
      () => PredictionAgreementController(period: PredictionPeriod.daily),
    );
  }
}

class PredictionWeeklyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PredictionAgreementController>(
      () => PredictionAgreementController(period: PredictionPeriod.weekly),
    );
  }
}

class PredictionMonthlyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PredictionAgreementController>(
      () => PredictionAgreementController(period: PredictionPeriod.monthly),
    );
  }
}
