import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../data/models/prediction.dart';

class PredictionResultController extends GetxController {
  PredictionResultController({SessionService? sessionService})
      : _sessionService = sessionService ?? Get.find<SessionService>();

  final SessionService _sessionService;

  late final String email;
  late final PredictionLabel label;
  PredictionPeriod? period;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    email = (args['email'] ?? _sessionService.email ?? '') as String;
    label = _resolveLabel(args['label']);
    final rawPeriod = args['period'];
    if (rawPeriod is PredictionPeriod) {
      period = rawPeriod;
    }
  }

  PredictionLabel _resolveLabel(dynamic raw) {
    final parsed = tryParsePredictionLabel(raw);
    if (parsed != null) {
      return parsed;
    }
    throw ArgumentError('Hasil prediksi tidak ditemukan.');
  }
}
