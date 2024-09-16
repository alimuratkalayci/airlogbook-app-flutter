

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../theme/theme.dart';
import '../flights_cubit.dart';
import '../sub_pages/flight_details_page/flight_details_update_page/flight_details_update_page.dart';

String formatDay(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('dd').format(parsedDate);
}

String formatMonthYear(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('MM-yyyy').format(parsedDate);
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
                          color: AppTheme.AccentColor)),
                  Text(formatMonthYear(date), style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(width: 8),
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
              SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.timelapse,color: AppTheme.AccentColor,size: 20,),
                      SizedBox(width: 8,),
                      Text('$total_time'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.airplane_ticket,color: AppTheme.AccentColor,size: 20,),
                      SizedBox(width: 8,),
                      Text('$aircraft_id'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.flight,color: AppTheme.AccentColor,size: 20,),
                      SizedBox(width: 8,),
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