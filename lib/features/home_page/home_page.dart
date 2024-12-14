import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/last_flight_card/last_flight_card.dart';
import 'components/last_flight_card/last_flight_service.dart';
import 'components/weather_card/weather_card.dart';
import 'components/weather_card/weather_model.dart';
import 'components/weather_card/weather_service.dart';
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
  String? userLocation;

  @override
  void initState() {
    super.initState();
    getUserEmail();
    getUserName();
    fetchWeatherData();
    fetchLastFlight();
    fetchUserLocation();
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
        await weatherService.fetchWeather(userLocation!);

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

  void fetchUserLocation() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userLocation = userDoc['location'];
      });
      fetchWeatherData(); // Konumu aldıktan sonra hava durumu verisini al
    }
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
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            'Welcome to Air Logbook'.toUpperCase(),
                            style: TextStyle(
                              color: AppTheme.TextColorBlack,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            ' $userName'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.AccentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: AppTheme.AccentColor,),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Before anything else,'
                              ' make sure to set the aircraft type you frequently use in the Settings section'
                              ' and update your location through the Set Location page to access the weather '
                              'conditions in your current region.',
                              style: TextStyle(fontWeight: FontWeight.normal,color: AppTheme.TextColorWhite),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
        ],
      ),
    );
  }
}
