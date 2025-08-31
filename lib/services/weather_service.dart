import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meteo_app/models/weather_model.dart';

class WeatherService {
  final String apiKey = "7c69fa5a4f1630c6a6483fdca07e5275"; // remplace par ta vraie clé

  // Méthode pour une ville
  Future<WeatherModel> fetchWeather(String cityName) async {
    final Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      print("Erreur API: ${response.statusCode}");
      print("Body: ${response.body}");
      throw Exception('Impossible de charger les données météo pour $cityName');
    }
  }

  // Méthode pour plusieurs villes (optimisé)
  Future<List<WeatherModel>> getMultipleWeather(List<String> cities) async {
    final futures = cities.map((city) => fetchWeather(city)).toList();
    return await Future.wait(futures);
  }
}
