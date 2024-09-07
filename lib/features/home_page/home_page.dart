import 'package:coin_go/features/home_page/sub_pages/add_favorite_aircraft_page/add_favorite_aircraft_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/weather_card/weather_card.dart';
import 'components/weather_card/weather_model.dart';
import 'components/weather_card/weather_service.dart';
import '../../general_components/google_ads/google_ads.dart';
import '../../theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userEmail;
  String? userName;
  WeatherModel? weather;

  @override
  void initState() {
    super.initState();
    getUserEmail();
    getUserName();
    fetchWeatherData();
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

  void fetchWeatherData() async {
    WeatherService weatherService = WeatherService();
    WeatherModel? fetchedWeather = await weatherService.fetchWeather('çankaya');

    if (fetchedWeather != null) {
      setState(() {
        weather = fetchedWeather;
      });
    } else {
      print('Hava durumu verisi yüklenemedi.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.BackgroundColor,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(bottom: 48), // Alttaki reklam için
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (userName != null) ...[
                    SizedBox(height: 8),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome to Air Logbook',
                            style: TextStyle(color: AppTheme.TextColorBlack),
                          ),
                          Text(
                            ' $userName'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (weather != null) WeatherCard(weather: weather!),

                  Padding(
                    padding: const EdgeInsets.only(right: 16,left: 16),
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
                            child: Text(
                              'Add Favorite Aircraft',
                              style: TextStyle(color: AppTheme.TextColorWhite),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.AccentColor,
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
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GoogleAds.getBannerAdWidget(),
          ),
        ],
      ),
    );
  }
}
