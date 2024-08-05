import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

String formatDay(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('dd').format(parsedDate);
}

String formatMonthYear(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('MM-yyyy').format(parsedDate);
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
                .orderBy('date', descending: true)
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
                    total_time: flight['total_time'].toString(),
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
      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(formatDay(date),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 48)),
                  Text(formatMonthYear(date), style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(width: 16), // Space between date/time and other info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$departure'),
                        route.isEmpty ? Spacer() : Text('$route'),
                        Text('$arrival'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$total_time hours'),
                        Text('$aircraft_id'),
                        Text('$aircraft_type'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Column(
                children: [
                  Transform.rotate(
                    angle: 90 *
                        3.1415926535897932 /
                        180, // 90 dereceyi radyana çevir
                    child: Icon(
                      Icons.airplanemode_active_sharp,
                      size: 48,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
