import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepys/helper/note_card.dart';

import 'weight_controller.dart';

class OnboardingWeightView extends StatefulWidget {
  const OnboardingWeightView({super.key});

  @override
  State<OnboardingWeightView> createState() => _OnboardingWeightViewState();
}

class _OnboardingWeightViewState extends State<OnboardingWeightView> {
  late final OnboardingWeightController controller;
  late FixedExtentScrollController wheelController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<OnboardingWeightController>();
    final initialItem = controller.selectedWeight.value.clamp(0, 199);
    wheelController = FixedExtentScrollController(initialItem: initialItem);
  }

  @override
  void dispose() {
    wheelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final titleFontSize = deviceWidth * 0.06;
    final subtitleFontSize = deviceWidth * 0.045;
    final pickerItemHeight = deviceWidth * 0.15;
    final pickerContainerWidth = deviceWidth * 0.25;
    final paddingHorizontal = deviceWidth * 0.05;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF20223F),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color(0xFF20223F),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selanjutnya,',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: deviceWidth * 0.02),
                  Text(
                    'Berapa berat badan mu?',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      color: Colors.white,
                      fontSize: subtitleFontSize,
                    ),
                  ),
                  SizedBox(height: deviceWidth * 0.02),
                  const NoteCard(
                    text:
                        'Lakukan Scrolling untuk menentukan Berat Badan kamu dan tunggu 2 detik untuk lanjut ke halaman berikutnya!!',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onPanEnd: (_) => controller.onWeightChanged(
                          controller.selectedWeight.value,
                          context,
                        ),
                        child: Container(
                          height: pickerItemHeight,
                          width: pickerContainerWidth,
                          decoration: const BoxDecoration(
                            color: Color(0xFF272E49),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ListWheelScrollView.useDelegate(
                            controller: wheelController,
                            itemExtent: pickerItemHeight,
                            physics: const FixedExtentScrollPhysics(),
                            overAndUnderCenterOpacity: 0.5,
                            onSelectedItemChanged: (index) {
                              controller.onWeightChanged(index, context);
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                return Obx(
                                  () => Center(
                                    child: Text(
                                      '$index',
                                      style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.bold,
                                        color:
                                            controller.selectedWeight.value ==
                                                    index
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.7),
                                        fontSize: subtitleFontSize * 1.5,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: 200,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: deviceWidth * 0.02),
                      Text(
                        'Kg',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: subtitleFontSize * 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => controller.isSaving.value
                  ? Padding(
                      padding: EdgeInsets.only(bottom: deviceWidth * 0.08),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(height: deviceWidth * 0.08),
            ),
          ],
        ),
      ),
    );
  }
}
