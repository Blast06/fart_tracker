class WeeklyStats {
  final List<int> dailyCounts;
  final int totalWeek;
  final int todayCount;

  WeeklyStats({
    required this.dailyCounts,
    required this.totalWeek,
    required this.todayCount,
  });

  factory WeeklyStats.empty() {
    return WeeklyStats(
      dailyCounts: List.filled(7, 0),
      totalWeek: 0,
      todayCount: 0,
    );
  }
}
