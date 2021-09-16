import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/pages/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Bind Home controller
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
