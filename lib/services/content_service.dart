import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/content.dart';

class ContentService {
  static final String _baseUrl = dotenv.env['API_BASE_URL']!;

  static Future<List<Content>> getContents() async {
    final response = await http.get(Uri.parse('$_baseUrl/content'));

    if (response.statusCode == 200) {
      final List<dynamic> contentsJson = jsonDecode(response.body);
      return contentsJson.map((e) => Content.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch content');
    }
  }
}
