import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'add_flight_state.dart';

class AddFlightCubit extends Cubit<AddFlightState> {
  AddFlightCubit() : super(AddFlightInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void fetchAircraftTypes() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        emit(AddFlightError('No user logged in'));
        return;
      }

      final userEmail = currentUser.email;
      if (userEmail == null) {
        emit(AddFlightError('User email is null'));
        return;
      }

      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = querySnapshot.docs.first;
        final data = docSnapshot.data();
        if (data != null && data.containsKey('favorite_types')) {
          var favoriteTypesList = data['favorite_types'];
          if (favoriteTypesList is List) {
            emit(AddFlightLoaded(List<String>.from(favoriteTypesList)));
          } else {
            emit(AddFlightError("'favorite_types' is not a List"));
          }
        } else {
          emit(AddFlightError("'favorite_types' field not found in the document"));
        }
      } else {
        emit(AddFlightError('No document found for this user'));
      }
    } catch (e) {
      emit(AddFlightError('Error fetching favorite types: $e'));
    }
  }

  Future<void> saveFlightRecord({
    required String date,
    required String? aircraftType,
    required String aircraftId,
    required String departureAirport,
    required String route,
    required String arrivalAirport,
    required String hobbsIn,
    required String hobbsOut,
    required String totalTime,
    required String nightTime,
    required String pic,
    required String dualRcvd,
    required String solo,
    required String xc,
    required String simInst,
    required String actualInst,
    required String simulator,
    required String ground,
    required String dayTakeoffs,
    required String dayLandings,
    required String nightTakeoffs,
    required String nightLandings,
    required String remarks,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        emit(AddFlightError('No user logged in'));
        return;
      }

      final userEmail = currentUser.email;
      if (userEmail == null) {
        emit(AddFlightError('User email is null'));
        return;
      }

      final double? totalTimeParsed = double.tryParse(totalTime);
      final double? nightTimeParsed = double.tryParse(nightTime);
      final double? picParsed = double.tryParse(pic);
      final double? dualRcvdParsed = double.tryParse(dualRcvd);
      final double? soloParsed = double.tryParse(solo);
      final double? xcParsed = double.tryParse(xc);
      final double? simInstParsed = double.tryParse(simInst);
      final double? actualInstParsed = double.tryParse(actualInst);
      final double? simulatorParsed = double.tryParse(simulator);
      final double? groundParsed = double.tryParse(ground);
      final int? dayTakeoffsParsed = int.tryParse(dayTakeoffs);
      final int? dayLandingsParsed = int.tryParse(dayLandings);
      final int? nightTakeoffsParsed = int.tryParse(nightTakeoffs);
      final int? nightLandingsParsed = int.tryParse(nightLandings);

      final flightRecord = {
        'date': date,
        'aircraft_type': aircraftType,
        'aircraft_id': aircraftId,
        'departure_airport': departureAirport,
        'route': route,
        'arrival_airport': arrivalAirport,
        'hobbs_in': hobbsIn.isEmpty ? 0 : int.tryParse(hobbsIn),
        'hobbs_out': hobbsOut.isEmpty ? 0 : int.tryParse(hobbsOut),
        'total_time': totalTimeParsed,
        'night_time': nightTimeParsed,
        'pic': picParsed,
        'dual_rcvd': dualRcvdParsed,
        'solo': soloParsed,
        'xc': xcParsed,
        'sim_inst': simInstParsed,
        'actual_inst': actualInstParsed,
        'simulator': simulatorParsed,
        'ground': groundParsed,
        'day_to': dayTakeoffsParsed,
        'day_ldg': dayLandingsParsed,
        'night_to': nightTakeoffsParsed,
        'night_ldg': nightLandingsParsed,
        'remarks': remarks,
      };

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('my_flights')
          .add(flightRecord);

      emit(AddFlightSuccess());
    } catch (e) {
      emit(AddFlightError('Error adding flight record: $e'));
    }
  }
}
