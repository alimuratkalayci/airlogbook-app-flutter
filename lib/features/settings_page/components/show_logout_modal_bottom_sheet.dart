import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../theme/theme.dart';

Future<String?> showLogoutConfirmationBottomSheet(BuildContext context) {
  return showMaterialModalBottomSheet<String?>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {

      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;


      final notchWidth = screenWidth * 0.20;
      final notchHeight = screenHeight * 0.005;

      return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppTheme.BackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

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
            Text(
              'Are you sure you want to logout?',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppTheme.AccentColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop('logged_out');
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(color: AppTheme.TextColorWhite),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'No',
                      style: TextStyle(color: AppTheme.TextColorWhite),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.AccentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
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
