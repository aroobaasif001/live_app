import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationsController extends GetxController {
  var selectedLanguage = 'English'.obs;

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
  }

  // Load language from SharedPreferences
  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('language');

    if (lang != null) {
      updateLanguage(lang, isInit: true);
    } else {
      updateLanguage('en', isInit: true); // Default to English
    }
  }

  // Function to update language and save it
  Future<void> updateLanguage(String lang, {bool isInit = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang); // Ensure it saves before UI updates

    if (lang == 'en') {
      Get.updateLocale(Locale('en'));
      selectedLanguage.value = 'English';
    } else if (lang == 'ru') {
      Get.updateLocale(Locale('ru'));
      selectedLanguage.value = 'Russian';
    }

    if (!isInit) {
      update(); // Refresh UI listeners if not initialization
    }
  }
}