import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageService {
  static final String _baseUrl = dotenv.env['API_BASE_URL']!;

  static Future<Uint8List> getImageBytes(String filename) async {
    final response = await http.get(Uri.parse('$_baseUrl/images/$filename'));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to fetch content');
    }
  }
}
