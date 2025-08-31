import 'dart:async';
import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../widgets/progress_gauge.dart';
import 'result_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final List<String> _messages = [
    'Nous téléchargeons les données…',
    'C’est presque fini…',
    'Plus que quelques secondes avant d’avoir le résultat…'
  ];
  int _currentMessageIndex = 0;
  double _progress = 0.0;
  List<WeatherModel> _weatherData = [];
  final WeatherService _weatherService = WeatherService();
  Timer? _messageTimer;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _startLoading();
    _startMessageRotation();
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startMessageRotation() {
    _messageTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentMessageIndex = (_currentMessageIndex + 1) % _messages.length;
      });
    });
  }

  void _startLoading() {
    final cities = ['Paris', 'Londres', 'New York', 'Tokyo', 'Sydney'];

    _progressTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_progress < 1.0) {
          _progress += 0.01;
        } else {
          timer.cancel();
        }
      });
    });

    _weatherService.getMultipleWeather(cities).then((weatherList) {
      setState(() {
        _weatherData = weatherList;
        _progress = 1.0;
      });

      // Attendre un peu pour montrer la jauge complète
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(weatherData: _weatherData),
          ),
        );
      });
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Impossible de charger les données météo. Veuillez réessayer.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _retryLoading();
              },
              child: Text('Réessayer'),
            ),
          ],
        ),
      );
    });
  }

  void _retryLoading() {
    setState(() {
      _progress = 0.0;
      _weatherData = [];
    });
    _startLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chargement en cours'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressGauge(
              progress: _progress,
              onComplete: _progress >= 1.0 ? _retryLoading : null,
            ),
            SizedBox(height: 30),
            Text(
              _messages[_currentMessageIndex],
              style: TextStyle(fontSize: 18),
            ),
            if (_progress >= 1.0) ...[
              SizedBox(height: 20),
              Text(
                'Terminé! Appuyez sur la jauge pour recommencer',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}