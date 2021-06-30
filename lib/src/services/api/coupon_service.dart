import 'package:indoor_positioning_visitor/src/common/endpoints.dart';
import 'package:indoor_positioning_visitor/src/models/coupon.dart';
import 'package:indoor_positioning_visitor/src/models/paging.dart';
import 'package:indoor_positioning_visitor/src/services/api/base_service.dart';

mixin ICouponService {
  Future<Paging<Coupon>> getCoupons();
  Future<Paging<Coupon>> getCouponsByStoreId(int storeId);
  Future<bool> removeCoupon(int couponId);
  Future<Coupon> addCoupon(Map<String, dynamic> coupon, List<String> filePath);
}

class CouponService extends BaseService<Coupon> implements ICouponService {
  @override
  String endpoint() {
    return Endpoints.coupons;
  }

  @override
  Coupon fromJson(Map<String, dynamic> json) {
    return Coupon.fromJson(json);
  }

  Future<Paging<Coupon>> getCoupons() async {
    return getPagingBase({});
  }

  @override
  Future<Paging<Coupon>> getCouponsByStoreId(int storeId) {
    return getPagingBase(
      {
        'storeId': storeId.toString(),
        'status': 'Active',
      },
    );
  }

  @override
  Future<bool> removeCoupon(int couponId) {
    return deleteBase(couponId);
  }

  @override
  Future<Coupon> addCoupon(Map<String, dynamic> coupon, List<String> filePath) {
    return postWithFilesBase(coupon, filePath);
  }
}
