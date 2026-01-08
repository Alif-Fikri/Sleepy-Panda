import 'package:get/get.dart';

import 'profile_detail_controller.dart';

class ProfileDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileDetailController>(ProfileDetailController.new);
  }
}
