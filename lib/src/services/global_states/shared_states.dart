import 'package:get/get.dart';
import 'package:indoor_positioning_visitor/src/models/account.dart';
import 'package:indoor_positioning_visitor/src/models/coupon.dart';
import 'package:indoor_positioning_visitor/src/models/coupon_in_use.dart';

class SharedStates extends GetxService {
  /// selected bottom bar index
  final bottomBarSelectedIndex = 0.obs;

  /// Coupon in use state
  final couponInUse = CouponInUse().obs;

  /// Coupon state
  final coupon = Coupon().obs;

  /// Save the coupon in use detail
  void saveCouponInUse(value) => couponInUse.value = value;

  /// Save the coupon detail
  void saveCoupon(value) => coupon.value = value;

  // User login in app
  Account? account;
}
