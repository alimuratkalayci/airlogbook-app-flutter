import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../theme/theme.dart';
import '../../../flights_page/components/flight_card.dart';

class LastFlightCard extends StatefulWidget {
  final DocumentSnapshot? lastFlight;

  const LastFlightCard({Key? key, required this.lastFlight}) : super(key: key);

  @override
  State<LastFlightCard> createState() => _LastFlightCardState();
}

class _LastFlightCardState extends State<LastFlightCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.lastFlight == null) {
      return Center(
        child: null,
      );
    }

    // Firestore'dan çekilen uçuş verileri
    Map<String, dynamic> flightData =
        widget.lastFlight!.data() as Map<String, dynamic>;

    return Card(
      color: AppTheme.TextColorWhite,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'LAST FLIGHT',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.AccentColor,
                      fontSize: 20),
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(formatDay(flightData['date'] ?? '0000'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: AppTheme.AccentColor)),
                    Text(formatMonthYear(flightData['date'] ?? '0000'),
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(width: 8),

                // Orta kısımda kalkış, varış ve route bilgisi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${flightData['departure_airport'] ?? 'N/A'}'),
                          Image.asset(
                            'assets/images/direct-flight.png', // Burada uygun bir uçuş simgesi kullanabilirsiniz
                            width: 48,
                            height: 48,
                          ),
                          Text('${flightData['arrival_airport'] ?? 'N/A'}'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${flightData['route'] ?? 'Bilinmiyor'}'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),

                // Sağ kısımdaki uçuş detayları (süre, uçak id, uçak tipi)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Süre
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.timelapse,
                            color: AppTheme.AccentColor, size: 20),
                        SizedBox(width: 8),
                        Text('${flightData['total_time'] ?? '0'} saat'),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Uçak ID
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.airplane_ticket,
                            color: AppTheme.AccentColor, size: 20),
                        SizedBox(width: 8),
                        Text('${flightData['aircraft_id'] ?? 'Yok'}'),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Uçak Tipi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.flight,
                            color: AppTheme.AccentColor, size: 20),
                        SizedBox(width: 8),
                        Text('${flightData['aircraft_type'] ?? 'Yok'}'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Wrap(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Remark \n',
                        style: TextStyle(
                            color: AppTheme.AccentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      TextSpan(
                        text: '${flightData['remarks'] ?? ''}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
