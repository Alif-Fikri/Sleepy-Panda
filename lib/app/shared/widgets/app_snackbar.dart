import 'package:flutter/material.dart';

class AppSnackbar {
  const AppSnackbar._();

  static void show(BuildContext context, String message) {
    final screenSize = MediaQuery.of(context).size;

    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.015,
          horizontal: screenSize.width * 0.05,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2C4E),
          borderRadius: BorderRadius.circular(screenSize.width * 0.04),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.white,
              size: screenSize.width * 0.05,
            ),
            SizedBox(width: screenSize.width * 0.03),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.035,
                ),
              ),
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
        vertical: screenSize.height * 0.02,
        horizontal: screenSize.width * 0.04,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
