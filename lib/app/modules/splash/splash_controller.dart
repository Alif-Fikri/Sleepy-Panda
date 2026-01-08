import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:sleepys/app/routes/app_routes.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> fadeAnimation;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    animationController.forward();

    _timer = Timer(const Duration(seconds: 4), navigateToAuthChoice);
  }

  void navigateToAuthChoice() {
    if (!Get.isRegistered<SplashController>()) {
      return;
    }
    Get.offAllNamed(AppRoutes.authChoice);
  }

  @override
  void onClose() {
    _timer?.cancel();
    animationController.dispose();
    super.onClose();
  }
}
