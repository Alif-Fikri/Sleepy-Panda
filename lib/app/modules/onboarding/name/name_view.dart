import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'name_controller.dart';

class OnboardingNameView extends GetView<OnboardingNameController> {
  const OnboardingNameView({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final titleFontSize = deviceWidth * 0.06;
    final subtitleFontSize = deviceWidth * 0.04;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF20223F),
        ),
        backgroundColor: const Color(0xFF20223F),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat datang di Sleepy Panda!',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(height: deviceWidth * 0.02),
              Text(
                'Kita kenalan dulu yuk! Siapa nama \nkamu?',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: subtitleFontSize,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: deviceWidth * 0.35),
                    child: Obx(
                      () {
                        final isSaving = controller.isSaving.value;
                        return SizedBox(
                          width: deviceWidth * 0.8,
                          height: deviceWidth * 0.15,
                          child: TextField(
                            controller: controller.nameController,
                            enabled: !isSaving,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => controller.submit(context),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF272E49),
                              hintText: 'Name',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: subtitleFontSize,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: isSaving
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          right: deviceWidth * 0.04),
                                      child: const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                      onPressed: () =>
                                          controller.submit(context),
                                    ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontSize: subtitleFontSize,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
