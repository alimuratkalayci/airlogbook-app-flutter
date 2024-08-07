part of 'add_flight_cubit.dart';

abstract class AddFlightState {}

class AddFlightInitial extends AddFlightState {}

class AddFlightLoaded extends AddFlightState {
  final List<String> aircraftTypes;

  AddFlightLoaded(this.aircraftTypes);
}

class AddFlightSuccess extends AddFlightState {}

class AddFlightError extends AddFlightState {
  final String message;

  AddFlightError(this.message);
}
