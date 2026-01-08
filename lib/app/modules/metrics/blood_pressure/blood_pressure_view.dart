import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'blood_pressure_controller.dart';

class BloodPressureView extends GetView<BloodPressureController> {
  const BloodPressureView({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final padding = screen.width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xFF20223F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF20223F),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screen.height * 0.02),
                  Text(
                    'Saya ingin tahu tentang kamu,',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: screen.width * 0.06,
                    ),
                  ),
                  SizedBox(height: screen.height * 0.01),
                  Text(
                    'Berapa tekanan darah kamu seminggu terakhir?',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: screen.width * 0.045,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screen.height * 0.03),
                  _InputRow(
                    controller: controller,
                    textController: controller.upperController,
                    hintText: 'Tekanan darah atas',
                  ),
                  SizedBox(height: screen.height * 0.02),
                  _InputRow(
                    controller: controller,
                    textController: controller.lowerController,
                    hintText: 'Tekanan darah bawah',
                  ),
                  const Spacer(),
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isButtonEnabled.value
                            ? () => controller.submit(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF009090),
                          padding: EdgeInsets.symmetric(
                            vertical: screen.height * 0.02,
                          ),
                          foregroundColor: Colors.white,
                        ),
                        child: controller.isSubmitting.value
                            ? SizedBox(
                                width: screen.height * 0.025,
                                height: screen.height * 0.025,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Next',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: screen.width * 0.045,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: screen.height * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({
    required this.controller,
    required this.textController,
    required this.hintText,
  });

  final BloodPressureController controller;
  final TextEditingController textController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => controller.submit(context),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF272E49),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'Urbanist',
                fontSize: screen.width * 0.04,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Urbanist',
              fontSize: screen.width * 0.045,
            ),
          ),
        ),
        SizedBox(width: screen.width * 0.02),
        Column(
          children: [
            IconButton(
              onPressed: () => controller.decrement(textController),
              icon: const Icon(Icons.remove, color: Colors.white),
            ),
            IconButton(
              onPressed: () => controller.increment(textController),
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
