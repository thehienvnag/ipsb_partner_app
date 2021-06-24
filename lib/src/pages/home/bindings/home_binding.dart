import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/pages/home/controllers/home_controller.dart';
import 'package:indoor_positioning_visitor/src/pages/my_coupons/controllers/my_coupon_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Bind Home controller
    Get.lazyPut<HomeController>(() => HomeController());
    // Bind My Coupon controller
    Get.lazyPut<MyCouponController>(() => MyCouponController());
  }
}
