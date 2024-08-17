import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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
                buildNonEditableCard('Date', 'date'),
                buildNonEditableCard('Aircraft Type', 'aircraft_type'),
                buildEditableCard('Aircraft ID', 'aircraft_id'),
                buildEditableCard('Departure Airport', 'departure_airport'),
                buildEditableCard('Route', 'route'),
                buildEditableCard('Arrival Airport', 'arrival_airport'),
                buildEditableCard('Hobbs In', 'hobbs_in', isDouble: true),
                buildEditableCard('Hobbs Out', 'hobbs_out', isDouble: true),
                buildEditableCard('Total Time', 'total_time', isDouble: true),
                buildEditableCard('Night Time', 'night_time', isDouble: true),
                buildEditableCard('PIC', 'pic', isDouble: true),
                buildEditableCard('Dual Received', 'dual_rcvd', isDouble: true),
                buildEditableCard('Solo', 'solo'),
                buildEditableCard('XC', 'xc', isDouble: true),
                buildEditableCard('Simulated Instrument', 'sim_inst', isDouble: true),
                buildEditableCard('Actual Instrument', 'actual_inst', isDouble: true),
                buildEditableCard('Simulator', 'simulator', isDouble: true),
                buildEditableCard('Ground', 'ground', isDouble: true),
                buildEditableCard('Instrument Approach', 'instrument_approach', isInt: true),
                buildEditableCard('Day Takeoffs', 'day_to', isInt: true),
                buildEditableCard('Day Landings', 'day_ldg', isInt: true),
                buildEditableCard('Night Takeoffs', 'night_to', isInt: true),
                buildEditableCard('Night Landings', 'night_ldg', isInt: true),
                buildRemarksCard('Remarks', 'remarks'),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      updateFlightDetails();
                    }
                  },
                  child: Text('Update Flight',style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildEditableCard(String title, String field, {bool isDouble = false, bool isInt = false}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          initialValue: flightData[field] != null ? flightData[field].toString() : '',
          decoration: InputDecoration(
            labelText: title,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          onChanged: (newValue) {
            if (isDouble) {
              flightData[field] = double.tryParse(newValue);
            } else if (isInt) {
              flightData[field] = int.tryParse(newValue);
            } else {
              flightData[field] = newValue;
            }
          },
          validator: (value) {
            if (isDouble) {
              return double.tryParse(value ?? '') != null ? null : 'Enter a valid number';
            } else if (isInt) {
              return int.tryParse(value ?? '') != null ? null : 'Enter a valid integer';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget buildNonEditableCard(String title, String field) {
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
          enabled: false,
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
