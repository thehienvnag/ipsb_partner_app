import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/pages/sigin/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Bind Login controller
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
