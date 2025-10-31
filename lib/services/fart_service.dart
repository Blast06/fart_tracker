import '../models/fart_log.dart';
import '../models/weekly_stats.dart';

abstract class FartService {
  Future<void> initialize();
  Future<FartLog> logFart(bool isSilent);
  Future<WeeklyStats> getWeeklyStats();
  Future<void> resetDemo();
}
