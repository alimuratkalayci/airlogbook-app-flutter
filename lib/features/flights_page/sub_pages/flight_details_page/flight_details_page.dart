import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlightDetailsPage extends StatelessWidget {
  final String flightId;
  final String userId;

  FlightDetailsPage({required this.flightId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.deepOrange,
        title: Text('Flight Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('my_flights')
            .doc(flightId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          var flightData = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              buildDetailCard('Date', flightData['date']),
              buildDetailCard('Aircraft Type', flightData['aircraft_type']),
              buildDetailCard('Aircraft ID', flightData['aircraft_id']),
              buildDetailCard('Departure Airport', flightData['departure_airport']),
              buildDetailCard('Route', flightData['route']),
              buildDetailCard('Arrival Airport', flightData['arrival_airport']),
              buildDetailCard('Hobbs In', flightData['hobbs_in']),
              buildDetailCard('Hobbs Out', flightData['hobbs_out']),
              buildDetailCard('Total Time', flightData['total_time']),
              buildDetailCard('Night Time', flightData['night_time']),
              buildDetailCard('PIC', flightData['pic']),
              buildDetailCard('Dual Received', flightData['dual_rcvd']),
              buildDetailCard('Solo', flightData['solo']),
              buildDetailCard('XC', flightData['xc']),
              buildDetailCard('Simulated Instrument', flightData['sim_inst']),
              buildDetailCard('Actual Instrument', flightData['actual_inst']),
              buildDetailCard('Simulator', flightData['simulator']),
              buildDetailCard('Ground', flightData['ground']),
              buildDetailCard('Day Takeoffs', flightData['day_to']),
              buildDetailCard('Day Landings', flightData['day_ldg']),
              buildDetailCard('Night Takeoffs', flightData['night_to']),
              buildDetailCard('Night Landings', flightData['night_ldg']),
              buildRemarksCard('Remarks', flightData['remarks']),
            ],
          );
        },
      ),
    );
  }

  Widget buildDetailCard(String title, dynamic value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value != null ? value.toString() : '0',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRemarksCard(String title, dynamic value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              value != null ? value.toString() : '0',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
