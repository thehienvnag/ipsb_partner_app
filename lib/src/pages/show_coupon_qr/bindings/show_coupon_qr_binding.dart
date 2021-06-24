import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/pages/show_coupon_qr/controllers/show_coupon_qr_controller.dart';

class ShowCouponQRBinding extends Bindings {
  @override
  void dependencies() {
    // Bind Show Coupon QR controller
    Get.lazyPut<ShowCouponQRController>(() => ShowCouponQRController());
  }
}