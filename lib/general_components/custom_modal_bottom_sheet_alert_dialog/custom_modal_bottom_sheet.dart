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
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16,bottom: 16,left: 8,right: 8),
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
