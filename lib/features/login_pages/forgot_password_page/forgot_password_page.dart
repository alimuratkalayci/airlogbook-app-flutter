import 'package:coin_go/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../general_components/custom_modal_bottom_sheet_alert_dialog/custom_modal_bottom_sheet.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool _isProcessing = false;


  void _resetPassword() async {
    if (emailController.text.trim().isEmpty) {
      showCustomModal(
        context: context,
        title: 'Error',
        message: 'Please enter your email address!',
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showCustomModal(
        context: context,
        title: 'Success',
        message: 'Password reset email has been sent!',
      );
      emailController.clear();
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid.';
      }
      showCustomModal(
        context: context,
        title: 'Error',
        message: '$errorMessage',
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.BackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.AccentColor,
        foregroundColor: AppTheme.TextColorWhite,
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text('You can reset your password using the password reset link sent to your email.'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: TextStyle(color: AppTheme.AccentColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: AppTheme.AccentColor,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: AppTheme.AccentColor,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: AppTheme.AccentColor,
                    width: 2.0,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _isProcessing
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                      child: ElevatedButton(
                                        onPressed: _resetPassword,
                                        child: Text('Send Reset Link',style: TextStyle(color: AppTheme.TextColorWhite),),
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
      ),
    );
  }
}
