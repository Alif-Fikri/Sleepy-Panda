import 'package:get/get.dart';

import 'journal_monthly_controller.dart';

class JournalMonthlyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JournalMonthlyController>(JournalMonthlyController.new);
  }
}
