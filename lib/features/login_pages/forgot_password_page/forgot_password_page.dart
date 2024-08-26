import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/sign_in_out_operations.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final AuthService _authService = AuthService(); // AuthService örneği
  final TextEditingController emailController = TextEditingController();
  bool _isProcessing = false;

  void _resetPassword() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await _authService.resetPassword(emailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset email has been sent!',
            style: TextStyle(color: Colors.green),
          ),
        ),
      );

      Navigator.pop(context); // Kullanıcıyı geri yönlendirin
    } catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is invalid.';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(color: Colors.red),
          ),
        ),
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
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            _isProcessing
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }
}
