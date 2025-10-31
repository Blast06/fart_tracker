import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  final _locale = Rx<String>('es');

  String get locale => _locale.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language_code') ?? 'es';
    _locale.value = langCode;
  }

  Future<void> setLocale(String langCode) async {
    _locale.value = langCode;
    Get.updateLocale(Locale(langCode));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', langCode);
  }
}
