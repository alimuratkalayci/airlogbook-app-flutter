import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../root_screen.dart';
import '../../../theme/theme.dart';

import '../components/sign_in_out_operations.dart';
import '../forgot_password_page/forgot_password_page.dart';
import '../sign_up_page/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  String email = '';
  String password = '';
  bool isValidEmail = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.BackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'AIR LOGBOOK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.AccentColor,
                      fontSize: 24,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
/*               Image.asset(
                'assets/images/sign_in_up_logo.png',
                width: 220,
                height: 200,
                fit: BoxFit.cover,
              ),*/
              SizedBox(
                height: 32,
              ),
              TextFormField(
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                cursorColor: Color(0xff28397f),
                onChanged: (value) {
                  setState(() {
                    email = value;
                    isValidEmail = isValidEmailFormat(email);
                  });
                },
              ),
              if (!isValidEmail)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Please enter a valid email.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                cursorColor: Color(0xff28397f),
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
              ),
              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage()),
                        );
                      },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.AccentColor),
                      )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _authService.signIn(context, email, password);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RootScreen()),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.AccentColor),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmailFormat(String email) {
    String emailRegex = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }
}
