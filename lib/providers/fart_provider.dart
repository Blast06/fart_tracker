import 'package:fart_hero/models/badge.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weekly_stats.dart';
import '../services/fart_service.dart';

class FartController extends GetxController {
  final FartService _service;

  final stats = Rx<WeeklyStats>(WeeklyStats.empty());
  final isLoading = false.obs;
  final isSilentMode = false.obs;
  final error = ''.obs;

  FartController(this._service);

  List<BadgeModel> get badges => [
        BadgeModel(
          emoji: '🤫',
          titleKey: 'badgeSilentTitle',
          descriptionKey: 'badgeSilentDesc',
        ),
        BadgeModel(
          emoji: '🎺',
          titleKey: 'badgeTrumpetTitle',
          descriptionKey: 'badgeTrumpetDesc',
        ),
        BadgeModel(
          emoji: '🚀',
          titleKey: 'badgeElevatorTitle',
          descriptionKey: 'badgeElevatorDesc',
        ),
        BadgeModel(
          emoji: '👑',
          titleKey: 'badgeStreakTitle',
          descriptionKey: 'badgeStreakDesc',
        ),
      ];

  @override
  Future<void> onInit() async {
    super.onInit();
    await initialize();
  }

  Future<void> initialize() async {
    isLoading.value = true;

    try {
      await _service.initialize();
      await loadStats();
      await _loadSilentMode();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStats() async {
    try {
      stats.value = await _service.getWeeklyStats();
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> logFart() async {
    try {
      await _service.logFart(isSilentMode.value);
      await loadStats();
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> resetDemo() async {
    try {
      await _service.resetDemo();
      await loadStats();
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> toggleSilentMode() async {
    isSilentMode.toggle();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('silent_mode', isSilentMode.value);
  }

  Future<void> _loadSilentMode() async {
    final prefs = await SharedPreferences.getInstance();
    isSilentMode.value = prefs.getBool('silent_mode') ?? false;
  }
}
