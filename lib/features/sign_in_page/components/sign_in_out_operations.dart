import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Oturum açık olan kullanıcıların cihaz kimliklerini saklamak için bir Firestore koleksiyonu
  final CollectionReference _userDevicesCollection = FirebaseFirestore.instance.collection('user_devices');

  Future<void> signIn(String email, String password) async {
    // Kullanıcıyı oturum açarak kimlik doğrulaması yap
    await _auth.signInWithEmailAndPassword(email: email, password: password);

    // Oturum açan kullanıcının kimliğini al
    String uid = _auth.currentUser!.uid;

    // Kullanıcının cihaz kimliğini Firestore'da sakla
    await _userDevicesCollection.doc(uid).set({'device_id': 'current_device_id'});
  }

  Future<void> signOut() async {
    // Oturumu açık olan kullanıcının kimliğini al
    String uid = _auth.currentUser!.uid;

    // Kullanıcının cihaz kimliğini Firestore'dan sil
    await _userDevicesCollection.doc(uid).delete();

    // Oturumu kapat
    await _auth.signOut();
  }

  // Farklı bir cihazdan oturum açan kullanıcıya uyarı gösteren fonksiyon
  Future<void> showWarningAndSignOut() async {
    // Uyarıyı göstermek ve oturumu kapatmak için gereken işlemleri yapın
  }
}
