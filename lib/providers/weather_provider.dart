// presentation/providers/weather_provider.dart
import 'package:flutter/foundation.dart';
import 'package:meteo_app/models/weather_model.dart';
import 'package:meteo_app/repositories/weather_repository.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherRepository weatherRepository;

  WeatherProvider({required this.weatherRepository});

  // États de l'application
  List<WeatherModel> _weatherData = [];
  bool _isLoading = false;
  String _error = '';
  int _progress = 0;
  String _currentStatus = 'Prêt à charger';
  int _loadedCities = 0;
  int _totalCities = 0;

  // Getters
  List<WeatherModel> get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get progress => _progress;
  String get currentStatus => _currentStatus;
  int get loadedCities => _loadedCities;
  int get totalCities => _totalCities;

  // Charger les données météo
  Future<void> fetchWeatherData() async {
    _isLoading = true;
    _error = '';
    _progress = 0;
    _loadedCities = 0;
    _totalCities = 0;
    _currentStatus = 'Initialisation...';
    notifyListeners();

    try {
      _currentStatus = 'Connexion à l\'API météo...';
      notifyListeners();

      // Simuler un délai pour l'animation
      await Future.delayed(Duration(milliseconds: 500));

      _weatherData = await weatherRepository.fetchAllCitiesWeather(
          onProgress: (loaded, total) {
            _loadedCities = loaded;
            _totalCities = total;
            _progress = ((loaded / total) * 100).toInt();
            _currentStatus = 'Chargement: $loaded/$total villes';
            notifyListeners();
          }
      );

      _error = '';
      _progress = 100;
      _currentStatus = 'Données chargées avec succès';

    } catch (e) {
      _error = e.toString();
      _currentStatus = 'Erreur lors du chargement';
      print('❌ Erreur dans WeatherProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Rafraîchir les données
  Future<void> refreshData() async {
    if (_isLoading) return;

    _weatherData = [];
    _error = '';
    notifyListeners();

    await fetchWeatherData();
  }

  // Réinitialiser l'état
  void reset() {
    _weatherData = [];
    _error = '';
    _progress = 0;
    _loadedCities = 0;
    _totalCities = 0;
    _currentStatus = 'Prêt à charger';
    notifyListeners();
  }

  // Vérifier si des données sont disponibles
  bool get hasData => _weatherData.isNotEmpty;

  // Vérifier s'il y a une erreur
  bool get hasError => _error.isNotEmpty;

  // Obtenir les données d'une ville spécifique
  WeatherModel? getWeatherForCity(String cityName) {
    return _weatherData.firstWhere(
          (weather) => weather.cityName.toLowerCase() == cityName.toLowerCase(),
      orElse: () => WeatherModel.empty(),
    );
  }
}
