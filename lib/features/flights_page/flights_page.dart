import 'package:coin_go/features/flights_page/sub_pages/flight_details_page/flight_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'flights_cubit.dart';
import 'flights_state.dart';

String formatDay(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('dd').format(parsedDate);
}

String formatMonthYear(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('MM-yyyy').format(parsedDate);
}

class FlightsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FlightCubit(),
      child: Scaffold(
        body: BlocBuilder<FlightCubit, FlightState>(
          builder: (context, state) {
            if (state is FlightLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FlightError) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is FlightLoaded) {
              var flights = state.flights;
              final cubit = context.read<FlightCubit>();
              return ListView.builder(
                itemCount: flights.length,
                itemBuilder: (context, index) {
                  var flight = flights[index];
                  return FlightCard(
                    date: flight['date'],
                    total_time: flight['total_time'],
                    aircraft_id: flight['aircraft_id'],
                    aircraft_type: flight['aircraft_type'],
                    departure: flight['departure_airport'],
                    route: flight['route'],
                    arrival: flight['arrival_airport'],
                    flightId: flight.id,
                    userId: cubit.userId, // UserID'yi cubitten alıyoruz
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlightDetailsPage(
                            flightId: flight.id,
                            userId: cubit.userId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
            return Container(); // Başlangıç durumu için placeholder
          },
        ),
      ),
    );
  }
}


class FlightCard extends StatelessWidget {
  final String date;
  final double total_time;
  final String aircraft_id;
  final String aircraft_type;
  final String departure;
  final String route;
  final String arrival;
  final VoidCallback onTap;
  final String flightId;
  final String userId;

  FlightCard({
    required this.date,
    required this.total_time,
    required this.aircraft_id,
    required this.aircraft_type,
    required this.departure,
    required this.route,
    required this.arrival,
    required this.onTap,
    required this.flightId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(formatDay(date),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.deepOrange)),
                  Text(formatMonthYear(date), style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$departure'),
                        if (route.isNotEmpty)
                          Icon(Icons.arrow_forward_sharp,
                              size: 16, color: Colors.deepOrange), // Ok işareti
                        if (route.isNotEmpty) Text('$route'),
                        if (route.isNotEmpty)
                          Icon(Icons.arrow_forward_sharp,
                              size: 16, color: Colors.deepOrange), // Ok işareti
                        Text('$arrival'),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Time $total_time'),
                        Text('$aircraft_id'),
                        Text('$aircraft_type'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Column(
                children: [
                  Transform.rotate(
                    angle: 90 * 3.1415926535897932 / 180, // 90 dereceyi radyana çevir
                    child: Icon(
                      Icons.airplanemode_active_sharp,
                      size: 48,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
