import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class AuthChoiceController extends GetxController {
  void goToLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  void goToSignup() {
    Get.offAllNamed(AppRoutes.signup);
  }
}
