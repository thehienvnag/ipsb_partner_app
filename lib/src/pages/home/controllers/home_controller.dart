import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/models/coupon.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/api/coupon_service.dart';

class HomeController extends GetxController {
  ICouponService _service = Get.find();

  final listCoupon = <Coupon>[].obs;

  Future<void> getCoupons() async {
    final paging = await _service.getCoupons();
    listCoupon.value = paging.content!;

    Get.back(result: 500);
    // Navigator.pop(context);

    Get.toNamed(Routes.home);

    //
    Get.offNamed(Routes.home);
  }

  void remove() {
    listCoupon.removeAt(0);
  }

  @override
  void onInit() {
    super.onInit();
    getCoupons();
  }
}
