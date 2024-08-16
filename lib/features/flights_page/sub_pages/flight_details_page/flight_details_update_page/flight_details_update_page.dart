import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlightDetailsUpdatePage extends StatefulWidget {
  final String flightId;
  final String userId;

  FlightDetailsUpdatePage({required this.flightId, required this.userId});

  @override
  _FlightDetailsUpdatePageState createState() => _FlightDetailsUpdatePageState();
}

class _FlightDetailsUpdatePageState extends State<FlightDetailsUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> flightData = {};

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
            .doc(widget.userId)
            .collection('my_flights')
            .doc(widget.flightId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          flightData = snapshot.data!.data() as Map<String, dynamic>;

          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                buildEditableCard('Date', 'date'),
                buildEditableCard('Aircraft Type', 'aircraft_type'),
                buildEditableCard('Aircraft ID', 'aircraft_id'),
                buildEditableCard('Departure Airport', 'departure_airport'),
                buildEditableCard('Route', 'route'),
                buildEditableCard('Arrival Airport', 'arrival_airport'),
                buildEditableCard('Hobbs In', 'hobbs_in'),
                buildEditableCard('Hobbs Out', 'hobbs_out'),
                buildEditableCard('Total Time', 'total_time'),
                buildEditableCard('Night Time', 'night_time'),
                buildEditableCard('PIC', 'pic'),
                buildEditableCard('Dual Received', 'dual_rcvd'),
                buildEditableCard('Solo', 'solo'),
                buildEditableCard('XC', 'xc'),
                buildEditableCard('Simulated Instrument', 'sim_inst'),
                buildEditableCard('Actual Instrument', 'actual_inst'),
                buildEditableCard('Simulator', 'simulator'),
                buildEditableCard('Ground', 'ground'),
                buildEditableCard('Day Takeoffs', 'day_to'),
                buildEditableCard('Day Landings', 'day_ldg'),
                buildEditableCard('Night Takeoffs', 'night_to'),
                buildEditableCard('Night Landings', 'night_ldg'),
                buildRemarksCard('Remarks', 'remarks'),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      updateFlightDetails();
                    }
                  },
                  child: Text('Update Flight'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildEditableCard(String title, String field) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          initialValue: flightData[field] != null ? flightData[field].toString() : '',
          decoration: InputDecoration(
            labelText: title,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          onChanged: (newValue) {
            flightData[field] = newValue; // Directly update the map
          },
        ),
      ),
    );
  }

  Widget buildRemarksCard(String title, String field) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          initialValue: flightData[field] != null ? flightData[field].toString() : '',
          decoration: InputDecoration(
            labelText: title,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          maxLines: null,
          onChanged: (newValue) {
            flightData[field] = newValue; // Directly update the map
          },
        ),
      ),
    );
  }

  void updateFlightDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('my_flights')
          .doc(widget.flightId)
          .update(flightData);

      // Başarıyla güncellendikten sonra başarı mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Flight details updated successfully!')),
      );

      // Güncelleme işlemi başarılıysa 'updated' değeriyle geri dön
      Navigator.pop(context, 'updated');
    } catch (e) {
      // Hata durumunda kullanıcıya bilgi ver ve 'error' değeriyle geri dön
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update flight details: $e')),
      );
      Navigator.pop(context, 'error');
    }
  }

}
