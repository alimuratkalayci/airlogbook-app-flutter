import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../general_components/custom_modal_bottom_sheet_alert_dialog/custom_modal_bottom_sheet.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthCubit()
      : _auth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance,
        super(AuthInitial());

  Future<void> signIn(BuildContext context, String email, String password) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          emit(AuthLoggedIn(user));
        } else {
          await user.sendEmailVerification();
          await _auth.signOut();
          showCustomModal(context:context, title: 'Verification Needed', message: 'Please verify your email address. A verification email has been sent.');
        }
      }
    } on FirebaseAuthException catch (e) {
      showCustomModal(context:context, title: 'Login Error', message: e.message ?? 'An error occurred during login.');
    }
  }

  Future<void> signUp(BuildContext context, String email, String password, String username) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'username': username,
          'email': email,
          'admin': 'no',
          'favorite_types': [],
          'subscription': 'no'
        });

        await user.sendEmailVerification();

        await FirebaseAuth.instance.signOut();

        showCustomModal(context: context, title: 'Registration Successful', message: 'Please verify your email address.');
      }
    } on FirebaseAuthException catch (e) {
      showCustomModal(context: context, title: 'Registration Error', message: 'An error occurred during registration.');
    }
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showCustomModal(context:context, title: 'Password Reset', message: 'Password reset email sent.');
      emit(AuthResetPasswordSuccess('Password reset email sent.'));
    } on FirebaseAuthException catch (e) {
      showCustomModal(context:context, title: 'Reset Error', message: e.message ?? 'An error occurred while sending reset email.');
    }
  }

  Future<void> signOut(BuildContext context) async {
    emit(AuthLoading());
    try {
      String uid = _auth.currentUser!.uid;
      await _firestore.collection('user_devices').doc(uid).delete();
      await _auth.signOut();
      emit(AuthLoggedOut());
    } catch (e) {
      showCustomModal(context:context, title: 'Sign Out Error', message: 'An error occurred while signing out: ${e.toString()}');
    }
  }

  Future<void> checkEmailVerification(BuildContext context) async {
    emit(AuthLoading());
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        showCustomModal(context:context, title: 'Email Verification Required', message: 'Your email has not been verified. Please verify your email before logging in.');
      }
    } catch (e) {
      showCustomModal(context:context, title: 'Verification Error', message: 'An error occurred during email verification check.');
    }
  }
}
