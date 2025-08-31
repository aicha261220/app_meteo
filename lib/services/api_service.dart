// core/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meteo_app/constants/app_constants.dart';
import 'package:meteo_app/utils/error_utils.dart';

class ApiService {
  final String baseUrl;
  final String apiKey;
  final http.Client client;

  ApiService({
    required this.client,
    this.baseUrl = AppConstants.baseUrl,
    this.apiKey = AppConstants.apiKey,
  });

  // Vérifier si la clé API est configurée
  bool get isApiKeyConfigured {
    return apiKey.isNotEmpty && apiKey != 'your_openweather_api_key_here';
  }

  // Get weather for a specific city
  Future<Map<String, dynamic>> getWeather(String cityName) async {
    try {
      if (!isApiKeyConfigured) {
        throw Exception('Clé API non configurée');
      }

      final Uri uri = Uri.parse('$baseUrl${AppConstants.weatherEndpoint}')
          .replace(queryParameters: {
        'q': cityName,
        'appid': apiKey,
        'units': AppConstants.units,
        'lang': 'fr',
      });

      final response = await client
          .get(uri)
          .timeout(AppConstants.apiCallInterval);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      throw ErrorUtils.handleApiError(e);
    }
  }

  // Get weather by geographic coordinates - MÉTHODE AJOUTÉE
  Future<Map<String, dynamic>> getWeatherByLocation(double lat, double lon) async {
    try {
      if (!isApiKeyConfigured) {
        throw Exception('Clé API non configurée');
      }

      final Uri uri = Uri.parse('$baseUrl${AppConstants.weatherEndpoint}')
          .replace(queryParameters: {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'appid': apiKey,
        'units': AppConstants.units,
        'lang': 'fr',
      });

      final response = await client
          .get(uri)
          .timeout(AppConstants.apiCallInterval);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erreur: ${response.statusCode}');
      }
    } catch (e) {
      throw ErrorUtils.handleApiError(e);
    }
  }

  // Test connection - MÉTHODE AJOUTÉE
  Future<bool> testConnection() async {
    try {
      final response = await client
          .get(Uri.parse('$baseUrl/weather?q=London&appid=$apiKey'))
          .timeout(Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get weather for multiple cities
  Future<List<Map<String, dynamic>>> getWeatherForCities(List<String> cities) async {
    try {
      final List<Map<String, dynamic>> results = [];

      for (final city in cities) {
        try {
          final weatherData = await getWeather(city);
          results.add(weatherData);
          await Future.delayed(Duration(milliseconds: 500));
        } catch (e) {
          continue;
        }
      }

      return results;
    } catch (e) {
      throw ErrorUtils.handleApiError(e);
    }
  }
}