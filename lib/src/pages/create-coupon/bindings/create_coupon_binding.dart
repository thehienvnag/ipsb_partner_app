import 'package:get/get.dart';

import 'package:ipsb_partner_app/src/pages/create-coupon/controllers/create_coupon_controller.dart';

class CreateCouponBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateCouponController>(() => CreateCouponController());
  }
}
