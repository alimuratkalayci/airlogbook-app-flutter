import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // DateFormat için eklenen kütüphane
import '../theme/theme.dart';

class GiveawayPage extends StatelessWidget {
  const GiveawayPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('giveaways')
            .where('status', isEqualTo: 'active')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Henüz aktif çekiliş yok.'));
          }

          List<DocumentSnapshot> giveaways = snapshot.data!.docs;

          return ListView.builder(
            itemCount: giveaways.length,
            itemBuilder: (context, index) {
              var giveaway = giveaways[index];
              DateTime startDate = (giveaway['start_date'] as Timestamp).toDate().toLocal();
              DateTime endDate = (giveaway['end_date'] as Timestamp).toDate();

              // DateFormat ile tarihleri istediğiniz formatta biçimlendirme
              String formattedStartDate = DateFormat('dd.MM.yyyy').format(startDate);
              String formattedEndDate = DateFormat('dd.MM.yyyy').format(endDate);

              return Card(
                color: AppTheme.darkAccentColor,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (giveaway['title'] != null)
                                Text(
                                  'Başlık: ${giveaway['title']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              SizedBox(height: 8),
                              if (giveaway['item'] != null)
                                Text(
                                  'Eşya: ${giveaway['item']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              SizedBox(height: 8),
                              if (giveaway['duration'] != null)
                                Text(
                                  'Süre: ${giveaway['duration']}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              SizedBox(height: 8),
                              if (giveaway['start_date'] != null)
                                Text(
                                  'Başlangıç: $formattedStartDate',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              SizedBox(height: 8),
                              if (giveaway['end_date'] != null)
                                Text(
                                  'Bitiş: $formattedEndDate',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              SizedBox(height: 16),


                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              if (giveaway['imageUrl'] != null)
                                Image.network(
                                  giveaway['imageUrl'],
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) =>
                                  loadingProgress == null
                                      ? child
                                      : Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                          : null,
                                    ),
                                  ),
                                ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => _buyTicket(context, giveaway),
                                child: Text(
                                  'Bileti Satın Al',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.darkAccentColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<double> _getUserBalance() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('Kullanıcı oturumu açık değil.');
    }

    DocumentSnapshot userSnapshot = await firestore.collection('users').doc(currentUser.uid).get();
    return (userSnapshot['balance'] ?? 0.0).toDouble();
  }

  Future<void> _updateUserBalance(double amount) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('Kullanıcı oturumu açık değil.');
    }

    await firestore.collection('users').doc(currentUser.uid).update({
      'balance': FieldValue.increment(-amount),
    });
  }

  void _buyTicket(BuildContext context, DocumentSnapshot giveaway) async {
    double ticketPrice = giveaway['ticket_price']; // Bilet fiyatını al
    String giveawayId = giveaway.id;
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lütfen önce giriş yapın.'),
      ));
      return;
    }

    try {
      double currentBalance = await _getUserBalance();

      if (currentBalance < ticketPrice) {
        bool addBalance = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Bakiye Yetersiz'),
            content: Text('Bakiyeniz yeterli değil. Bakiye eklemek ister misiniz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Hayır'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  // Bakiye ekleme sayfasına yönlendirme işlemi
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => WalletPage()));
                },
                child: Text('Evet'),
              ),
            ],
          ),
        );

        if (addBalance) {
          // Kullanıcı bakiye eklemek isterse burada işlemler yapılabilir
          // Örneğin, bakiye ekleme sayfasına yönlendirme yapılabilir
          // Navigator.push(context, MaterialPageRoute(builder: (context) => WalletPage()));
        }
      } else {
        // Bakiye yeterliyse bilet satın alma işlemi
        await _updateUserBalance(ticketPrice);

        // Şimdi çekiliş belgesine katılım eklemesi yapalım
        await FirebaseFirestore.instance.collection('giveaways').doc(giveawayId).update({
          'participants.${currentUser.uid}': FieldValue.increment(1), // Kullanıcının bilet sayısını artır
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Bilet satın alma işlemi başarılı!'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Bilet satın alma işlemi sırasında bir hata oluştu: $e'),
      ));
    }
  }
}
