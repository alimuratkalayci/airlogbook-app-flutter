import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_go/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../general_components/custom_modal_bottom_sheet_alert_dialog/custom_modal_bottom_sheet.dart';
import '../../../login_pages/welcome_page/welcome_screen.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _textController = TextEditingController();
  bool _isButtonEnabled = false;

  void _checkInput() {
    setState(() {
      _isButtonEnabled = _textController.text.trim() == 'I accept';
    });
  }

  Future<void> _deleteAccount() async {
    try {
      await _deleteUserData();

      await _auth.currentUser?.delete();

      await _auth.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    } catch (e) {
      print('Account deletion failed: $e');
      showCustomModal(
        context: context,
        title: 'Error',
        message: 'Failed to delete your account.',
      );
    }
  }



  Future<void> _deleteUserData() async {
    final userId = _auth.currentUser?.uid;

    if (userId != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(userId).delete();
        print('User data deleted successfully.');
      } catch (e) {
        print('Failed to delete user data: $e');
        throw e; // Hata durumu için fırlat
      }
    } else {
      print('No user is currently logged in.');
    }
  }


  InputDecoration customInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: AppTheme.TextColorWhite,
      ),
      hintText: 'You must write $labelText',
      hintStyle: TextStyle(
        color: AppTheme.TextColorWhite,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: AppTheme.TextColorWhite,
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: AppTheme.TextColorWhite,
          width: 2.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: AppTheme.Green,
          width: 2.0,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.BackgroundColor,
      appBar: AppBar(
        foregroundColor: AppTheme.TextColorWhite,
        title: const Text('Delete Account'),
        backgroundColor: AppTheme.AccentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
              child: const Text(
                'When you delete your account, your data will be permanently removed. If you would like to proceed with this action, please fill out the field below.',style: TextStyle(fontSize: 16),),),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.AccentColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _textController,
                        style: TextStyle(color: AppTheme.TextColorWhite),
                        decoration: customInputDecoration('I accept'),
                        onChanged: (value) {
                          _checkInput();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled ? _deleteAccount : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.AccentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Delete My Account',
                      style: TextStyle(color: AppTheme.TextColorWhite),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
