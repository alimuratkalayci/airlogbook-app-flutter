import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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

  Future<void> _saveFlightRecord() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? currentUser = auth.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user logged in')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final userEmail = currentUser.email;

      if (userEmail == null) {
        throw Exception('User email is null');
      }

      // Parse the number fields
      final double? totalTime = double.tryParse(_totalTimeController.text);
      final double? nightTime = double.tryParse(_nightTimeController.text);
      final double? pic = double.tryParse(_picController.text);
      final double? dual_rcvd = double.tryParse(_dualRcvdController.text);
      final double? solo = double.tryParse(_soloController.text);
      final double? xc = double.tryParse(_xcController.text);
      final double? sim_inst = double.tryParse(_simInstController.text);
      final double? actual_inst = double.tryParse(_actualInstController.text);
      final double? simulator = double.tryParse(_simulatorController.text);
      final double? ground = double.tryParse(_groundController.text);
      final int? dayTakeoffs = int.tryParse(_dayToController.text);
      final int? dayLandings = int.tryParse(_dayLdgController.text);
      final int? nightTakeoffs = int.tryParse(_nightToController.text);
      final int? nightLandings = int.tryParse(_nightLdgController.text);


      final flightRecord = {
        'date': _dateController.text,
        'aircraft_type': selectedAircraftType,
        'aircraft_id': _airCraftController.text,
        'departure_airport': _departureAirportController.text,
        'route': _routeWayController.text,
        'arrival_airport': _arrivalAirportController.text,
        'total_time': totalTime,  // Storing as float
        'night_time': nightTime,  // Storing as float
        'pic': pic,
        'dual_rcvd': dual_rcvd,
        'solo': solo,
        'xc': xc,
        'sim_inst': sim_inst,
        'actual_inst': actual_inst,
        'simulator': simulator,
        'ground': ground,
        'day_to': dayTakeoffs,
        'day_ldg': dayLandings,  // Storing as number
        'night_to': nightTakeoffs,
        'night_ldg': nightLandings,  // Storing as number
        'remarks': _remarksController.text,
      };

      await firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('my_flights')
          .add(flightRecord);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Flight record added')),
      );

      // Clear form fields if needed
      _formKey.currentState?.reset();
      _dateController.clear();
      _airCraftController.clear();
      _departureAirportController.clear();
      _routeWayController.clear();
      _arrivalAirportController.clear();
      _totalTimeController.clear();
      _nightTimeController.clear();
      _picController.clear();
      _dualRcvdController.clear();
      _soloController.clear();
      _xcController.clear();
      _simInstController.clear();
      _actualInstController.clear();
      _simulatorController.clear();
      _groundController.clear();
      _dayToController.clear();
      _dayLdgController.clear();
      _nightToController.clear();
      _nightLdgController.clear();
      _remarksController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding flight record: $e')),
      );
    }
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
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Aircraft ID';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _departureAirportController,
                        decoration: InputDecoration(
                          labelText: 'Departure Airport',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Departure Airport';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _routeWayController,
                        decoration: InputDecoration(
                          labelText: 'Route',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _arrivalAirportController,
                        decoration: InputDecoration(
                          labelText: 'Arrival Airport',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Arrival Airport';
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
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _totalTimeController,
                        decoration: InputDecoration(
                          labelText: 'Total Time',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Total Time';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _nightTimeController,
                        decoration: InputDecoration(
                          labelText: 'Night Time',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _picController,
                        decoration: InputDecoration(
                          labelText: 'PIC',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _dualRcvdController,
                        decoration: InputDecoration(
                          labelText: 'Dual Received',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _soloController,
                        decoration: InputDecoration(
                          labelText: 'Solo',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _xcController,
                        decoration: InputDecoration(
                          labelText: 'XC',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _simInstController,
                        decoration: InputDecoration(
                          labelText: 'Sim Inst',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _actualInstController,
                        decoration: InputDecoration(
                          labelText: 'Actual Inst',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _simulatorController,
                        decoration: InputDecoration(
                          labelText: 'Simulator',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _groundController,
                        decoration: InputDecoration(
                          labelText: 'Ground',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
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
                      Text('Landings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _dayToController,
                        decoration: InputDecoration(
                          labelText: 'Day Takeoffs',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _dayLdgController,
                        decoration: InputDecoration(
                          labelText: 'Day Landings',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _nightToController,
                        decoration: InputDecoration(
                          labelText: 'Night Takeoffs',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _nightLdgController,
                        decoration: InputDecoration(
                          labelText: 'Night Landings',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _remarksController,
                  maxLines: null, // Yazı yazıldıkça yüksekliğin otomatik olarak artmasını sağlar
                  minLines: 1, // Başlangıçta minimum 4 satır yüksekliğinde başlar
                  decoration: InputDecoration(
                    labelText: 'Remarks',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveFlightRecord,
                        child: Text('Add Flight Record'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
