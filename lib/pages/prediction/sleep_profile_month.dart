import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sleepys/pages/prediction/prediction.dart';
import 'package:sleepys/helper/api_endpoints.dart';

class SleepProfileMonth extends StatelessWidget {
  final String email;

  SleepProfileMonth({required this.email, Key? key}) : super(key: key);

  Future<void> getPrediction(BuildContext context) async {
    try {
      final url = ApiEndpoints.predictionsMonthly();

      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prediction = data['monthly_prediction'];

        
        await savePrediction(context, email, prediction);

        
        if (prediction == 'Normal') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NormalPage(email: email)));
        } else if (prediction == 'Sleep Apnea') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SleepApneaPage(email: email)));
        } else if (prediction == 'Insomnia') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InsomniaPage(email: email)));
        }
      }
    } catch (e) {
      
    }
  }

  Future<void> savePrediction(
      BuildContext context, String email, String prediction) async {
    try {
      final url = ApiEndpoints.predictionsMonthlySave();

      
      int predictionResult;
      if (prediction == 'Insomnia') {
        predictionResult = 0; 
      } else if (prediction == 'Normal') {
        predictionResult = 1; 
      } else if (prediction == 'Sleep Apnea') {
        predictionResult = 2; 
      } else {
        return;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'prediction_result': predictionResult,
        }),
      );

      if (response.statusCode == 200) {
        
      }
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20223F), 
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth * 0.10;
          double fontSize = constraints.maxWidth * 0.05;
          double buttonHeight = constraints.maxHeight * 0.07;
          double buttonWidth = constraints.maxWidth * 0.9;

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
                  SizedBox(height: 20),
                  InfoItemMonth(
                    text:
                        'Sleepy Panda bertujuan untuk memberikan edukasi dan informasi. Sleepy Panda berusaha untuk memberikan pemahaman lebih tentang pola tidur kamu. Tetapi, Sleepy Panda bukanlah alat diagnostik atau pengganti konsultasi dengan dokter.',
                  ),
                  InfoItemMonth(
                    text:
                        'Profil tidur yang disediakan oleh Sleepy Panda berdasarkan data tidur yang kamu berikan, dan bertujuan untuk memberikan rekomendasi terkait pola tidur atau potensi kesehatan.',
                  ),
                  InfoItemMonth(
                    text:
                        'Kami selalu menyarankan untuk berkonsultasi dengan dokter atau ahli tidur jika mengalami masalah tidur yang serius atau berkelanjutan.',
                  ),
                  InfoItemMonth(
                    text: 'Hasil profil tidur dapat berubah seiring waktu.',
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      height: buttonHeight,
                      width: buttonWidth,
                      child: ElevatedButton(
                        onPressed: () {
                          getPrediction(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00A99D), 
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoItemMonth extends StatelessWidget {
  final String text;

  InfoItemMonth({required this.text});

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
          SizedBox(width: 12),
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
