import 'package:supabase_flutter/supabase_flutter.dart';
import 'fart_service.dart';
import '../models/fart_log.dart';
import '../models/weekly_stats.dart';

class SupabaseFartService implements FartService {
  final SupabaseClient _supabase;

  SupabaseFartService(this._supabase);

  @override
  Future<void> initialize() async {
  }

  @override
  Future<FartLog> logFart(bool isSilent) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final data = await _supabase.from('farts').insert({
      'user_id': user.id,
      'logged_at': DateTime.now().toIso8601String(),
      'is_silent': isSilent,
    }).select().single();

    return FartLog.fromJson(data);
  }

  @override
  Future<WeeklyStats> getWeeklyStats() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfDay = DateTime(now.year, now.month, now.day);

    final logs = await _supabase
        .from('farts')
        .select()
        .eq('user_id', user.id)
        .gte('logged_at', startOfWeek.toIso8601String())
        .order('logged_at');

    final dailyCounts = List.filled(7, 0);
    int todayCount = 0;

    for (final log in logs) {
      final fartLog = FartLog.fromJson(log);
      final dayOfWeek = fartLog.loggedAt.weekday - 1;
      if (dayOfWeek >= 0 && dayOfWeek < 7) {
        dailyCounts[dayOfWeek]++;
      }

      if (fartLog.loggedAt.isAfter(startOfDay) ||
          fartLog.loggedAt.isAtSameMomentAs(startOfDay)) {
        todayCount++;
      }
    }

    final totalWeek = dailyCounts.reduce((a, b) => a + b);

    return WeeklyStats(
      dailyCounts: dailyCounts,
      totalWeek: totalWeek,
      todayCount: todayCount,
    );
  }

  @override
  Future<void> resetDemo() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    await _supabase.from('farts').delete().eq('user_id', user.id);
  }
}
