import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'daily_steps_controller.dart';

class DailyStepsView extends GetView<DailyStepsController> {
  const DailyStepsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final verticalPadding = screen.height * 0.02;
    final horizontalPadding = screen.width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xFF20223F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF20223F),
        automaticallyImplyLeading: false,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: verticalPadding),
            Text(
              'Saya ingin tau tentang kamu,',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: screen.width * 0.06,
              ),
            ),
            SizedBox(height: verticalPadding * 0.5),
            Text(
              'Berapa jumlah langkah hari ini?',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: screen.width * 0.045,
                color: Colors.white,
              ),
            ),
            SizedBox(height: verticalPadding),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.stepsController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => controller.submit(context),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF272E49),
                      hintText: 'Jumlah langkah',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: controller.decrement,
                      icon: const Icon(Icons.remove, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: controller.increment,
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: screen.height * 0.07,
                child: ElevatedButton(
                  onPressed: controller.isButtonEnabled.value
                      ? () => controller.submit(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009090),
                    foregroundColor: Colors.white,
                  ),
                  child: controller.isSubmitting.value
                      ? SizedBox(
                          width: screen.height * 0.03,
                          height: screen.height * 0.03,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: screen.width * 0.04,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: verticalPadding),
          ],
        ),
      ),
    );
  }
}
