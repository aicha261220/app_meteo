// Dans core/utils/emoji_utils.dart
class EmojiUtils {
  static String getWeatherEmoji(String condition, {bool isDay = true}) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return isDay ? '☀️' : '🌙';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'sand':
      case 'ash':
      case 'squall':
      case 'tornado':
        return '🌫️';
      default:
        return '🌤️';
    }
  }
}