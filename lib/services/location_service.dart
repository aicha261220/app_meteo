// core/services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:meteo_app/utils/error_utils.dart';

class LocationService {
  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      throw Exception('Erreur de vérification des services de localisation');
    }
  }

  // Check location permissions
  Future<LocationPermission> checkPermission() async {
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      throw Exception('Erreur de vérification des permissions');
    }
  }

  // Request location permissions
  Future<LocationPermission> requestPermission() async {
    try {
      return await Geolocator.requestPermission();
    } catch (e) {
      throw Exception('Erreur de demande de permissions');
    }
  }

  // Get current position - CORRECTION ICI
  Future<Position> getCurrentPosition() async {
    try {
      final bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Les services de localisation sont désactivés');
      }

      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permissions de localisation refusées');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permissions de localisation définitivement refusées');
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    } catch (e) {
      // CORRECTION ICI: Utiliser handleLocationError correctement
      final errorMessage = ErrorUtils.handleLocationError(e);
      throw Exception(errorMessage);
    }
  }

  // Calculate distance between two coordinates (in kilometers)
  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    ) /
        1000;
  }

  // Get address from coordinates
  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final places = await Geolocator.placemarkFromCoordinates(lat, lng);
      if (places.isNotEmpty) {
        final place = places.first;
        return '${place.locality}, ${place.country}';
      }
      return 'Localisation inconnue';
    } catch (e) {
      throw Exception('Impossible de récupérer l\'adresse');
    }
  }
}