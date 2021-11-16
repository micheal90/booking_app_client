import 'package:booking_app_client/util/langs/translate_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TranslateController());
  }
}
