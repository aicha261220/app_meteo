import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:meteo_app/models/weather_model.dart';
import 'package:meteo_app/utils/theme_utils.dart';
import 'package:meteo_app/constants/strings.dart';

class CityDetailScreen extends StatelessWidget {
  final WeatherModel weather;

  const CityDetailScreen({Key? key, required this.weather}) : super(key: key);

  Future<void> _openMap() async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${weather.latitude},${weather.longitude}';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Impossible d\'ouvrir la carte: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weather.cityName),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: _openMap,
            tooltip: 'Ouvrir dans Google Maps',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Carte de présentation
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Conditions actuelles',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Correction: Utiliser Icon avec IconData
                        Icon(
                          ThemeUtils.getWeatherIcon(weather.condition),
                          size: 64,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weather.temperature.toStringAsFixed(1)}°C',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: ThemeUtils.getTemperatureColor(weather.temperature),
                              ),
                            ),
                            Text(
                              weather.condition,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Détails météo
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildDetailCard(
                  context,
                  Icons.thermostat,
                  AppStrings.temperatureLabel,
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  Colors.red,
                ),
                _buildDetailCard(
                  context,
                  Icons.water_drop,
                  AppStrings.humidityLabel,
                  '${weather.humidity}%',
                  Colors.blue,
                ),
                _buildDetailCard(
                  context,
                  Icons.air,
                  'Vitesse du vent',
                  '${weather.windSpeed} km/h',
                  Colors.green,
                ),
                _buildDetailCard(
                  context,
                  Icons.compress,
                  'Pression',
                  '${weather.pressure} hPa',
                  Colors.orange,
                ),
              ],
            ),

            SizedBox(height: 20),

            // Bouton Google Maps
            Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.map, color: Colors.blue),
                title: Text('Voir sur Google Maps'),
                subtitle: Text('Ouvrir la localisation exacte'),
                trailing: Icon(Icons.arrow_forward),
                onTap: _openMap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, IconData icon, String title, String value, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}