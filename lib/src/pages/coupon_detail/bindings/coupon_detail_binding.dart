import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/pages/coupon_detail/controllers/coupon_detail_controller.dart';

class CouponDetailBinding extends Bindings {
  @override
  void dependencies() {
    // Bind CouponDetail controller
    Get.lazyPut<CouponDetailController>(() => CouponDetailController());
  }
}
