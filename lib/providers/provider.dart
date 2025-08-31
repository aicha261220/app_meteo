import 'package:flutter/material.dart';
import 'package:meteo_app/models/weather_model.dart';
import 'package:meteo_app/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:meteo_app/utils/error_utils.dart';

class WeatherProvider extends ChangeNotifier {
  final ApiService apiService = ApiService(client: http.Client());

  WeatherModel? _weather;
  bool _isLoading = false;

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;

  /// Récupère la météo pour une ville et notifie les listeners
  Future<void> fetchWeather(String cityName, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final weatherData = await apiService.getWeather(cityName);
      _weather = weather;
    } catch (e) {
      ErrorUtils.handleApiError(context, );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Réinitialise la météo
  void clearWeather() {
    _weather = null;
    notifyListeners();
  }
}
