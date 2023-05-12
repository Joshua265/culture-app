import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationService {
  static Future<String?> getLocationName(
      double latitude, double longitude) async {
    final apiKey = dotenv.env['GEOCODING_API_KEY'];
    final url =
        'https://api.opencagedata.com/geocode/v1/json?q=$latitude+$longitude&key=$apiKey&pretty=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final results = jsonBody['results'] as List<dynamic>;
      final components = results.first['components'] as Map<String, dynamic>;

      return components['city'];
    } else {
      throw Exception('Failed to retrieve location name');
    }
  }
}
