# API Implementation Guide

This guide explains how to implement your own API service for the Fart Hero app.

## Service Architecture

The app uses an abstract `FartService` interface that defines all required methods. You can implement this interface to connect to any backend API.

### Interface Definition

```dart
abstract class FartService {
  Future<void> initialize();
  Future<FartLog> logFart(bool isSilent);
  Future<WeeklyStats> getWeeklyStats();
  Future<void> resetDemo();
}
```

## Implementation Steps

### 1. Create Your Service Class

Create a new file in `lib/services/` (e.g., `my_custom_api_service.dart`):

```dart
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
```

### 2. Update main.dart

Replace the service instantiation in `lib/main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localeProvider = LocaleProvider();
  await localeProvider.initialize();

  // Use your custom API service
  final fartService = MyCustomApiService(
    baseUrl: 'https://your-api.com/api',
    authToken: 'your-auth-token-here',
  );

  final fartProvider = FartProvider(fartService);
  await fartProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: fartProvider),
      ],
      child: const MyApp(),
    ),
  );
}
```

## API Endpoints Reference

Your backend API should implement these endpoints:

### POST /farts
Log a new fart entry.

**Request:**
```json
{
  "is_silent": false,
  "logged_at": "2024-01-15T10:30:00Z"
}
```

**Response (201):**
```json
{
  "id": "uuid",
  "user_id": "uuid",
  "logged_at": "2024-01-15T10:30:00Z",
  "is_silent": false,
  "created_at": "2024-01-15T10:30:00Z"
}
```

### GET /stats/weekly
Get weekly statistics.

**Response (200):**
```json
{
  "daily_counts": [4, 7, 5, 3, 6, 2, 4],
  "total_week": 31,
  "today_count": 4
}
```

### DELETE /farts/reset
Reset all fart logs (for demo purposes).

**Response (200):**
```json
{
  "message": "Reset successful"
}
```

## Example: REST API Implementation

Here's a complete example with error handling:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'fart_service.dart';
import '../models/fart_log.dart';
import '../models/weekly_stats.dart';

class RestApiFartService implements FartService {
  final String baseUrl;
  String? _accessToken;

  RestApiFartService({required this.baseUrl});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  @override
  Future<void> initialize() async {
    // Perform authentication or initialization
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': 'user@example.com',
          'password': 'password',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
      }
    } catch (e) {
      throw Exception('Failed to initialize: $e');
    }
  }

  @override
  Future<FartLog> logFart(bool isSilent) async {
    try {
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
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to log fart: $e');
    }
  }

  @override
  Future<WeeklyStats> getWeeklyStats() async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

      final response = await http.get(
        Uri.parse('$baseUrl/stats/weekly?start=${startOfWeek.toIso8601String()}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeeklyStats(
          dailyCounts: List<int>.from(data['daily_counts']),
          totalWeek: data['total_week'] as int,
          todayCount: data['today_count'] as int,
        );
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch stats: $e');
    }
  }

  @override
  Future<void> resetDemo() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/farts'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to reset: $e');
    }
  }
}
```

## Example: GraphQL Implementation

```dart
import 'package:graphql_flutter/graphql_flutter.dart';
import 'fart_service.dart';
import '../models/fart_log.dart';
import '../models/weekly_stats.dart';

class GraphQLFartService implements FartService {
  late GraphQLClient _client;
  final String endpoint;

  GraphQLFartService({required this.endpoint});

  @override
  Future<void> initialize() async {
    final httpLink = HttpLink(endpoint);

    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );
  }

  @override
  Future<FartLog> logFart(bool isSilent) async {
    const mutation = r'''
      mutation LogFart($isSilent: Boolean!, $loggedAt: DateTime!) {
        createFart(isSilent: $isSilent, loggedAt: $loggedAt) {
          id
          userId
          loggedAt
          isSilent
          createdAt
        }
      }
    ''';

    final result = await _client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {
          'isSilent': isSilent,
          'loggedAt': DateTime.now().toIso8601String(),
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return FartLog.fromJson(result.data!['createFart']);
  }

  @override
  Future<WeeklyStats> getWeeklyStats() async {
    const query = r'''
      query GetWeeklyStats {
        weeklyStats {
          dailyCounts
          totalWeek
          todayCount
        }
      }
    ''';

    final result = await _client.query(
      QueryOptions(document: gql(query)),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data!['weeklyStats'];
    return WeeklyStats(
      dailyCounts: List<int>.from(data['dailyCounts']),
      totalWeek: data['totalWeek'],
      todayCount: data['todayCount'],
    );
  }

  @override
  Future<void> resetDemo() async {
    const mutation = r'''
      mutation ResetFarts {
        deleteAllFarts {
          success
        }
      }
    ''';

    final result = await _client.mutate(
      MutationOptions(document: gql(mutation)),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
  }
}
```

## Testing Your Implementation

1. **Unit Tests**: Test each method independently
```dart
void main() {
  group('Custom API Service', () {
    late MyCustomApiService service;

    setUp(() {
      service = MyCustomApiService(
        baseUrl: 'https://test-api.com',
      );
    });

    test('logFart creates new entry', () async {
      final result = await service.logFart(false);
      expect(result, isA<FartLog>());
    });

    test('getWeeklyStats returns valid data', () async {
      final stats = await service.getWeeklyStats();
      expect(stats.dailyCounts.length, 7);
      expect(stats.totalWeek, greaterThanOrEqualTo(0));
    });
  });
}
```

2. **Integration Tests**: Test with real API endpoints

3. **Error Handling**: Ensure graceful failure with network issues

## Best Practices

1. **Error Handling**: Always wrap API calls in try-catch blocks
2. **Authentication**: Store tokens securely (use flutter_secure_storage)
3. **Caching**: Consider caching responses for better performance
4. **Loading States**: Use the provider's isLoading flag
5. **Retry Logic**: Implement exponential backoff for failed requests
6. **Timeouts**: Set reasonable timeouts for API calls
7. **Logging**: Add proper logging for debugging

## Need Help?

- Check `mock_fart_service.dart` for a simple reference implementation
- Check `supabase_fart_service.dart` for a production-ready example
- Review the `FartProvider` class to understand state management
