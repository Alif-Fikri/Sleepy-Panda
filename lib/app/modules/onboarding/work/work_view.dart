import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepys/helper/note_card.dart';

import 'work_controller.dart';

class OnboardingWorkView extends GetView<OnboardingWorkController> {
  const OnboardingWorkView({super.key});

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
                'Sleepy Panda ingin mengenalmu!',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(height: deviceWidth * 0.02),
              Text(
                'Apa Pekerjaan anda sekarang?',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: subtitleFontSize,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: deviceWidth * 0.03),
              const NoteCard(
                text:
                    'Pilih pekerjaan Anda dari daftar di bawah ini. Jika pekerjaan Anda tidak ada di daftar, pilih yang paling mendekati.',
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: deviceWidth * 0.35),
                    child: Obx(
                      () {
                        final selectedWork = controller.selectedWork.value;
                        final isSaving = controller.isSaving.value;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: deviceWidth * 0.8,
                              height: deviceWidth * 0.15,
                              padding: EdgeInsets.symmetric(
                                  horizontal: deviceWidth * 0.04),
                              decoration: BoxDecoration(
                                color: const Color(0xFF272E49),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedWork,
                                  hint: Text(
                                    'Pilih Pekerjaan',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Urbanist',
                                      fontSize: subtitleFontSize,
                                    ),
                                  ),
                                  dropdownColor: const Color(0xFF272E49),
                                  iconEnabledColor: Colors.white,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Urbanist',
                                    fontSize: subtitleFontSize,
                                  ),
                                  onChanged: isSaving
                                      ? null
                                      : (String? value) {
                                          if (value != null) {
                                            controller.selectWork(
                                                value, context);
                                          }
                                        },
                                  items: controller.occupations
                                      .map(
                                        (value) => DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            if (isSaving)
                              Padding(
                                padding:
                                    EdgeInsets.only(top: deviceWidth * 0.05),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                          ],
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
