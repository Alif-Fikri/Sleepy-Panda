import 'package:get/get.dart';

import '../../core/services/session_service.dart';

class HomeController extends GetxController {
  HomeController({SessionService? sessionService})
      : _sessionService = sessionService ?? Get.find<SessionService>();

  final SessionService _sessionService;

  String email = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    email = (args['email'] ?? _sessionService.email ?? '') as String;
  }
}
