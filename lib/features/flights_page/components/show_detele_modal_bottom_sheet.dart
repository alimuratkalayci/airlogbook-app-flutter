import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<String?> showDeleteConfirmationBottomSheet(BuildContext context, String flightId) {
  return showMaterialModalBottomSheet<String?>(
    context: context,
    backgroundColor: Colors.transparent, // Modal arka plan rengini siyah yap
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Modal içeriği rengini beyaz yap
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0), // Üst köşeleri yuvarlat
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Are you sure you want to delete this flight?',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Yazı rengini siyah yap
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop('deleted'); // 'deleted' döndür
              },
              child: Text('Yes'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red, // Buton yazı rengini beyaz yap
                minimumSize: Size(double.infinity, 50), // Buton genişliğini tüm ekrana yay
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Modal'ı kapat
              },
              child: Text('No'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.grey, // Buton yazı rengini beyaz yap
                minimumSize: Size(double.infinity, 50), // Buton genişliğini tüm ekrana yay
              ),
            ),
          ],
        ),
      );
    },
  );
}
