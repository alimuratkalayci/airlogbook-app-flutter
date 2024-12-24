import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'flights_state.dart';

class FlightCubit extends Cubit<FlightState> {
  late String userId;

  FlightCubit() : super(FlightInitial()) {
    _initializeUserId();
  }

  void _initializeUserId() {
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    fetchFlights();
  }

  void fetchFlights() async {
    emit(FlightLoading());
    try {
      if (userId.isNotEmpty) {
        print("Fetching flights for user ID: $userId");
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('my_flights')
            .orderBy('date', descending: true)
            .get();

        if (snapshot.docs.isEmpty) {
          print("No flights found.");
        }
        emit(FlightLoaded(snapshot.docs));
      } else {
        emit(FlightError('User not logged in'));
      }
    } catch (e) {
      emit(FlightError(e.toString()));
    }
  }

  void fetchFlightDetails(String flightID) async {
    emit(FlightLoading());
    try {
      if (userId.isNotEmpty) {
        print("Fetching flight details for flight ID: $flightID");
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('my_flights')
            .doc(flightID)
            .get();

        if (docSnapshot.exists) {
          emit(FlightDetailLoaded(docSnapshot.data() as Map<String, dynamic>));
        } else {
          emit(FlightError('Flight not found'));
        }
      } else {
        emit(FlightError('User not logged in'));
      }
    } catch (e) {
      emit(FlightError(e.toString()));
    }
  }

  void deleteFlight(String flightId) async {
    emit(FlightLoading());
    try {
      if (userId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('my_flights')
            .doc(flightId)
            .delete();

        fetchFlights();
        emit(FlightDeleted());
      } else {
        emit(FlightError('User not logged in.'));
      }
    } catch (e) {
      emit(FlightError(e.toString()));
    }
  }

  void updateUserId() {
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    fetchFlights();
  }

}
