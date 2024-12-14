import 'package:coin_go/features/flights_page/components/flight_card.dart';
import 'package:coin_go/features/flights_page/sub_pages/flight_details_page/flight_details_show_page/flight_details_show_page.dart';
import 'package:coin_go/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/show_detele_modal_bottom_sheet.dart';
import 'flights_cubit.dart';
import 'flights_state.dart';

class FlightsPage extends StatefulWidget {
  @override
  State<FlightsPage> createState() => _FlightsPageState();
}

class _FlightsPageState extends State<FlightsPage> {
  @override
  void initState() {
    super.initState();
    context.read<FlightCubit>().updateUserId();
    context.read<FlightCubit>().fetchFlights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.BackgroundColor,
      body: Stack(
        children: [
          BlocBuilder<FlightCubit, FlightState>(
            builder: (context, state) {
              if (state is FlightLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is FlightError) {
                return Center(child: Text('Error: ${state.error}'));
              } else if (state is FlightLoaded) {
                var flights = state.flights;
                final cubit = context.read<FlightCubit>();
                if (flights.isEmpty) {
                  return Center(
                    child: Text(
                      'No flights logged, tap "+" for first flight',
                      style: TextStyle(
                        color: AppTheme.AccentColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(top: 10),
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
                      userId: cubit.userId,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlightDetailsShowPage(
                              flightId: flight.id,
                              userId: cubit.userId,
                            ),
                          ),
                        );
                      },
                      onDelete: () async {
                        final result = await showDeleteConfirmationBottomSheet(
                            context, flight.id);
                        if (result == 'deleted') {
                          context.read<FlightCubit>().deleteFlight(flight.id);
                        }
                      },
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
