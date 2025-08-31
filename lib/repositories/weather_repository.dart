import '../models/weather_model.dart';

abstract class WeatherRepository {
  // Charger la météo pour une ville spécifique
  Future<WeatherModel> fetchWeather(String cityName);

  // Charger la météo pour toutes les villes
  Future<List<WeatherModel>> fetchAllCitiesWeather({
    Function(int loaded, int total)? onProgress,
  });

  // Charger la météo par coordonnées géographiques
  Future<WeatherModel> fetchWeatherByLocation(double lat, double lon);

  // Vérifier la connexion à l'API
  Future<bool> testApiConnection();

  // Obtenir la dernière ville recherchée
  Future<String?> getLastSearchedCity();

  // Sauvegarder la dernière ville recherchée
  Future<void> saveLastSearchedCity(String cityName);
}