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
  final _instrumentApproachController = TextEditingController();
  final _dayToController = TextEditingController();
  final _dayLdgController = TextEditingController();
  final _nightToController = TextEditingController();
  final _nightLdgController = TextEditingController();
  final _remarksController = TextEditingController();
  final _hobbsInController = TextEditingController();
  final _hobbsOutController = TextEditingController();

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

      final double? totalTime = _totalTimeController.text.isNotEmpty
          ? double.tryParse(_totalTimeController.text)
          : 0.0;
      final double? nightTime = _nightTimeController.text.isNotEmpty
          ? double.tryParse(_nightTimeController.text)
          : 0.0;
      final double? pic = _picController.text.isNotEmpty
          ? double.tryParse(_picController.text)
          : 0.0;
      final double? dual_rcvd = _dualRcvdController.text.isNotEmpty
          ? double.tryParse(_dualRcvdController.text)
          : 0.0;
      final double? solo = _soloController.text.isNotEmpty
          ? double.tryParse(_soloController.text)
          : 0.0;
      final double? xc = _xcController.text.isNotEmpty
          ? double.tryParse(_xcController.text)
          : 0.0;
      final double? sim_inst = _simInstController.text.isNotEmpty
          ? double.tryParse(_simInstController.text)
          : 0.0;
      final double? actual_inst = _actualInstController.text.isNotEmpty
          ? double.tryParse(_actualInstController.text)
          : 0.0;
      final double? simulator = _simulatorController.text.isNotEmpty
          ? double.tryParse(_simulatorController.text)
          : 0.0;
      final double? ground = _groundController.text.isNotEmpty
          ? double.tryParse(_groundController.text)
          : 0.0;

      final int? intrumentApproach = _instrumentApproachController.text.isNotEmpty
          ? int.tryParse(_instrumentApproachController.text)
          : 0;
      final int? dayTakeoffs = _dayToController.text.isNotEmpty
          ? int.tryParse(_dayToController.text)
          : 0;
      final int? dayLandings = _dayLdgController.text.isNotEmpty
          ? int.tryParse(_dayLdgController.text)
          : 0;
      final int? nightTakeoffs = _nightToController.text.isNotEmpty
          ? int.tryParse(_nightToController.text)
          : 0;
      final int? nightLandings = _nightLdgController.text.isNotEmpty
          ? int.tryParse(_nightLdgController.text)
          : 0;


      final flightRecord = {
        'date': _dateController.text,
        'aircraft_type': selectedAircraftType,
        'aircraft_id': _airCraftController.text,
        'departure_airport': _departureAirportController.text,
        'route': _routeWayController.text,
        'arrival_airport': _arrivalAirportController.text,
        'hobbs_in': _hobbsInController.text.isEmpty ? int.tryParse('0') : int.tryParse(_hobbsInController.text),
        'hobbs_out': _hobbsOutController.text.isEmpty ? int.tryParse('0') : int.tryParse(_hobbsOutController.text),
        'total_time': totalTime,
        'night_time': nightTime,
        'pic': pic,
        'dual_rcvd': dual_rcvd,
        'solo': solo,
        'xc': xc,
        'sim_inst': sim_inst,
        'actual_inst': actual_inst,
        'simulator': simulator,
        'ground': ground,
        'instrument_approach': intrumentApproach,
        'day_to': dayTakeoffs,
        'day_ldg': dayLandings,
        'night_to': nightTakeoffs,
        'night_ldg': nightLandings,
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
      _hobbsInController.clear();
      _hobbsOutController.clear();
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
      _instrumentApproachController.clear();
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

  void _updateTotalTime() {
    double? hobbsIn = double.tryParse(_hobbsInController.text);
    double? hobbsOut = double.tryParse(_hobbsOutController.text);
    if (hobbsIn != null && hobbsOut != null) {
      double totalTime = hobbsIn - hobbsOut;
      _totalTimeController.text = totalTime.toStringAsFixed(2);
    } else {
      _totalTimeController.text = '';
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
                      Text('Flight', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.deepOrange)),
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        controller: _hobbsInController,
                        decoration: InputDecoration(
                          labelText: 'Hobbs In',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        controller: _hobbsOutController,
                        decoration: InputDecoration(
                          labelText: 'Hobbs Out',
                          border: OutlineInputBorder(),
                        ),

                        validator: (value) {
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                          });
                          _updateTotalTime();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.deepOrange)),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        controller: _totalTimeController,
                        decoration: InputDecoration(
                          labelText: 'Total Time',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                          });
                        },
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        controller: _nightTimeController,
                        decoration: InputDecoration(
                          labelText: 'Night Time',
                          border: OutlineInputBorder(),
                          suffixIcon: _totalTimeController.text.isNotEmpty ?
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 0.0),
                              child: TextButton(
                                onPressed: () {
                                  double currentValue = double.tryParse(_totalTimeController.text) ?? 0.0;
                                  _nightTimeController.text = currentValue.toString();
                                },
                                child: Text(
                                  'Copy Time',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ),
                          ) : null,
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        controller: _picController,
                        decoration: InputDecoration(
                          labelText: 'PIC',
                          border: OutlineInputBorder(),
                          suffixIcon: _totalTimeController.text.isNotEmpty ?
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: TextButton(
                                onPressed: () {
                                  double currentValue = double.tryParse(_totalTimeController.text) ?? 0.0;
                                  _picController.text = currentValue.toString();
                                },
                                child: Text(
                                  'Copy Time',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ),
                          ) : null,
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        controller: _dualRcvdController,
                        decoration: InputDecoration(
                          labelText: 'Dual Received',
                          border: OutlineInputBorder(),
                          suffixIcon: _totalTimeController.text.isNotEmpty ?
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: TextButton(
                                onPressed: () {
                                  double currentValue = double.tryParse(_totalTimeController.text) ?? 0.0;
                                  _dualRcvdController.text = currentValue.toString();
                                },
                                child: Text(
                                  'Copy Time',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ),
                          ) : null,

                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        controller: _soloController,
                        decoration: InputDecoration(
                          labelText: 'Solo',
                          border: OutlineInputBorder(),
                          suffixIcon: _totalTimeController.text.isNotEmpty ?
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: TextButton(
                                onPressed: () {
                                  double currentValue = double.tryParse(_totalTimeController.text) ?? 0.0;
                                  _soloController.text = currentValue.toString();
                                },
                                child: Text(
                                  'Copy Time',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ),
                          ) : null,
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        controller: _xcController,
                        decoration: InputDecoration(
                          labelText: 'XC',
                          border: OutlineInputBorder(),
                          suffixIcon: _totalTimeController.text.isNotEmpty ?
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: TextButton(
                                onPressed: () {
                                  double currentValue = double.tryParse(_totalTimeController.text) ?? 0.0;
                                  _xcController.text = currentValue.toString();
                                },
                                child: Text(
                                  'Copy Time',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ),
                          ) : null,
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        controller: _simInstController,
                        decoration: InputDecoration(
                          labelText: 'Sim Inst',
                          border: OutlineInputBorder(),
                          suffixIcon: _totalTimeController.text.isNotEmpty ?
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: TextButton(
                                onPressed: () {
                                  double currentValue = double.tryParse(_totalTimeController.text) ?? 0.0;
                                  _simInstController.text = currentValue.toString();
                                },
                                child: Text(
                                  'Copy Time',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ),
                          ) : null,
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        controller: _actualInstController,
                        decoration: InputDecoration(
                          labelText: 'Actual Inst',
                          border: OutlineInputBorder(),
                          suffixIcon: _totalTimeController.text.isNotEmpty ?
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: TextButton(
                                onPressed: () {
                                  double currentValue = double.tryParse(_totalTimeController.text) ?? 0.0;
                                  _actualInstController.text = currentValue.toString();
                                },
                                child: Text(
                                  'Copy Time',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ),
                          ) : null,
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        controller: _simulatorController,
                        decoration: InputDecoration(
                          labelText: 'Simulator',
                          border: OutlineInputBorder(),
                          suffixIcon: _totalTimeController.text.isNotEmpty ?
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: TextButton(
                                onPressed: () {
                                  double currentValue = double.tryParse(_totalTimeController.text) ?? 0.0;
                                  _simulatorController.text = currentValue.toString();
                                },
                                child: Text(
                                  'Copy Time',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ),
                          ) : null,
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        controller: _groundController,
                        decoration: InputDecoration(
                          labelText: 'Ground',
                          border: OutlineInputBorder(),
                          suffixIcon: _totalTimeController.text.isNotEmpty ?
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: TextButton(
                                onPressed: () {
                                  double currentValue = double.tryParse(_totalTimeController.text) ?? 0.0;
                                  _groundController.text = currentValue.toString();
                                },
                                child: Text(
                                  'Copy Time',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ),
                            ),
                          ) : null,
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
                        controller: _instrumentApproachController,
                        decoration: InputDecoration(
                          labelText: 'Instrument Approach',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add,color: Colors.deepOrange),
                            onPressed: () {
                              int currentValue = int.tryParse(_instrumentApproachController.text) ?? 0;
                              _instrumentApproachController.text = (currentValue + 1).toString();
                            },
                          ),
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
                      Text('Landings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.deepOrange)),
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
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add,color: Colors.deepOrange),
                            onPressed: () {
                              int currentValue = int.tryParse(_dayToController.text) ?? 0;
                              _dayToController.text = (currentValue + 1).toString();
                              _dayLdgController.text = (currentValue + 1).toString();
                            },
                          ),
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
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add,color: Colors.deepOrange),
                            onPressed: () {
                              int currentValue = int.tryParse(_dayLdgController.text) ?? 0;
                              _dayLdgController.text = (currentValue + 1).toString();
                              _dayToController.text = (currentValue + 1).toString();

                            },
                          ),
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
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add,color: Colors.deepOrange),
                            onPressed: () {
                              int currentValue = int.tryParse(_nightToController.text) ?? 0;
                              _nightToController.text = (currentValue + 1).toString();
                              _nightLdgController.text = (currentValue + 1).toString();

                            },
                          ),
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
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add,color: Colors.deepOrange),
                            onPressed: () {
                              int currentValue = int.tryParse(_nightLdgController.text) ?? 0;
                              _nightLdgController.text = (currentValue + 1).toString();
                              _nightToController.text = (currentValue + 1).toString();

                            },
                          ),
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
                  maxLines: null,
                  minLines: 1,
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
                        child: Text('Add Flight Record',style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
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

