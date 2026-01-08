import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'date_controller.dart';

class OnboardingDateView extends GetView<OnboardingDateController> {
  const OnboardingDateView({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terima kasih!',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(height: deviceWidth * 0.02),
              Text(
                'Sekarang, kapan tanggal lahir mu?',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: subtitleFontSize,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: deviceWidth * 0.25),
                    child: Obx(
                      () {
                        final date = controller.selectedDate.value;
                        final text =
                            '${date.day.toString().padLeft(2, '0')} / ${date.month.toString().padLeft(2, '0')} / ${date.year}';
                        final isSaving = controller.isSaving.value;
                        return GestureDetector(
                          onTap: isSaving
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();
                                  await controller.pickDate(context);
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF272E49),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    text,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.bold,
                                      fontSize: subtitleFontSize * 1.4,
                                    ),
                                  ),
                                  if (isSaving)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: deviceWidth * 0.03),
                                      child: const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
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
