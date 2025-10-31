import 'dart:math';
import 'fart_service.dart';
import '../models/fart_log.dart';
import '../models/weekly_stats.dart';

class MockFartService implements FartService {
  final List<FartLog> _mockLogs = [];
  final List<int> _weeklyData = [4, 7, 5, 3, 6, 2, 4];

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _generateMockData();
  }

  void _generateMockData() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    for (int day = 0; day < 7; day++) {
      final dayCount = _weeklyData[day];
      for (int i = 0; i < dayCount; i++) {
        final logDate = startOfWeek.add(Duration(
          days: day,
          hours: Random().nextInt(24),
          minutes: Random().nextInt(60),
        ));

        _mockLogs.add(FartLog(
          id: 'mock-${day}-${i}',
          userId: 'mock-user',
          loggedAt: logDate,
          isSilent: Random().nextBool(),
          createdAt: logDate,
        ));
      }
    }
  }

  @override
  Future<FartLog> logFart(bool isSilent) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final now = DateTime.now();
    final log = FartLog(
      id: 'mock-${DateTime.now().millisecondsSinceEpoch}',
      userId: 'mock-user',
      loggedAt: now,
      isSilent: isSilent,
      createdAt: now,
    );

    _mockLogs.add(log);
    _weeklyData[6]++;

    return log;
  }

  @override
  Future<WeeklyStats> getWeeklyStats() async {
    await Future.delayed(const Duration(milliseconds: 150));

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    final todayLogs = _mockLogs.where((log) {
      return log.loggedAt.isAfter(todayStart) ||
             log.loggedAt.isAtSameMomentAs(todayStart);
    }).length;

    final totalWeek = _weeklyData.reduce((a, b) => a + b);

    return WeeklyStats(
      dailyCounts: List.from(_weeklyData),
      totalWeek: totalWeek,
      todayCount: todayLogs,
    );
  }

  @override
  Future<void> resetDemo() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _mockLogs.clear();
    _weeklyData.setAll(0, [4, 7, 5, 3, 6, 2, 4]);
    _generateMockData();
  }
}
