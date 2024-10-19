import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class GeneralAlertDialog {
  static void show(BuildContext context, String message) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0), // Sağ ve sol 24 padding
            child: CupertinoAlertDialog(
              title: Text('Alert'),
              content: Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Container(
                    color: AppTheme.AccentColor, // OK butonunun arka plan rengi
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: AppTheme.TextColorWhite,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0), // Sağ ve sol 24 padding
            child: AlertDialog(
              title: Text('Alert'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AppTheme.AccentColor), // OK butonunun arka plan rengi
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(color: AppTheme.TextColorWhite), // Yazı rengi
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
