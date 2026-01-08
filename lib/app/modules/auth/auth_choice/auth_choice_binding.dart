import 'package:get/get.dart';

import 'auth_choice_controller.dart';

class AuthChoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthChoiceController());
  }
}
