import 'dart:ui';

import 'package:booking_app_client/util/langs/ar.dart';
import 'package:booking_app_client/util/langs/en.dart';
import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en': en, 'ar': ar};
  static final local = Locale('en');
  static final fallbackLocal = Locale('en');
}
