class WeatherModel {
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final double latitude;
  final double longitude;
  final double feelsLike;
  final int pressure;
  final int visibility;
  final int sunrise;
  final int sunset;
  final String icon; // icône OpenWeatherMap

  factory WeatherModel.empty() {
    return WeatherModel(
      cityName: "",
      temperature: 0.0,
      condition: "",
      humidity: 0,
      windSpeed: 0.0,
      latitude: 0.0,
      longitude: 0.0,
      feelsLike: 0.0,
      pressure: 0,
      visibility: 0,
      sunrise: 0,
      sunset: 0,
      icon: "",
    );
  }


  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.latitude,
    required this.longitude,
    required this.feelsLike,
    required this.pressure,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.icon, // ⚠ doit être fourni
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(), // déjà en Celsius
      condition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'].toDouble() * 3.6), // m/s → km/h
      latitude: json['coord']['lat'].toDouble(),
      longitude: json['coord']['lon'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      pressure: json['main']['pressure'],
      visibility: json['visibility'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      icon: json['weather'][0]['icon'],
    );
  }
}
