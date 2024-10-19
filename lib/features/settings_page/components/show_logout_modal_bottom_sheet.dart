import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../theme/theme.dart';
import '../../login_pages/sign_in_page/sign_in_page.dart';


Future<String?> showLogoutConfirmationBottomSheet(BuildContext context) {
  return showMaterialModalBottomSheet<String?>(
    context: context,
    backgroundColor: Colors.transparent, // Modal arka plan rengini siyah yap
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppTheme.BackgroundColor, // Modal içeriği rengini beyaz yap
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0), // Üst köşeleri yuvarlat
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
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
                      Navigator.of(context).pop('logged_out'); // 'signOuted' döndür
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
                      Navigator.of(context).pop(); // 'No' butonuna basıldığında modalı kapat
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
