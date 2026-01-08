import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerWidth = size.width * 0.85;

    return Scaffold(
      backgroundColor: const Color(0xFF20223F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF20223F),
        foregroundColor: Colors.white,
        title: const Text('Feedback'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: size.width * 0.12,
                  backgroundColor: const Color(0xFF272E49),
                  child: Icon(
                    Icons.feedback,
                    color: Colors.blue.shade700,
                    size: size.width * 0.14,
                  ),
                ),
                SizedBox(height: size.height * 0.025),
                Text(
                  'Beritahu Kami Jika Terjadi Bug!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.055,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Urbanist',
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  'Kami akan segera memperbaikinya...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: size.width * 0.038,
                    fontFamily: 'Urbanist',
                  ),
                ),
                SizedBox(height: size.height * 0.035),
                SizedBox(
                  width: containerWidth,
                  child: TextFormField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      hintText: 'Email kamu',
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                        fontFamily: 'Urbanist',
                      ),
                      filled: true,
                      fillColor: const Color(0xFF272E49),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email wajib diisi';
                      }
                      const pattern =
                          r'^([a-zA-Z0-9.!#%&"*+/=?^_`{|}~-]+)@([a-zA-Z0-9-]+)(\.[a-zA-Z0-9-]+)+$';
                      if (!RegExp(pattern).hasMatch(value)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.025),
                SizedBox(
                  width: containerWidth,
                  child: TextFormField(
                    controller: controller.feedbackController,
                    maxLines: 5,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Urbanist',
                    ),
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      prefixIcon:
                          const Icon(Icons.comment, color: Colors.white),
                      hintText: 'Tulis feedback kamu di sini',
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                        fontFamily: 'Urbanist',
                      ),
                      filled: true,
                      fillColor: const Color(0xFF272E49),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Feedback tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.035),
                Obx(
                  () => SizedBox(
                    width: containerWidth,
                    child: ElevatedButton(
                      onPressed: controller.isSubmitting.value
                          ? null
                          : () => controller.submit(context),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.018,
                        ),
                        backgroundColor: const Color(0xFF00ADB5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isSubmitting.value
                          ? SizedBox(
                              height: size.height * 0.03,
                              width: size.height * 0.03,
                              child: const CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Kirim',
                              style: TextStyle(
                                fontSize: size.width * 0.045,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Urbanist',
                              ),
                            ),
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
}
