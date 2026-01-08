import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'prediction_agreement_controller.dart';

class PredictionAgreementView extends GetView<PredictionAgreementController> {
  const PredictionAgreementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF20223F),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final padding = constraints.maxWidth * 0.10;
          final fontSize = constraints.maxWidth * 0.05;
          final buttonHeight = constraints.maxHeight * 0.07;
          final buttonWidth = constraints.maxWidth * 0.9;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sebelum melanjutkan..',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _InfoItem(
                    text:
                        'Sleepy Panda bertujuan untuk memberikan edukasi dan informasi. Sleepy Panda berusaha untuk memberikan pemahaman lebih tentang pola tidur kamu. Tetapi, Sleepy Panda bukanlah alat diagnostik atau pengganti konsultasi dengan dokter.',
                  ),
                  const _InfoItem(
                    text:
                        'Profil tidur yang disediakan oleh Sleepy Panda berdasarkan data tidur yang kamu berikan, dan bertujuan untuk memberikan rekomendasi terkait pola tidur atau potensi kesehatan.',
                  ),
                  const _InfoItem(
                    text:
                        'Kami selalu menyarankan untuk berkonsultasi dengan dokter atau ahli tidur jika mengalami masalah tidur yang serius atau berkelanjutan.',
                  ),
                  const _InfoItem(
                    text: 'Hasil profil tidur dapat berubah seiring waktu.',
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      height: buttonHeight,
                      width: buttonWidth,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.requestPrediction(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A99D),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Ya, saya mengerti',
                                  style: TextStyle(
                                    fontSize: fontSize * 0.6,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
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
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/ceklis.png',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
