import 'package:coin_go/features/flights_page/sub_pages/flight_details_page/flight_details_update_page/flight_details_update_page.dart';
import 'package:coin_go/features/flights_page/sub_pages/flight_details_page/flight_details_show_page/flight_details_show_page.dart';
import 'package:coin_go/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'components/show_detele_modal_bottom_sheet.dart';
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
      body: BlocBuilder<FlightCubit, FlightState>(
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
                  'No flights logged, tap "+" for first flight',                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              );
            }
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
                    final result = await showDeleteConfirmationBottomSheet(context, flight.id);
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
  final VoidCallback onDelete;

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
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(

        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (result) async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlightDetailsUpdatePage(
                    flightId: flightId,
                    userId: userId,
                  ),
                ),
              );
              if (result == 'updated') {
                context.read<FlightCubit>().fetchFlights();
              }
            },
            backgroundColor: AppTheme.BackgroundColor,
            foregroundColor: AppTheme.AccentColor,
            icon: Icons.update,
            label: 'Update',
          ),
          SlidableAction(
            onPressed: (context) async {
              onDelete();
            },
            backgroundColor: AppTheme.BackgroundColor,
            foregroundColor: AppTheme.AccentColor,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
              SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$departure'),
                        Image.asset(
                          'assets/images/direct-flight.png',
                          width: 48,
                          height: 48,
                        ),
                        Text('$arrival'),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$route'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 32),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.access_time_outlined,color: Colors.deepOrange,size: 16,),
                      Text('$total_time hours'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.featured_play_list_outlined,color: Colors.deepOrange,size: 16,),
                      Text('$aircraft_id'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.airplanemode_on,color: Colors.deepOrange,size: 16,),
                      Text('$aircraft_type'),
                    ],
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
