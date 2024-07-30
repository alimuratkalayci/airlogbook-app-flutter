import 'package:coin_go/features/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../root_screen.dart';


class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';
  bool isValidEmail = true;

  void _signInWithEmailAndPassword(BuildContext context) async {
    if (isValidEmail) {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RootScreen()),
        );

      } catch (e) {
        print('Giriş hatası: $e');
        showErrorMessage(context, 'Login failed. Please check your credentials.');
      }
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: TextStyle(color: Color(0xff28397f)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff28397f)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff28397f)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff28397f)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: TextStyle(color: Color(0xff28397f)),
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
                labelStyle: TextStyle(color: Color(0xff28397f)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff28397f)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff28397f)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff28397f)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: TextStyle(color: Color(0xff28397f)),
              cursorColor: Color(0xff28397f),
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _signInWithEmailAndPassword(context);
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.all(Color(0xff28397f)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Burada border radius'u ayarlayabilirsiniz
                        ),
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
                Text("Don't have an account?",style: TextStyle(fontWeight: FontWeight.w700),),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: Text("Sign Up",style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xff28397f)),)),
              ],
            ),
          ],
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
