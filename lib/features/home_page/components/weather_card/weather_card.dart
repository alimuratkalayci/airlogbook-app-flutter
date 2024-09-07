import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Lottie kütüphanesini import ettik
import 'weather_model.dart';
import 'package:coin_go/theme/theme.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hava durumuna göre animasyon URL'sini seçiyoruz
    String animationUrl;

    // Hava durumu ana türüne göre animasyon URL'si seçimi
    switch (weather.weather.first.main.toLowerCase()) {
      case 'clear':
        animationUrl =
            'https://lottie.host/a4c561c0-8ad0-4d7d-851d-744f488c1db1/d2gag4Tvz3.json'; // Güneşli hava animasyonu
        break;
      case 'clouds':
        animationUrl =
            'https://lottie.host/0b7c02ae-54aa-49ba-9bb2-9a3cbbb9800c/432u0Uxf1y.json'; // Bulutlu hava animasyonu
        break;
      case 'rain':
        animationUrl =
            'https://lottie.host/1aa0a695-5993-457b-9f42-be9535976d96/s3zhn5WfKA.json'; // Yağmurlu hava animasyonu
        break;
      case 'snow':
        animationUrl =
            'https://lottie.host/e203b38a-74ed-4954-9fa3-995642f2ff36/HAnE3ukrRx.json'; // Kış hava animasyonu
        break;
      case 'thunderstorm':
        animationUrl =
            'https://lottie.host/c4e15a7b-bdab-425a-b0a8-90ee2ce655be/HwnFEtgcbQ.json'; // Fırtınalı hava animasyonu
        break;
      default:
        animationUrl =
            'https://lottie.host/a4c561c0-8ad0-4d7d-851d-744f488c1db1/d2gag4Tvz3.json'; // Varsayılan animasyon
    }

    return Card(
      color: AppTheme.BackgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Lottie.network(
                          animationUrl,
                          fit: BoxFit.fitWidth,
                          height: 200,
                        ),
                      ),
                      Center(
                        child: Row(
                          children: [
                            Text(
                              weather.name,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.place,
                              color: AppTheme.AccentColor,
                            ),
                            Spacer(),
                            Text(
                              '${weather.main.temp.toStringAsFixed(1)} °C',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${weather.weather.first.description.toUpperCase()}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Wind: ${weather.wind.speed.toStringAsFixed(1)} m/s, '
                    'Direction: ${weather.wind.deg}°',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pressure: ${weather.main.pressure} hPa, '
                    'Visibility: ${weather.visibility / 1000} km',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
