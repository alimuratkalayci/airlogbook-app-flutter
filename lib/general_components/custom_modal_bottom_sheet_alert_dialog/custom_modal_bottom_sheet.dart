import 'package:flutter/material.dart';

import '../../theme/theme.dart';

Future<void> showCustomModal({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.BackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      final notchWidth = screenWidth * 0.20; // Çentiğin genişliği
      final notchHeight = screenHeight * 0.005; // Çentiğin yüksekliği

      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // iPhone çentiği
            Center(
              child: Container(
                width: notchWidth,
                height: notchHeight,
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(top: 0,bottom: 16,left: 8,right: 8),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.AccentColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16,left: 8,right: 8),
              child: Text(
                message,
                style: TextStyle(fontSize: 16, color: AppTheme.TextColorBlack,fontWeight: FontWeight.w400),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.AccentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay', style: TextStyle(color: AppTheme.TextColorWhite),),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
