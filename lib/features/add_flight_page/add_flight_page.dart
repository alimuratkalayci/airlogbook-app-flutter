import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AddFlightPage extends StatefulWidget {
  @override
  _AddFlightPageState createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  final _formKey = GlobalKey<FormState>();
  final _flightNumberController = TextEditingController();
  final _departureAirportController = TextEditingController();
  final _arrivalAirportController = TextEditingController();
  final _flightDurationController = TextEditingController();
  final _flightTypeController = TextEditingController();
  final _pilotNameController = TextEditingController();
  final _airCraftController = TextEditingController();

  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  String? selectedAircraftType;
  List<String> aircraftTypes = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAircraftTypes();
  }

  Future<void> fetchAircraftTypes() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? currentUser = auth.currentUser;

    if (currentUser == null) {
      setState(() {
        errorMessage = 'No user logged in';
        isLoading = false;
      });
      return;
    }

    final userEmail = currentUser.email;

    if (userEmail == null) {
      setState(() {
        errorMessage = 'User email is null';
        isLoading = false;
      });
      return;
    }

    try {
      final querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = querySnapshot.docs.first;
        final data = docSnapshot.data();
        if (data != null && data.containsKey('favorite_types')) {
          var favoriteTypesList = data['favorite_types'];
          if (favoriteTypesList is List) {
            setState(() {
              aircraftTypes = List<String>.from(favoriteTypesList);
              isLoading = false;
            });
          } else {
            setState(() {
              errorMessage = "'favorite_types' is not a List";
              isLoading = false;
            });
          }
        } else {
          setState(() {
            errorMessage = "'favorite_types' field not found in the document";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'No document found for this user';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching favorite types: $e';
        isLoading = false;
      });
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Date',
                          hintText: _selectedDate == null
                              ? 'No Date Chosen!'
                              : _dateFormat.format(_selectedDate!),
                        ),
                        readOnly: true,
                        onTap: _presentDatePicker,
                        validator: (value) {
                          if (_selectedDate == null) {
                            return 'Please pick a date';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: _presentDatePicker,
                    ),
                  ],
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
                  controller: _airCraftController,
                  decoration: InputDecoration(labelText: 'Aircraft ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the aircraft ID';
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
                isLoading
                    ? CircularProgressIndicator()
                    : errorMessage.isNotEmpty
                    ? Text(errorMessage, style: TextStyle(color: Colors.red))
                    : DropdownButtonFormField<String>(
                  value: selectedAircraftType,
                  hint: Text('Select an Aircraft Type'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAircraftType = newValue;
                    });
                  },
                  items: aircraftTypes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an aircraft type';
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
      ),
    );
  }
}
