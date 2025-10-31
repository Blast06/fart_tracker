import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../providers/fart_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/gradient_card.dart';
import '../widgets/weekly_chart.dart';
import '../widgets/badge_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fartController = Get.find<FartController>();
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF3C4),
              Color(0xFFFFD6A5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '💨',
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'appTitle'.tr,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'languageLabel'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Obx(
                            () => DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: localeController.locale,
                                isDense: true,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1E293B),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'es',
                                    child: Text('Español'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'en',
                                    child: Text('English'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    localeController.setLocale(value);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () => ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      GradientCard(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'todayScore'.tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text(
                                  '🏅',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${fartController.stats.value.todayCount} 💨',
                              style: const TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF22C55E),
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _TipWidget(fartController: fartController),
                            const SizedBox(height: 16),
                            _ProgressBar(fartController: fartController),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await fartController.logFart();
                                  if (!fartController.isSilentMode.value) {
                                    HapticFeedback.lightImpact();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF22C55E),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'logButton'.tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GradientCard(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'weeklyBreakdown'.tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => fartController.resetDemo(),
                                  child: Text(
                                    'resetDemo'.tr,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF64748B),
                                      decoration: TextDecoration.underline,
                                      decorationStyle: TextDecorationStyle.dotted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            WeeklyChart(
                              dailyCounts: fartController.stats.value.dailyCounts,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GradientCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'badgesTitle'.tr,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.8,
                              ),
                              itemCount: fartController.badges.length,
                              itemBuilder: (context, index) {
                                return BadgeCard(
                                  badge: fartController.badges[index],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GradientCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'settings'.tr,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'stealthMode'.tr,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Obx(
                                  () => Switch(
                                    value: fartController.isSilentMode.value,
                                    onChanged: (_) =>
                                        fartController.toggleSilentMode(),
                                    activeColor: const Color(0xFF22C55E),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          'footer'.tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipWidget extends StatelessWidget {
  final FartController fartController;

  const _TipWidget({required this.fartController});

  @override
  Widget build(BuildContext context) {
    const weeklyGoal = 25;
    final toGo = (weeklyGoal - fartController.stats.value.totalWeek)
        .clamp(0, weeklyGoal);

    return Text(
      'tipToBreakRecord'.trParams({'count': toGo.toString()}),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF64748B),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final FartController fartController;

  const _ProgressBar({required this.fartController});

  @override
  Widget build(BuildContext context) {
    const weeklyGoal = 25;
    final progressPercent = (fartController.stats.value.totalWeek / weeklyGoal * 100)
        .clamp(0, 100);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progressPercent / 100,
        minHeight: 12,
        backgroundColor: const Color(0xFFE2E8F0),
        valueColor: const AlwaysStoppedAnimation<Color>(
          Color(0xFF22C55E),
        ),
      ),
    );
  }
}
