import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/models/coupon.dart';
import 'package:indoor_positioning_visitor/src/models/paging.dart';
import 'package:indoor_positioning_visitor/src/routes/routes.dart';
import 'package:indoor_positioning_visitor/src/services/api/coupon_service.dart';

class ManageCouponController extends GetxController {
  final listCoupon = <Coupon>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCouponsByStoreId();
  }

  ICouponService couponService = Get.find();
  Future<void> getCouponsByStoreId() async {
    Paging<Coupon> paging = await couponService.getCouponsByStoreId(18);
    listCoupon.value = paging.content ?? [];
  }

  Future<void> removeCoupon(int couponId) async {
    await couponService.removeCoupon(couponId);
    Get.back();
    getCouponsByStoreId();
  }

  Future<void> createCoupon() async {
    await Get.toNamed(Routes.createCoupon);
    getCouponsByStoreId();
  }
}
