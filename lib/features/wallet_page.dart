import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth kütüphanesi

import '../theme/theme.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({Key? key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser; // Firebase Authentication kullanıcısını al

    if (user == null) {
      // Eğer kullanıcı yoksa, uygun bir hata mesajı veya işlem yapılabilir.
      return Scaffold(
        body: Center(
          child: Text('Kullanıcı girişi yapmalısınız.'),
        ),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: getUserData(user.uid), // Firebase UID'sini kullanarak kullanıcı verilerini al
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Hata: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('Kullanıcı bulunamadı.'));
        }

        // Kullanıcı verisi alındığında işlemleri yap
        final userData = snapshot.data!;
        final balance = userData['balance'] ?? 0.0; // Bakiye alınır

        return Scaffold(
          backgroundColor: AppTheme.darkBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppTheme.darkAccentColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: Text(
                                'Total Balance',
                                style: TextStyle(color: Colors.white, fontSize: 24),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Text(
                                '\$ ${balance.toStringAsFixed(2)} USD',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              child: Divider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: GestureDetector(
                          onTap: () {
                            print('add funds');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.darkAccentColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Icon(
                                    Icons.attach_money,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Add Funds',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: GestureDetector(
                          onTap: () {
                            print('earn money');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.darkAccentColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Icon(
                                    Icons.attach_money,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Earn Money',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
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
      },
    );
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot userSnapshot = await firestore.collection('users').doc(uid).get();
      return userSnapshot;
    } catch (e) {
      throw Exception('Kullanıcı verisi alınırken hata oluştu: $e');
    }
  }
}
