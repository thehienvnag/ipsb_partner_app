import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/models/coupon.dart';
import 'package:indoor_positioning_visitor/src/routes/routes.dart';
import 'package:indoor_positioning_visitor/src/services/api/coupon_service.dart';
import 'package:indoor_positioning_visitor/src/services/global_states/shared_states.dart';

class HomeController extends GetxController {
  ICouponService _service = Get.find();
  SharedStates _sharedStates = Get.find();

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
