import 'package:coin_go/features/add_flight_page/widgets/inside_flight_container/aircraft_id_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_flight_container/arrival_airport_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_flight_container/departure_airport_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_flight_container/hobbs_in_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_flight_container/hobbs_out_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_flight_container/route_way_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_landings_container/day_landings_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_landings_container/day_takeoffs_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_landings_container/night_landings_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_landings_container/night_takeoffs_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_remarks_container/remarks_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_time_container/actual_inst_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_time_container/dual_received_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_time_container/ground_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_time_container/instrument_approach_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_time_container/night_time_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_time_container/pic_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_time_container/sim_inst_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_time_container/simulator_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_time_container/solo_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_time_container/total_time_text_field.dart';
import 'package:coin_go/features/add_flight_page/widgets/inside_time_container/xc_text_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../general_components/custom_modal_bottom_sheet_alert_dialog/custom_modal_bottom_sheet.dart';
import '../../theme/theme.dart';

class AddFlightPage extends StatefulWidget {
  @override
  _AddFlightPageState createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  final _formKey = GlobalKey<FormState>();
  final _departureAirportController = TextEditingController();
  final _routeWayController = TextEditingController();
  final _arrivalAirportController = TextEditingController();
  final _airCraftIdController = TextEditingController();
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
    //_fetchTotalTime();
  }

