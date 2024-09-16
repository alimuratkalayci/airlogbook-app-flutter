import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LastFlightService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentSnapshot?> fetchLastFlight() async {
    var userId = _auth.currentUser?.uid ?? '';

    if (userId.isNotEmpty) {
      print("Fetching flights for user ID: $userId");

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('my_flights')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Eğer doküman varsa, ilkini döndür
        return snapshot.docs.first;
      } else {
        print("No flights found.");
        return null;
      }
    } else {
      print('Kullanıcı giriş yapmamış');
      return null;
    }
  }
}
