import 'package:get/get.dart';

import 'journal_daily_controller.dart';

class JournalDailyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JournalDailyController>(JournalDailyController.new);
  }
}
