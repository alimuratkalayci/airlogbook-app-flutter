import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flights',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyFlightsPage(),
    );
  }
}

class MyFlightsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('User not logged in'));
          }
          final String userID = snapshot.data!.uid;

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userID)
                .collection('my_flights')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var flights = snapshot.data!.docs;

              return ListView.builder(
                itemCount: flights.length,
                itemBuilder: (context, index) {
                  var flight = flights[index];
                  return FlightCard(
                    date: flight['date'],
                    total_time: flight['total_time'],
                    aircraft_id: flight['aircraft_id'],
                    aircraft_type: flight['aircraft_type'],
                    departure: flight['departure_airport'],
                    route: flight['route'],
                    arrival: flight['arrival_airport'],
                    onTap: () {
                      // TODO: Implement navigation or action on tap
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class FlightCard extends StatelessWidget {
  final String date;
  final String total_time;
  final String aircraft_id;
  final String aircraft_type;
  final String departure;
  final String route;
  final String arrival;
  final VoidCallback onTap;

  FlightCard({
    required this.date,
    required this.total_time,
    required this.aircraft_id,
    required this.aircraft_type,
    required this.departure,
    required this.route,
    required this.arrival,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: $date', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text('Time: $total_time'),
              SizedBox(height: 10),
              Text('Aircraft ID: $aircraft_id'),
              Text('Aircraft Type: $aircraft_type'),
              SizedBox(height: 10),
              Text('Departure: $departure'),
              Text('Route: $route'),
              Text('Destination: $arrival'),
            ],
          ),
        ),
      ),
    );
  }
}
