import 'package:http/http.dart' as http;
import 'dart:convert';
import 'fart_service.dart';
import '../models/fart_log.dart';
import '../models/weekly_stats.dart';

class MyCustomApiService implements FartService {
  final String baseUrl;
  final String? authToken;

  MyCustomApiService({
    required this.baseUrl,
    this.authToken,
  });

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (authToken != null) 'Authorization': 'Bearer $authToken',
  };

  @override
  Future<void> initialize() async {
    // Initialize your API connection, authenticate, etc.
  }

  @override
  Future<FartLog> logFart(bool isSilent) async {
    final response = await http.post(
      Uri.parse('$baseUrl/farts'),
      headers: _headers,
      body: json.encode({
        'is_silent': isSilent,
        'logged_at': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      return FartLog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to log fart: ${response.statusCode}');
    }
  }

  @override
  Future<WeeklyStats> getWeeklyStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/stats/weekly'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeeklyStats(
        dailyCounts: List<int>.from(data['daily_counts']),
        totalWeek: data['total_week'],
        todayCount: data['today_count'],
      );
    } else {
      throw Exception('Failed to fetch stats: ${response.statusCode}');
    }
  }

  @override
  Future<void> resetDemo() async {
    final response = await http.delete(
      Uri.parse('$baseUrl/farts/reset'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reset: ${response.statusCode}');
    }
  }
}