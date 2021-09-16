import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/models/coupon.dart';
import 'package:ipsb_partner_app/src/models/paging.dart';
import 'package:ipsb_partner_app/src/routes/routes.dart';
import 'package:ipsb_partner_app/src/services/api/coupon_service.dart';

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
