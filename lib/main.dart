import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'providers/fart_provider.dart';
import 'providers/locale_provider.dart';
import 'services/mock_fart_service.dart';
import 'screens/home_screen.dart';
import 'l10n/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final fartService = MockFartService();

  Get.put(LocaleController());
  Get.put(FartController(fartService));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fart Hero',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: const Locale('es', 'ES'),
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF22C55E)),
      ),
      home: const HomeScreen(),
    );
  }
}
