import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FlightState {}

class FlightInitial extends FlightState {}

class FlightLoading extends FlightState {}

class FlightLoaded extends FlightState {
  final List<QueryDocumentSnapshot> flights;
  FlightLoaded(this.flights);
}

class FlightDetailLoaded extends FlightState {
  final Map<String, dynamic> flightDetails;
  FlightDetailLoaded(this.flightDetails);
}

class FlightError extends FlightState {
  final String error;
  FlightError(this.error);
}
