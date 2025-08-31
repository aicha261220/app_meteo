// presentation/widgets/error_widget.dart
import 'package:flutter/material.dart';
import 'package:meteo_app/utils/error_utils.dart';
import 'package:meteo_app/constants/strings.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isConnectionError = ErrorUtils.isConnectionError(errorMessage);
    final isApiKeyError = errorMessage.contains('API') || errorMessage.contains('clé');

    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isConnectionError ? Icons.wifi_off : Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              isConnectionError ? AppStrings.connectionError : AppStrings.errorTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            if (isApiKeyError) _buildApiKeyHelp(),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.refresh),
              label: Text(AppStrings.retryButton),
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeyHelp() {
    return Column(
      children: [
        Text(
          'Comment configurer votre clé API:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          '1. Allez sur openweathermap.org\n'
              '2. Créez un compte gratuit\n'
              '3. Générez une clé API\n'
              '4. Collez-la dans lib/core/constants/app_constants.dart',
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}