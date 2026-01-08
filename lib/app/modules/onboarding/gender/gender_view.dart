import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'gender_controller.dart';

class OnboardingGenderView extends GetView<OnboardingGenderController> {
  const OnboardingGenderView({super.key});

  Color _borderColor(bool isSelected) {
    return isSelected ? const Color(0xFF009090) : Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final titleFontSize = deviceWidth * 0.06;
    final subtitleFontSize = deviceWidth * 0.04;
    final buttonHeight = deviceWidth * 0.13;
    final paddingSize = deviceWidth * 0.04;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF20223F),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color(0xFF20223F),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi ${controller.name}!',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(height: deviceWidth * 0.02),
              Text(
                'Pilih gender kamu, agar kami bisa mengenal kamu lebih baik.',
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () {
                            final selected = controller.selectedGender.value;
                            final isSaving = controller.isSaving.value;
                            return GestureDetector(
                              onTap: isSaving
                                  ? null
                                  : () => controller.selectGender('0', context),
                              child: Container(
                                width: deviceWidth * 0.8,
                                height: buttonHeight,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF272E49),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: _borderColor(selected == '0'),
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(paddingSize),
                                      child: Image.asset(
                                          'assets/images/person2.png'),
                                    ),
                                    Text(
                                      'Perempuan',
                                      style: TextStyle(
                                        fontSize: subtitleFontSize,
                                        color: Colors.white,
                                        fontFamily: 'Urbanist',
                                      ),
                                    ),
                                    const Spacer(),
                                    if (selected == '0' && isSaving)
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: paddingSize),
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
                            );
                          },
                        ),
                        SizedBox(height: deviceWidth * 0.05),
                        Obx(
                          () {
                            final selected = controller.selectedGender.value;
                            final isSaving = controller.isSaving.value;
                            return GestureDetector(
                              onTap: isSaving
                                  ? null
                                  : () => controller.selectGender('1', context),
                              child: Container(
                                width: deviceWidth * 0.8,
                                height: buttonHeight,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF272E49),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: _borderColor(selected == '1'),
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(paddingSize),
                                      child: Image.asset(
                                          'assets/images/person1.png'),
                                    ),
                                    Text(
                                      'Pria',
                                      style: TextStyle(
                                        fontSize: subtitleFontSize,
                                        color: Colors.white,
                                        fontFamily: 'Urbanist',
                                      ),
                                    ),
                                    const Spacer(),
                                    if (selected == '1' && isSaving)
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: paddingSize),
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
                            );
                          },
                        ),
                      ],
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
