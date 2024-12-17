import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../general_components/custom_modal_bottom_sheet_alert_dialog/custom_modal_bottom_sheet.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference _userDevicesCollection = FirebaseFirestore.instance.collection('user_devices');

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await user.reload();
        if (user.emailVerified) {

          String uid = user.uid;

        }
        else {
          await user.sendEmailVerification();

          await _auth.signOut();
          showCustomModal(
            context: context,
            title: 'Email Not Verified',
            message: 'Please verify your email address before logging in. A verification email has been sent.',
          );
        }
      }
    } catch (e) {
      print('Login error: $e');
      showCustomModal(
        context: context,
        title: 'Error',
        message: 'Login error',
      );
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut(BuildContext context) async {
    try {
      String uid = _auth.currentUser!.uid;

      await _userDevicesCollection.doc(uid).delete();

      await _auth.signOut();

    } catch (e) {
      print('Çıkış hatası: $e');
      showCustomModal(
        context: context,
        title: 'Logout error',
        message: 'An error occurred: ${e.toString()}',
      );

      rethrow;
    }
  }

  Future<void> showWarningAndSignOut(BuildContext context) async {
    //TODO DEVICE ID WILL ADD
    showCustomModal(
      context: context,
      title: 'Login From Another Device',
      message: 'You have been logged out due to login from a different device.',
    );

    await signOut(context);
  }
}
