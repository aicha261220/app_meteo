// data/repositories/weather_repository_impl.dart
import 'package:meteo_app/services/api_service.dart';
import 'package:meteo_app/models/weather_model.dart';
import 'package:meteo_app/repositories/weather_repository.dart';
import 'package:meteo_app/constants/app_constants.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final ApiService apiService;

  WeatherRepositoryImpl({required this.apiService});

  @override
  Future<WeatherModel> fetchWeather(String cityName) async {
    try {
      print('🔄 Chargement météo pour: $cityName');

      if (!apiService.isApiKeyConfigured) {
        throw Exception(
            'Clé API non configurée.\n'
                'Veuillez ajouter votre clé OpenWeatherMap dans:\n'
                'lib/core/constants/app_constants.dart\n\n'
                'Obtenez une clé gratuite sur: openweathermap.org/api'
        );
      }

      final response = await apiService.getWeather(cityName);
      final weather = WeatherModel.fromJson(response);

      print('✅ Météo chargée avec succès pour: $cityName');
      return weather;
    } catch (e) {
      print('❌ Erreur lors du chargement pour $cityName: $e');
      // CORRECTION ICI: S'assurer de relancer un Exception
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<List<WeatherModel>> fetchAllCitiesWeather({
    Function(int loaded, int total)? onProgress,
  }) async {
    try {
      print('🔄 Début du chargement des données pour ${AppConstants.cities.length} villes');

      if (!apiService.isApiKeyConfigured) {
        throw Exception('Clé API non configurée. Veuillez configurer votre clé OpenWeatherMap.');
      }

      onProgress?.call(0, AppConstants.cities.length);

      final List<WeatherModel> weatherData = [];
      int successCount = 0;

      for (int i = 0; i < AppConstants.cities.length; i++) {
        final String city = AppConstants.cities[i];

        try {
          print('🌐 Chargement de: $city (${i + 1}/${AppConstants.cities.length})');

          final weather = await fetchWeather(city);
          weatherData.add(weather);
          successCount++;

          print('✅ $city chargé avec succès');
          onProgress?.call(i + 1, AppConstants.cities.length);

          if (i < AppConstants.cities.length - 1) {
            await Future.delayed(Duration(milliseconds: 800));
          }

        } catch (e) {
          print('⚠️ Échec pour $city: $e');
          onProgress?.call(i + 1, AppConstants.cities.length);
          continue;
        }
      }

      if (weatherData.isEmpty) {
        throw Exception(
            'Aucune donnée n\'a pu être récupérée.\n\n'
                'Causes possibles:\n'
                '• Problème de connexion internet\n'
                '• Clé API invalide ou expirée\n'
                '• Serveur API indisponible\n\n'
                'Vérifiez votre connexion et votre clé API.'
        );
      }

      print('✅ Chargement terminé: $successCount/${AppConstants.cities.length} villes réussies');
      return weatherData;
    } catch (e) {
      print('❌ Erreur générale lors du chargement: $e');
      // CORRECTION ICI
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<WeatherModel> fetchWeatherByLocation(double lat, double lon) async {
    try {
      print('🔄 Chargement météo par localisation: $lat, $lon');

      if (!apiService.isApiKeyConfigured) {
        throw Exception('Clé API non configurée');
      }

      final response = await apiService.getWeatherByLocation(lat, lon);
      final weather = WeatherModel.fromJson(response);

      print('✅ Météo par localisation chargée avec succès');
      return weather;
    } catch (e) {
      print('❌ Erreur lors du chargement par localisation: $e');
      // CORRECTION ICI
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<bool> testApiConnection() async {
    try {
      print('🔍 Test de connexion à l\'API...');
      return await apiService.testConnection();
    } catch (e) {
      print('❌ Test de connexion échoué: $e');
      return false;
    }
  }

  @override
  Future<String?> getLastSearchedCity() async {
    return null;
  }

  @override
  Future<void> saveLastSearchedCity(String cityName) async {
    // Implémentation pour la persistance
  }

  Future<List<WeatherModel>> getMockData() async {
    await Future.delayed(Duration(seconds: 3));

    return [
      WeatherModel(
        cityName: 'Paris',
        temperature: 18.5,
        condition: 'Nuageux',
        humidity: 65,
        windSpeed: 12.3,
        latitude: 48.8566,
        longitude: 2.3522,
        feelsLike: 17.8,
        pressure: 1015,
        visibility: 10000,
        sunrise: 1678243200,
        sunset: 1678286400,
        icon: '03d', // ⚡ ajouté ici
      ),
      // ... autres villes
    ];
  }
}