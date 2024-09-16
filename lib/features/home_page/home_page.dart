import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/last_flight_card/last_flight_card.dart';
import 'components/last_flight_card/last_flight_service.dart';
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
  DocumentSnapshot? lastFlight;

  @override
  void initState() {
    super.initState();
    getUserEmail();
    getUserName();
    fetchWeatherData();
    fetchLastFlight();
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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userName = userDoc['username'];
      });
    }
  }

  void fetchWeatherData() async {
    WeatherService weatherService = WeatherService();
    WeatherModel? fetchedWeather =
        await weatherService.fetchWeather('');

    if (fetchedWeather != null) {
      setState(() {
        weather = fetchedWeather;
      });
    } else {
      print('Weather data not loaded.');
    }
  }

  void fetchLastFlight() async {
    LastFlightService flightService = LastFlightService();
    DocumentSnapshot? fetchedFlight = await flightService.fetchLastFlight();
    setState(() {
      lastFlight = fetchedFlight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.BackgroundColor,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(bottom: 48),
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
                              color: AppTheme.AccentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  Row(
                    children: [
                      Expanded(child: LastFlightCard(lastFlight: lastFlight)),
                    ],
                  ),
                  if (weather != null) WeatherCard(weather: weather!),

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
