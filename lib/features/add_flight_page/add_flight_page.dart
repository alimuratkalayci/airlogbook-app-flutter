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
  final _departureAirportController = TextEditingController();
  final _routeWayController = TextEditingController();
  final _arrivalAirportController = TextEditingController();
  final _airCraftController = TextEditingController();
  final _dateController = TextEditingController();
  final _totalTimeController = TextEditingController();
  final _nightTimeController = TextEditingController();
  final _picController = TextEditingController();
  final _dualRcvdController = TextEditingController();
  final _soloController = TextEditingController();
  final _xcController = TextEditingController();
  final _simInstController = TextEditingController();
  final _actualInstController = TextEditingController();
  final _simulatorController = TextEditingController();
  final _groundController = TextEditingController();
  final _dayToController = TextEditingController();
  final _dayLdgController = TextEditingController();
  final _nightToController = TextEditingController();
  final _nightLdgController = TextEditingController();
  final _remarksController = TextEditingController();

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
        _dateController.text = _dateFormat.format(pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Flight', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: InputDecoration(
                                labelText: 'Date',
                                hintText: _selectedDate == null
                                    ? 'No Date Chosen!'
                                    : _dateFormat.format(_selectedDate!),
                                border: InputBorder.none,
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
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Favorite Aircrafts'),
                          SizedBox(width: 8,),
                          Expanded(
                            child: isLoading
                                ? CircularProgressIndicator()
                                : errorMessage.isNotEmpty
                                ? Text(errorMessage, style: TextStyle(color: Colors.red))
                                : DropdownButtonFormField<String>(
                              value: selectedAircraftType,
                              hint: Text('Aircraft Types'),
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
                                  return 'Select an aircraft type';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _airCraftController,
                        decoration: InputDecoration(
                          labelText: 'Aircraft ID',
                          labelStyle: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the aircraft ID';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _departureAirportController,
                        decoration: InputDecoration(
                          labelText: 'Departure Airport',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the departure airport';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _routeWayController,
                        decoration: InputDecoration(
                          labelText: 'Route',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the route way';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _arrivalAirportController,
                        decoration: InputDecoration(
                          labelText: 'Arrival Airport',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the arrival airport';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: _totalTimeController,
                        decoration: InputDecoration(
                          labelText: 'Total Time',
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        controller: _nightTimeController,
                        decoration: InputDecoration(
                          labelText: 'Night Time',
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        controller: _picController,
                        decoration: InputDecoration(
                          labelText: 'PIC',
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        controller: _dualRcvdController,
                        decoration: InputDecoration(
                          labelText: 'Dual Rcvd',
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        controller: _soloController,
                        decoration: InputDecoration(
                          labelText: 'Solo',
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        controller: _xcController,
                        decoration: InputDecoration(
                          labelText: 'XC',
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        controller: _simInstController,
                        decoration: InputDecoration(
                          labelText: 'Sim Inst',
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        controller: _actualInstController,
                        decoration: InputDecoration(
                          labelText: 'Actual Inst',
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        controller: _simulatorController,
                        decoration: InputDecoration(
                          labelText: 'Simulator',
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        controller: _groundController,
                        decoration: InputDecoration(
                          labelText: 'Ground',
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Landings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: _dayToController,
                        decoration: InputDecoration(
                          labelText: 'Day T/O',
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        controller: _dayLdgController,
                        decoration: InputDecoration(
                          labelText: 'Day Ldg',
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        controller: _nightToController,
                        decoration: InputDecoration(
                          labelText: 'Night T/O',
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        controller: _nightLdgController,
                        decoration: InputDecoration(
                          labelText: 'Night Ldg',
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _remarksController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Remarks',
                    border: OutlineInputBorder(),
                  ),
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
