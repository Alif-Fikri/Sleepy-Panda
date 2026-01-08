import 'package:get/get.dart';

import '../../data/providers/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/prediction_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/sleep_repository.dart';
import '../../data/repositories/metrics_repository.dart';
import '../services/session_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiClient());
    Get.put(AuthRepository(Get.find<ApiClient>()));
    Get.put(UserRepository(Get.find<ApiClient>()));
    Get.put(PredictionRepository(Get.find<ApiClient>()));
    Get.put(SleepRepository(Get.find<ApiClient>()));
    Get.put(MetricsRepository(Get.find<ApiClient>()));
    Get.putAsync<SessionService>(() => SessionService().init());
  }
}
