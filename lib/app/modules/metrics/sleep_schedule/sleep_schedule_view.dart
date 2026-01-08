import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sleep_schedule_controller.dart';

class SleepScheduleView extends GetView<SleepScheduleController> {
  const SleepScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF20223F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF20223F),
        automaticallyImplyLeading: false,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screen.height),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF272E49),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(screen.width * 0.05),
                topRight: Radius.circular(screen.width * 0.05),
              ),
            ),
            padding: EdgeInsets.only(top: screen.height * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Pilih waktu bangun tidur mu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screen.width * 0.06,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screen.height * 0.025),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screen.height * 0.25,
                      width: screen.width * 0.25,
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: screen.height * 0.085,
                        perspective: 0.001,
                        diameterRatio: 9,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: controller.setHour,
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: _buildHourItems(screen),
                        ),
                      ),
                    ),
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: screen.width * 0.1,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: screen.height * 0.25,
                      width: screen.width * 0.25,
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: screen.height * 0.085,
                        perspective: 0.001,
                        diameterRatio: 9,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: controller.setMinute,
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: _buildMinuteItems(screen),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: screen.height * 0.056),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Waktu tidur ideal yang cukup adalah \nselama ',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: screen.width * 0.04,
                        color: Colors.white,
                      ),
                      children: const [
                        TextSpan(
                          text: '8 jam',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screen.height * 0.1),
                  child: Obx(
                    () => SizedBox(
                      height: screen.height * 0.0625,
                      width: screen.width * 0.875,
                      child: ElevatedButton(
                        onPressed: controller.canSave
                            ? () => controller.save(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A8B5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              screen.width * 0.075,
                            ),
                          ),
                        ),
                        child: controller.isSaving.value
                            ? SizedBox(
                                width: screen.height * 0.03,
                                height: screen.height * 0.03,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Tidur sekarang',
                                style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: screen.width * 0.045,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: controller.skip,
                  child: Text(
                    'Nanti saja',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                      fontSize: screen.width * 0.045,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHourItems(Size screen) {
    return List<Widget>.generate(24, (index) {
      final label = index.toString().padLeft(2, '0');
      return Obx(
        () => _PickerItem(
          label: label,
          isSelected: controller.selectedHour.value == index,
          screen: screen,
        ),
      );
    });
  }

  List<Widget> _buildMinuteItems(Size screen) {
    return List<Widget>.generate(60, (index) {
      final label = index.toString().padLeft(2, '0');
      return Obx(
        () => _PickerItem(
          label: label,
          isSelected: controller.selectedMinute.value == index,
          screen: screen,
        ),
      );
    });
  }
}

class _PickerItem extends StatelessWidget {
  const _PickerItem({
    required this.label,
    required this.isSelected,
    required this.screen,
  });

  final String label;
  final bool isSelected;
  final Size screen;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isSelected)
          Container(
            width: screen.width * 0.15,
            height: screen.height * 0.07,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2FF).withOpacity(0.5),
              borderRadius: BorderRadius.circular(screen.width * 0.025),
            ),
          ),
        Text(
          label,
          style: TextStyle(
            fontSize: screen.width * 0.1,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
