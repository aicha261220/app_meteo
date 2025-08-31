import 'package:flutter/material.dart';
import 'package:meteo_app/models/weather_model.dart';
import 'package:meteo_app/utils/theme_utils.dart';
import 'package:meteo_app/screens/city_detail_screen.dart';
import 'package:meteo_app/constants/strings.dart';

class ResultScreen extends StatelessWidget {
  final List<WeatherModel> weatherData;

  const ResultScreen({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.weatherTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: weatherData.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(context),
              SizedBox(height: 20),
              _buildWeatherTable(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            AppStrings.noData,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final avgTemp = weatherData.map((w) => w.temperature).reduce((a, b) => a + b) / weatherData.length;
    final maxTemp = weatherData.map((w) => w.temperature).reduce((a, b) => a > b ? a : b);
    final minTemp = weatherData.map((w) => w.temperature).reduce((a, b) => a < b ? a : b);

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Résumé des villes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Moyenne', '${avgTemp.toStringAsFixed(1)}°C', Icons.thermostat),
                _buildSummaryItem('Max', '${maxTemp.toStringAsFixed(1)}°C', Icons.arrow_upward),
                _buildSummaryItem('Min', '${minTemp.toStringAsFixed(1)}°C', Icons.arrow_downward),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildWeatherTable(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(16),
        child: DataTable(
          columnSpacing: 20,
          columns: [
            DataColumn(
              label: Text(
                'Ville',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'Température',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'Condition',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'Vent',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'Actions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
          rows: weatherData.map((weather) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    weather.cityName,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ThemeUtils.getTemperatureColor(weather.temperature).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ThemeUtils.getTemperatureColor(weather.temperature),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      // Correction: Utiliser Icon avec IconData au lieu de Text avec emoji
                      Icon(
                        ThemeUtils.getWeatherIcon(weather.condition),
                        size: 20,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 8),
                      Text(weather.condition),
                    ],
                  ),
                ),
                DataCell(
                  Text('${weather.windSpeed} km/h'),
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.visibility, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityDetailScreen(weather: weather),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}