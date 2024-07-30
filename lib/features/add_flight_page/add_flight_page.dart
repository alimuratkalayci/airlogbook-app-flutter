import 'package:flutter/material.dart';

class AddFlightPage extends StatefulWidget {
  @override
  _AddFlightPageState createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _flightNumberController = TextEditingController();
  final _departureAirportController = TextEditingController();
  final _arrivalAirportController = TextEditingController();
  final _flightDurationController = TextEditingController();
  final _flightTypeController = TextEditingController();
  final _pilotNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Flight Record'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _flightNumberController,
                decoration: InputDecoration(labelText: 'Flight Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the flight number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _departureAirportController,
                decoration: InputDecoration(labelText: 'Departure Airport'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the departure airport';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _arrivalAirportController,
                decoration: InputDecoration(labelText: 'Arrival Airport'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the arrival airport';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _flightDurationController,
                decoration: InputDecoration(labelText: 'Flight Duration'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the flight duration';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _flightTypeController,
                decoration: InputDecoration(labelText: 'Flight Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the flight type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pilotNameController,
                decoration: InputDecoration(labelText: 'Pilot Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pilot name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Process data
                    // You can add code here to save the flight record
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Flight record added')),
                    );
                  }
                },
                child: Text('Add Flight Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
