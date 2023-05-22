import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/event.dart';

class EventService {
  static final String _baseUrl = dotenv.env['API_BASE_URL']!;

  static Future<List<Event>> getEvents(String city) async {
    final response = await http.get(Uri.parse('$_baseUrl/events?city=$city'));
    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body) as List<dynamic>;

      final events = jsonList.map((json) => Event.fromJson(json)).toList();
      return events;
    } else {
      throw Exception('Failed to load events');
    }
  }

  static Future<List<Event>> getEventsByCategory({
    required String category,
    required String city,
    int limit = 10,
    int skip = 0,
  }) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/events?mediaCategory=${category.toString()}&limit=$limit&skip=$skip'));
    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body) as List<dynamic>;
      final events = jsonList.map((json) => Event.fromJson(json)).toList();
      return events;
    } else {
      throw Exception('Failed to load events');
    }
  }

  static Future<List<Event>> getEventsByContentId(String contentId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/events?content_id=$contentId'));
    if (response.statusCode == 200) {
      final List<dynamic> eventsJson = json.decode(response.body)['data'];
      final List<Event> events =
          eventsJson.map((json) => Event.fromJson(json)).toList();
      return events;
    } else {
      throw Exception('Failed to fetch events by content id');
    }
  }

  static Future<List<Event>> getEventsByTimeFrame(
      String city, DateTime timeframeStart, DateTime timeframeEnd) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/events?city=$city&timeframe_start=${timeframeStart.toIso8601String()}&timeframe_end=${timeframeEnd.toIso8601String()}'));
    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body) as List<dynamic>;

      if (jsonList.isEmpty) {
        return [];
      }
      final events = jsonList.map((json) => Event.fromJson(json)).toList();
      return events;
    } else {
      throw Exception('Failed to load events');
    }
  }
}
