import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Vérifie et demande la permission de localisation
  static Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifie si le service de localisation est activé
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("⚠️ Service de localisation désactivé");
      return false;
    }

    // Vérifie les permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("⚠️ Permission refusée");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("⚠️ Permission refusée définitivement");
      return false;
    }

    return true;
  }

  /// Récupère la position actuelle
  static Future<Position?> getCurrentLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
