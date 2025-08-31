// core/utils/error_utils.dart
import 'dart:io';
import 'package:meteo_app/constants/strings.dart';

class ErrorUtils {
  // Handle API errors and return user-friendly messages
  static String handleApiError(dynamic error) {
    if (error is SocketException) {
      return AppStrings.connectionError;
    } else if (error is HttpException) {
      return AppStrings.serverError;
    } else if (error is FormatException) {
      return 'Erreur de format des données';
    } else if (error is TimeoutException) {
      return AppStrings.timeoutError;
    } else if (error is String) {
      return error;
    } else {
      return error.toString().isNotEmpty
          ? error.toString()
          : AppStrings.unknownError;
    }
  }

  // Handle location errors - CORRECTION ICI
  static String handleLocationError(dynamic error) {
    if (error is Exception) {
      if (error.toString().contains('permission') || error.toString().contains('Permission')) {
        return 'Permission de localisation refusée';
      } else if (error.toString().contains('service') || error.toString().contains('Service')) {
        return 'Service de localisation désactivé';
      } else if (error.toString().contains('timeout') || error.toString().contains('Timeout')) {
        return 'Timeout de localisation';
      }
    }
    return handleApiError(error);
  }

  // Check if error is a connection error
  static bool isConnectionError(String error) {
    return error == AppStrings.connectionError ||
        error.toLowerCase().contains('connection') ||
        error.toLowerCase().contains('internet') ||
        error.toLowerCase().contains('network');
  }

  // Check if error is a server error
  static bool isServerError(String error) {
    return error == AppStrings.serverError ||
        error.toLowerCase().contains('server') ||
        error.toLowerCase().contains('http') ||
        error.contains('50') ||
        error.contains('40');
  }

  // Get appropriate icon for error type
  static String getErrorIcon(String error) {
    if (isConnectionError(error)) {
      return '📡';
    } else if (isServerError(error)) {
      return '🚫';
    } else if (error.toLowerCase().contains('timeout')) {
      return '⏰';
    } else {
      return '❓';
    }
  }

  // Get appropriate action button text
  static String getErrorActionText(String error) {
    if (isConnectionError(error)) {
      return 'Vérifier la connexion';
    } else if (isServerError(error)) {
      return 'Réessayer plus tard';
    } else {
      return 'Réessayer';
    }
  }
}