/*
  Future<void> _fetchTotalTime() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? currentUser = auth.currentUser;

    if (currentUser == null) {
      print('No user is logged in.');
      return;
    }

    try {
      String userId = currentUser.uid;

      final userDoc = await firestore.collection('users').doc(userId).get();

      final flightsDoc = await firestore
          .collection('users')
          .doc(userId)
          .collection('my_flights')
          .get();

      num total = 0;
      for (var flight in flightsDoc.docs) {
        if (flight.data().containsKey('total_time')) {
          total += flight['total_time'];
        }
      }

      setState(() {
        totalTimeFirebase = total.toDouble();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching total time: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
 */

  Future<void> _saveFlightRecord() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? currentUser = auth.currentUser;

    if (currentUser == null) {
      showCustomModal(
        context: context,
        title: 'No User Logged In',
        message: 'There is no user currently logged in.',
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

      final int? intrumentApproach =
          _instrumentApproachController.text.isNotEmpty
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
        'aircraft_id': _airCraftIdController.text,
        'departure_airport': _departureAirportController.text,
        'route': _routeWayController.text,
        'arrival_airport': _arrivalAirportController.text,
        'hobbs_in': _hobbsInController.text.isEmpty
            ? int.tryParse('0')
            : int.tryParse(_hobbsInController.text),
        'hobbs_out': _hobbsOutController.text.isEmpty
            ? int.tryParse('0')
            : int.tryParse(_hobbsOutController.text),
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

      showCustomModal(context: context, title: 'Success', message: 'Flight record saved');

      _formKey.currentState?.reset();
      _dateController.clear();
      _airCraftIdController.clear();
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
      showCustomModal(
        context: context,
        title: 'Something Went Wrong',
        message: 'We encountered an error while adding the flight record: $e',
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
      backgroundColor: AppTheme.BackgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 8, bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.AccentColor,
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Flight',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.TextColorWhite)),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _dateController,
                                    style: TextStyle(
                                        color: AppTheme.TextColorWhite),
                                    decoration: InputDecoration(
                                      focusColor: AppTheme.TextColorWhite,
                                      labelText: 'Date',
                                      labelStyle: TextStyle(
                                          color: AppTheme.TextColorWhite),
                                      hintText: _selectedDate == null
                                          ? 'No Date Chosen!'
                                          : _dateFormat
                                              .format(_selectedDate!)
                                              .toString(),
                                      hintStyle: TextStyle(
                                          color: AppTheme.TextColorWhite),
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
                                  color: AppTheme.TextColorWhite,
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: _presentDatePicker,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Favorite Aircrafts',
                                  style:
                                      TextStyle(color: AppTheme.TextColorWhite),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: isLoading
                                      ? CircularProgressIndicator()
                                      : DropdownButtonFormField<String>(
                                          dropdownColor: AppTheme.AccentColor,
                                          iconEnabledColor:
                                              AppTheme.TextColorWhite,
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(
                                            color: AppTheme.TextColorWhite,
                                            fontSize: 16,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0, //
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color: AppTheme.AccentColor,
                                                width: 2.0,
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 12.0),
                                          ),
                                          icon: Icon(Icons.airplanemode_active),
                                          hint: Text(
                                            'Aircraft Types',
                                            style: TextStyle(
                                                color: AppTheme.TextColorWhite),
                                          ),
                                          value: selectedAircraftType,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedAircraftType = newValue;
                                            });
                                          },
                                          items: aircraftTypes
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value,
                                                  style: TextStyle(
                                                      color: AppTheme
                                                          .TextColorWhite)),
                                            );
                                          }).toList(),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Select an aircraft type';
                                            }
                                            return null;
                                          },
                                        ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            AircraftIdTextField(
                                controller: _airCraftIdController,
                                labelText: 'Aircraft ID'),
                            SizedBox(height: 8),
                            DepartureAirportTextField(
                              controller: _departureAirportController,
                              labelText: 'Departure Airport',
                            ),
                            SizedBox(height: 8),
                            RouteWayTextField(
                              controller: _routeWayController,
                            ),
                            SizedBox(height: 8),
                            ArrivalAirportTextField(
                                controller: _arrivalAirportController,
                                labelText: 'Arrival Airport'),
                            SizedBox(height: 8),
                            HobbsInTextField(
                              controller: _hobbsInController,
                            ),
                            SizedBox(height: 8),
                            HobbsOutTextField(
                              controller: _hobbsOutController,
                              onChanged: (value) {
                                setState(() {
                                  _updateTotalTime();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.AccentColor,
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Time',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.TextColorWhite)),
                            SizedBox(height: 10),
                            TotalTimeTextField(
                              controller: _totalTimeController,
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                            SizedBox(height: 10),
                            NightTimeTextField(
                              controller: _nightTimeController,
                              totalTimeController: _totalTimeController,
                            ),
                            SizedBox(height: 10),
                            PicTextField(
                              controller: _picController,
                              totalTimeController: _totalTimeController,
                            ),
                            SizedBox(height: 10),
                            DualReceivedTextField(
                                controller: _dualRcvdController,
                                totalTimeController: _totalTimeController),
                            SizedBox(height: 10),
                            SoloTextField(
                                controller: _soloController,
                                totalTimeController: _totalTimeController),
                            SizedBox(height: 10),
                            XcTextField(
                                controller: _xcController,
                                totalTimeController: _totalTimeController),
                            SizedBox(height: 10),
                            SimInstTextField(
                                controller: _simInstController,
                                totalTimeController: _totalTimeController),
                            SizedBox(height: 10),
                            ActualInstTextField(
                                controller: _actualInstController,
                                totalTimeController: _totalTimeController),
                            SizedBox(height: 10),
                            SimulatorTextField(
                                controller: _simulatorController,
                                totalTimeController: _totalTimeController),
                            SizedBox(height: 10),
                            GroundTextField(
                                controller: _groundController,
                                totalTimeController: _totalTimeController),
                            SizedBox(height: 10),
                            InstrumentApproachTextField(
                                controller: _instrumentApproachController)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.AccentColor,
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Landings',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.TextColorWhite)),
                            SizedBox(height: 10),
                            DayTakeoffsTextField(
                                dayToController: _dayToController,
                                dayLdgController: _dayLdgController),
                            SizedBox(height: 10),
                            DayLandingsTextField(
                                dayLdgController: _dayLdgController,
                                dayToController: _dayToController),
                            SizedBox(height: 10),
                            NightTakeoffsTextField(
                                nightToController: _nightToController,
                                nightLdgController: _nightLdgController),
                            SizedBox(height: 10),
                            NightLandingsTextField(
                                nightLdgController: _nightLdgController,
                                nightToController: _nightToController),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.AccentColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Remarks',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.TextColorWhite)),
                              SizedBox(height: 10),
                              RemarksTextField(controller: _remarksController),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveFlightRecord,
                              child: Text(
                                'Add Flight Record',
                                style: TextStyle(
                                    color: AppTheme.TextColorWhite,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.AccentColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
