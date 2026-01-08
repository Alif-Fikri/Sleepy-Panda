import 'package:get/get.dart';

import 'journal_weekly_controller.dart';

class JournalWeeklyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JournalWeeklyController>(JournalWeeklyController.new);
  }
}
