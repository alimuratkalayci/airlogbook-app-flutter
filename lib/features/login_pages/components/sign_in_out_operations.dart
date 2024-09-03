import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../root_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Oturum açık olan kullanıcıların cihaz kimliklerini saklamak için bir Firestore koleksiyonu
  final CollectionReference _userDevicesCollection = FirebaseFirestore.instance.collection('user_devices');

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      // Kullanıcıyı oturum açarak kimlik doğrulaması yap
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // E-posta doğrulama kontrolü
      if (user != null) {
        await user.reload(); // Kullanıcıyı yeniden yükle, böylece doğrulama durumu güncellenir
        if (user.emailVerified) {
          // Kullanıcının cihaz kimliğini Firestore'da sakla
          String uid = user.uid;

          // E-posta doğrulandı, kullanıcıyı ana sayfaya yönlendir
        } else {
          // E-posta doğrulanmamışsa e-posta doğrulama maili gönder
          await user.sendEmailVerification();

          // E-posta doğrulanmamışsa oturumu kapat ve uyarı göster
          await _auth.signOut();
          throw FirebaseAuthException(
            code: 'email-not-verified',
            message: 'Lütfen giriş yapmadan önce e-postanızı doğrulayın. Doğrulama e-postası gönderildi.',
          );
        }
      }
    } catch (e) {
      print('Giriş hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş hatası: ${e.toString()}')),
      );
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut(BuildContext context) async {
    try {
      // Oturumu açık olan kullanıcının kimliğini al
      String uid = _auth.currentUser!.uid;

      // Kullanıcının cihaz kimliğini Firestore'dan sil
      await _userDevicesCollection.doc(uid).delete();

      // Oturumu kapat
      await _auth.signOut();

      // Oturum kapandıktan sonra giriş sayfasına yönlendirme
    } catch (e) {
      print('Çıkış hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Çıkış hatası: ${e.toString()}')),
      );
      rethrow;
    }
  }

  // Farklı bir cihazdan oturum açan kullanıcıya uyarı gösteren fonksiyon
  Future<void> showWarningAndSignOut(BuildContext context) async {
    // Uyarıyı göstermek için bir dialog veya snackbar kullanabilirsiniz
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Farklı bir cihazdan giriş yapıldı. Oturum kapatılıyor.')),
    );

    // Oturumu kapat
    await signOut(context);
  }
}
