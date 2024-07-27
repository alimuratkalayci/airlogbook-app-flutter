import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_go/features/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool passwordsMatch = true;
  bool usernameAvailable = true;
  bool _isProcessing = false; // Dönme efekti için
  bool _isButtonDisabled = false;

  void _signUp(BuildContext context) async {
    if (passwordController.text == confirmPasswordController.text) {
      try {
        // Kullanıcı adının benzersiz olup olmadığını kontrol et
        final usernameExists = await _checkUsernameExists(usernameController.text);
        if (usernameExists) {
          setState(() {
            usernameAvailable = false; // Kullanıcı adı zaten kullanımda
          });
          return;
        }

        // Kayıt işlemi
        setState(() {
          _isProcessing = true;
          _isButtonDisabled = true;
        });

        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Kullanıcı bilgilerini Firestore'a kaydet
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'username': usernameController.text,
          'email': emailController.text,
          'balance': 0,
          'admin': 'no'
        });

        // Kayıt başarılıysa Sign In sayfasına yönlendirme
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
              (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Your registration is completed!',
              style: TextStyle(color: Colors.green),
            ),
          ),
        );

        print('User ID: ${userCredential.user!.uid}');
      } catch (e) {
        print('Kayıt hatası: $e');

        // Hata durumunu işleme
        String errorMessage = 'An error occurred during registration.';
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            errorMessage = 'This email is already in use. Please use a different email.';
          } else if (e.code == 'weak-password') {
            errorMessage = 'The password provided is too weak.';
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
          _isButtonDisabled = false;
        });
      }
    } else {
      // Şifreler uyuşmuyorsa uyarı göster
      setState(() {
        passwordsMatch = false;
      });
    }
  }

  Future<bool> _checkUsernameExists(String username) async {
    // Firestore'da username koleksiyonunda bu username var mı diye kontrol et
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffbac18),
      appBar: AppBar(
        backgroundColor: Color(0xfffbac18),
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.white, letterSpacing: 5),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            if (!usernameAvailable)
              Text(
                'Username is already taken!',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 8,),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: TextStyle(color: Colors.white, letterSpacing: 5),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 8,),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white, letterSpacing: 5),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 8,),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Repeat Password',
                labelStyle: TextStyle(color: Colors.white, letterSpacing: 5),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              obscureText: true,
            ),
            if (!passwordsMatch)
              Text(
                'Passwords do not match!',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isButtonDisabled ? null : () => _signUp(context),
                    child: _isProcessing
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: _isButtonDisabled
                          ? WidgetStateProperty.all(Colors.grey)
                          : WidgetStateProperty.all(Color(0xff28397f)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
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
