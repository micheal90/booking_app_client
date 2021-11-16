import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslateController extends GetxController {
  String _selectedLang = 'en';
  String get selectedLang => _selectedLang;
  @override
  void onInit() async {
    super.onInit();
    String? lang = await getLanguageFromLocal();
    if (lang == null) {
      changeLanguage(_selectedLang);
    } else if (lang == 'ar') {
      changeLanguage(lang);
    } else {
      changeLanguage(lang);
    }
  }

  void changeLanguage(String lang) async {
    if (lang == _selectedLang) return;
    _selectedLang = lang;
    await saveLanguageLocal(lang).then((value) {
      if (value) {
        Get.updateLocale(Locale(lang));
      }
    });
    update();
  }

  Future<bool> saveLanguageLocal(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('lang', lang);
  }

  Future<String?> getLanguageFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lang');
  }
}
