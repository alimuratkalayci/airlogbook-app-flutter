import 'package:carousel_slider/carousel_slider.dart';
import 'package:coin_go/features/home_page/sub_pages/add_favorite_aircraft_page/add_favorite_aircraft_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userEmail;
  String? userName;

  @override
  void initState() {
    super.initState();
    getUserEmail();
    getUserName();
  }

  void getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email;
    });
  }

  void getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userName = userDoc['username'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userName != null) ...[
                SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to Pilot Logbook',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        ' $userName',
                        style: TextStyle(color: Colors.deepOrange,fontSize: 16,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddFavoriteAircraftPage(),
                            ),
                          );
                        },
                        child: Text('Add Favorite Aircraft',style: TextStyle(color: Colors.black),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),
/*               Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CarouselSlider(
                  options: CarouselOptions(height: 150, autoPlay: true),
                  items: [1, 2, 3].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: GestureDetector(
                            onTap: () {
                              print('tıklandı');
                              // TODO: SONRA EKLE
                              /* Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpPage()),
                              ); */
                            },
                            child: Card(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}
