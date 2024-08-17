import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AnalyzePage extends StatefulWidget {
  @override
  _AnalyzePageState createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  final _dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _firstFlightDate;
  DateTime? _lastFlightDate;

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          _buildDateRangePicker(userId),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: _fetchFlightData(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No flight data available'));
                }

                var flights = snapshot.data!.docs;
                double totalHours = 0;
                double totalNightTime = 0;
                double totalPIC = 0;
                double totalDualReceived = 0;
                double totalSolo = 0;
                double totalXC = 0;
                double totalSimInst = 0;
                double totalActualInst = 0;
                double totalSimulator = 0;
                double totalGround = 0;
                int totalInstrumentApproach = 0;
                int totalDayTakeoffs = 0;
                int totalDayLandings = 0;
                int totalNightTakeoffs = 0;
                int totalNightLandings = 0;

                for (var flight in flights) {
                  var data = flight.data() as Map<String, dynamic>;

                  totalHours += (data['total_time'] as num?)?.toDouble() ?? 0.0;
                  totalNightTime += (data['night_time'] as num?)?.toDouble() ?? 0.0;
                  totalPIC += (data['pic'] as num?)?.toDouble() ?? 0.0;
                  totalDualReceived += (data['dual_rcvd'] as num?)?.toDouble() ?? 0.0;
                  totalSolo += (data['solo'] as num?)?.toDouble() ?? 0.0;
                  totalXC += (data['xc'] as num?)?.toDouble() ?? 0.0;
                  totalSimInst += (data['sim_inst'] as num?)?.toDouble() ?? 0.0;
                  totalActualInst += (data['actual_inst'] as num?)?.toDouble() ?? 0.0;
                  totalSimulator += (data['simulator'] as num?)?.toDouble() ?? 0.0;
                  totalGround += (data['ground'] as num?)?.toDouble() ?? 0.0;
                  totalInstrumentApproach += (data['instrument_approach'] as int?) ?? 0;
                  totalDayTakeoffs += (data['day_to'] as int?) ?? 0;
                  totalDayLandings += (data['day_ldg'] as int?) ?? 0;
                  totalNightTakeoffs += (data['night_to'] as int?) ?? 0;
                  totalNightLandings += (data['night_ldg'] as int?) ?? 0;
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      buildSummaryCard('Total Flight Hours', totalHours, totalHours),
                      buildSummaryCard('Total Night Time', totalNightTime, totalHours),
                      buildSummaryCard('Total PIC', totalPIC, totalHours),
                      buildSummaryCard('Total Dual Received', totalDualReceived, totalHours),
                      buildSummaryCard('Total Solo', totalSolo, totalHours),
                      buildSummaryCard('Total XC', totalXC, totalHours),
                      buildSummaryCard('Total Simulated Instrument', totalSimInst, totalHours),
                      buildSummaryCard('Total Actual Instrument', totalActualInst, totalHours),
                      buildSummaryCard('Total Simulator', totalSimulator, totalHours),
                      buildSummaryCard('Total Ground Time', totalGround, totalHours),
                      buildSummaryCardInt('Total Instrument Approach', totalInstrumentApproach),
                      buildSummaryCardInt('Total Day Takeoffs', totalDayTakeoffs),
                      buildSummaryCardInt('Total Day Landings', totalDayLandings),
                      buildSummaryCardInt('Total Night Takeoffs', totalNightTakeoffs),
                      buildSummaryCardInt('Total Night Landings', totalNightLandings),
                      SizedBox(height: 16,),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangePicker(String userId) {
    return FutureBuilder<DocumentSnapshot>(
      future: _getFirstAndLastFlightDate(userId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          _firstFlightDate = DateTime.parse(data['firstFlightDate']);
          _lastFlightDate = DateTime.parse(data['lastFlightDate']);
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16,16,16,0),
                  child: InkWell(
                    onTap: () => _pickDate(context, true),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        labelStyle: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                      ),
                      child: Text(
                        _startDate != null
                            ? _dateFormat.format(_startDate!)
                            : 'All Entries',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16,16,16,0),
                  child: InkWell(
                    onTap: () => _pickDate(context, false),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        labelStyle: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                      ),
                      child: Text(
                        _endDate != null
                            ? _dateFormat.format(_endDate!)
                            : 'All Entries',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = isStartDate
        ? (_startDate ?? _firstFlightDate ?? DateTime.now())
        : (_endDate ?? _lastFlightDate ?? DateTime.now());

    DateTime firstDate = isStartDate
        ? (_firstFlightDate ?? DateTime(2000))
        : (_startDate ?? _firstFlightDate ?? DateTime(2000));

    DateTime lastDate = isStartDate
        ? (_endDate ?? DateTime.now())
        : (_lastFlightDate ?? DateTime.now());

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  Future<QuerySnapshot> _fetchFlightData(String userId) async {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('my_flights');

    if (_startDate != null && _endDate != null) {
      String startDateStr = _dateFormat.format(_startDate!);
      String endDateStr = _dateFormat.format(_endDate!);

      query = query.where('date', isGreaterThanOrEqualTo: startDateStr)
          .where('date', isLessThanOrEqualTo: endDateStr);
    }

    return await query.get();
  }

  Future<DocumentSnapshot> _getFirstAndLastFlightDate(String userId) async {
    var flights = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('my_flights')
        .orderBy('date')
        .get();

    var firstFlight = flights.docs.first;
    var lastFlight = flights.docs.last;

    var firstFlightDate = firstFlight['date'];
    var lastFlightDate = lastFlight['date'];

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({
      'firstFlightDate': firstFlightDate,
      'lastFlightDate': lastFlightDate,
    }, SetOptions(merge: true))
        .then((_) => FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get());
  }

  Widget buildSummaryCard(String title, double value, double totalHours) {
    double percentage = (totalHours > 0) ? (value / totalHours) : 0.0;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            SizedBox(
              height: 8,
              child: LinearProgressIndicator(
                value: percentage,

                backgroundColor: Colors.white,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSummaryCardInt(String title, int value) {
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
              value.toString(),
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
}
