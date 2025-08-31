class AppConstants {
  // API Configuration - REMPLACEZ PAR VOTRE CLÉ API RÉELLE
  static const String apiKey = 'your_openweather_api_key_here';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String weatherEndpoint = '/weather';
  static const String units = 'metric'; // metric for Celsius

  // Liste des villes à surveiller
  static const List<String> cities = [
    'Paris',
    'Lyon',
    'Marseille',
    'Toulouse',
    'Bordeaux'
  ];

  // Configuration du timing
  static const Duration apiCallInterval = Duration(seconds: 2);
  static const Duration loadingDuration = Duration(seconds: 10);
  static const Duration messageRotationInterval = Duration(seconds: 3);

  // Configuration de l'animation
  static const Duration gaugeAnimationDuration = Duration(milliseconds: 500);

  // Configuration Google Maps
  static const double defaultMapZoom = 11.0;

  // Messages d'erreur
  static const String defaultError = 'Une erreur s\'est produite';

  // Configuration des tentatives
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}