// presentation/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meteo_app/providers/weather_provider.dart';
import 'package:meteo_app/widgets/progress_gauge.dart';
import 'package:meteo_app/widgets/animated_message.dart';
import 'package:meteo_app/widgets/error_widget.dart';
import 'package:meteo_app/screens/result_screen.dart';



class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 15),
      vsync: this,
    );

    // Démarrer le chargement des données météo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeatherData();
    });
  }

  Future<void> _loadWeatherData() async {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);

    // Démarrer l'animation de progression
    _controller.forward();

    // Charger les données météo
    await weatherProvider.fetchWeatherData();

    // Arrêter l'animation
    _controller.stop();
  }

  void _retry() {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    weatherProvider.reset();
    _controller.reset();
    _loadWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Météo en Temps Réel'),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          // Afficher les erreurs
          if (weatherProvider.error.isNotEmpty) {
            return CustomErrorWidget(
              errorMessage: weatherProvider.error,
              onRetry: _retry,
            );
          }

          // Afficher le chargement
          if (weatherProvider.isLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProgressGauge(progress: _controller.value),
                SizedBox(height: 20),
                AnimatedMessage(),
                SizedBox(height: 10),
                Text(
                  weatherProvider.currentStatus,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  'Progression: ${weatherProvider.progress}%',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            );
          }

          // Afficher les résultats
          return ResultScreen(weatherData: weatherProvider.weatherData);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}