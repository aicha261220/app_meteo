// core/utils/theme_utils.dart
import 'package:flutter/material.dart';

class ThemeUtils {
  // Correction: Retourner IconData au lieu de String
  static IconData getWeatherIcon(String condition, {bool isDay = true}) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return isDay ? Icons.wb_sunny : Icons.nightlight;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'sand':
      case 'ash':
      case 'squall':
      case 'tornado':
        return Icons.blur_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  // Autres fonctions restent inchangées...
  static bool isDarkMode(BuildContext context) {
    return Theme
        .of(context)
        .brightness == Brightness.dark;
  }

  static Color getTextColorBasedOnBackground(Color backgroundColor) {
    final double luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  static Color getTemperatureColor(double temperature) {
    if (temperature < 0) {
      return Colors.blue[900]!;
    } else if (temperature < 10) {
      return Colors.blue[400]!;
    } else if (temperature < 20) {
      return Colors.green[400]!;
    } else if (temperature < 30) {
      return Colors.orange[400]!;
    } else {
      return Colors.red[400]!;
    }
  }

  static LinearGradient getWeatherGradient(String condition,
      BuildContext context) {
    final bool darkMode = isDarkMode(context);

    switch (condition.toLowerCase()) {
      case 'clear':
        return LinearGradient(
          colors: darkMode
              ? [Colors.blue[900]!, Colors.blue[700]!]
              : [Colors.blue[400]!, Colors.lightBlue[200]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'clouds':
        return LinearGradient(
          colors: darkMode
              ? [Colors.grey[800]!, Colors.grey[600]!]
              : [Colors.grey[300]!, Colors.grey[100]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    // ... autres cas
      default:
        return LinearGradient(
          colors: darkMode
              ? [Colors.grey[850]!, Colors.grey[700]!]
              : [Colors.grey[200]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  static Widget buildWeatherInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Temperature",
          style: Theme
              .of(context)
              .textTheme
              .headlineMedium,
        ),
        Text(
          "25°C",
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium,
        ),
        Text(
          "Humidity",
          style: Theme
              .of(context)
              .textTheme
              .titleMedium,
        ),
        Text(
          "80%",
          style: Theme
              .of(context)
              .textTheme
              .bodyMedium,
        ),
      ],
    );
  }
}
