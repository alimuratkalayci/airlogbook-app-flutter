import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class WeatherService {
  static const String apiKey = 'YOURAPIKEY';  // OpenWeatherMap API key
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel?> fetchWeather(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?q=$name&appid=$apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);  // JSON'dan WeatherModel'e dönüşüm
      } else {
        print('Hava durumu verileri yüklenemedi: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }
}
