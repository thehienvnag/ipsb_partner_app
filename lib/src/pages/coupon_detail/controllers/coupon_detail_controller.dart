import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/models/coupon.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/global_states/shared_states.dart';

class CouponDetailController extends GetxController {

  /// Shared data
  final SharedStates sharedData = Get.find();

  void gotoCouponDetails(Coupon coupon) {
    sharedData.coupon.value = coupon;
    Get.toNamed(Routes.storeDetails);
  }

}
